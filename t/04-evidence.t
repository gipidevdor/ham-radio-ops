use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO;
my $qso     = Ham::QSO->new;
my $session = $qso->session(station => 'IU0ABC');

for my $text (
    'IU0ABC DE DL1? R RST 599 KN',
    'IU0? DE DL1ABC R RST 599 KN',
    'IU0ABC DE DL1ABC NAME MARIO RST 599 KN'
    )
{
    $session->reset;
    event($session, 1, 'rx', $text);
    ok(!defined $session->snapshot->as_hash->{peer}, 'unknown text selects no peer');
    is_deeply($session->snapshot->facts, {}, 'unknown text proves no facts');
}
$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC RST 599 KN', uncertain => 1);
is_deeply($session->snapshot->facts, {}, 'uncertain full text proves nothing');
$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC R KN');
ok(!$session->snapshot->facts->{received_ack_for}, 'context-free R is not backfilled later');
event($session, 2, 'tx', 'DL1ABC DE IU0ABC RST 579 KN');
ok(!$session->snapshot->facts->{received_ack_for}, 'no retroactive acknowledgement');
$session->reset;
completed($session);
my $facts_before_foreign_cq = $session->snapshot->facts;
$session->receive('CQ DE F1ABC K', id => 'foreign-cq', at_ms => 29000, duration_ms => 500);
is_deeply($session->snapshot->facts,
    $facts_before_foreign_cq, 'unaddressed third-station CQ changes no contact facts or turn');
event($session, 4, 'rx', 'IU0ABC DE DL1ABC RST 589 KN');
ok($session->snapshot->complete, 'same report repetition preserves acknowledgement');
event($session, 5, 'rx', 'IU0ABC DE DL1ABC RST 559 KN');
ok(!$session->snapshot->complete && !$session->snapshot->facts->{sent_ack_for},
    'corrected RX report invalidates local ack');
event($session, 6, 'tx', 'DL1ABC DE IU0ABC R KN');
ok($session->snapshot->complete, 'explicit new acknowledgement restores proof');
event($session, 7, 'tx', 'DL1ABC DE IU0ABC RST 569 KN');
ok(!$session->snapshot->complete && !$session->snapshot->facts->{received_ack_for},
    'corrected TX report invalidates remote ack');
event($session, 8, 'rx', 'IU0ABC DE DL1ABC R KN');
ok($session->snapshot->complete, 'new remote ack restores proof');
event($session, 9, 'rx', 'G4ABC DE DL1ABC RST 111 KN');
is($session->snapshot->facts->{received_report}{value},
    '559', 'wrong recipient cannot change report');
event($session, 10, 'rx', 'IU0ABC DE F1ABC RST 119 KN');
is($session->snapshot->as_hash->{peer}, 'DL1ABC', 'no silent peer replacement');
throws(
    'QSO_E_SEQUENCE',
    sub { $session->select_peer(callsign => 'F1XYZ', evidence_id => 'e10') },
    'no invented peer'
);
$session->select_peer(callsign => 'F1ABC', evidence_id => 'e10');
is($session->snapshot->as_hash->{peer}, 'F1ABC', 'explicit correction backed by actual text');
ok(!$session->snapshot->complete && !$session->snapshot->facts->{sent_report},
    'correction clears dependent evidence');
my $before_selection = $session->snapshot->as_hash;
throws(
    'QSO_E_SEQUENCE',
    sub { $session->select_peer(callsign => 'DL1ABC', evidence_id => 'missing') },
    'missing evidence after an operator record is rejected cleanly'
);
is_deeply($session->snapshot->as_hash, $before_selection, 'failed selection preserves history');
my $selected = $session->select_peer(callsign => 'DL1ABC', evidence_id => 'e2')->as_hash;
is($selected->{peer}, 'DL1ABC', 'peer can be selected again after an operator record');
is_deeply(
    [@{$selected->{history}}[0 .. $#{$before_selection->{history}}]],
    $before_selection->{history},
    'successful selection preserves earlier observations and operator records'
);
is_deeply(event($session, 10, 'rx', 'IU0ABC DE F1ABC RST 119 KN')->as_hash,
    $selected, 'event replay remains idempotent after peer selection');
my $copy = $session->snapshot->history;
$copy->[0]{event}{text} = 'changed';
isnt($session->snapshot->history->[0]{event}{text}, 'changed', 'history accessor copies');
my $other = $qso->session(station => 'IU0ABC');
event($other, 1, 'tx', 'DL1ABC DE F1ABC RST 599 KN');
is_deeply($other->snapshot->facts, {}, 'mismatched actual source proves no exchange');
is($other->snapshot->conformance->{status}, 'violated', 'source conflict is explicit');

subtest 'Zero is a valid event ID and abort reason' => sub {
    $session->reset;
    $session->receive('IU0ABC DE DL1ABC RST 589 KN', id => '0', at_ms => 0, duration_ms => 100);
    is($session->select_peer(callsign => 'DL1ABC', evidence_id => '0')->state,
        'CONTACT', 'zero ID proves identification after peer selection');

    $session->reset;
    event($session, 1, 'tx', 'DL1ABC DE IU0ABC RST 579 KN');
    $session->receive(
        'IU0ABC DE DL1ABC R RST 589 KN',
        id          => '0',
        at_ms       => 10_000,
        duration_ms => 100
    );
    ok(
        event($session, 3, 'tx', 'DL1ABC DE IU0ABC R KN')->complete,
        'zero ID can prove identification in a complete exchange'
    );
    my $aborted = $session->abort(reason => '0');
    is($aborted->state, 'ABORTED', 'zero reason marks a session aborted');
    ok($aborted->terminated && $aborted->complete, 'abort preserves earlier completion');
    is_deeply($session->abort(reason => 'different')->as_hash,
        $aborted->as_hash, 'repeating abort preserves the original zero reason');
    throws('QSO_E_SEQUENCE', sub { $session->prepare }, 'preparation blocked after abort');

    $session->reset;
    $session->feed(
        direction   => 'tx',
        text        => 'DL1ABC DE IU0ABC CL',
        id          => '0',
        at_ms       => 0,
        duration_ms => 100
    );
    is($session->snapshot->state, 'CLOSING', 'zero ID proves local closure');
    throws('QSO_E_SEQUENCE', sub { $session->prepare }, 'closed station cannot prepare an over');
    ok(
        event($session, 2, 'rx', 'IU0ABC DE DL1ABC <SK>')->terminated,
        'both closings terminate with a zero ID on one side'
    );
    done_testing;
};

subtest 'Self-addressed observations do not establish a peer' => sub {
    $session->reset;
    event($session, 1, 'rx', 'IU0ABC DE IU0ABC RST 579 KN');
    throws(
        'QSO_E_SEQUENCE',
        sub { $session->select_peer(callsign => 'IU0ABC', evidence_id => 'e1') },
        'own callsign cannot be selected as the peer'
    );
    event($session, 2, 'tx', 'IU0ABC DE IU0ABC RST 599 KN');
    ok(!defined $session->snapshot->as_hash->{peer}, 'self-addressed TX does not establish a peer');
    is_deeply($session->snapshot->facts, {}, 'self-addressed traffic proves no exchange facts');
    done_testing;
};
done_testing;
