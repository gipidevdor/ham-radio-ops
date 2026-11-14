use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO;
my $qso     = Ham::QSO->new;
my $session = $qso->session(station => 'IU0ABC');
event($session, 1, 'tx', 'DL1ABC DE IU0ABC RST 579 KN');
event($session, 2, 'tx', 'DL1ABC DE IU0ABC AGN KN');
event($session, 3, 'rx', 'IU0ABC DE DL1ABC R RST 589 KN');
is($session->snapshot->facts->{received_message_ack_for},
    'e2', 'R acknowledges the repeat request over');
ok(
    !$session->snapshot->facts->{received_ack_for},
    'R does not retroactively confirm an older report'
);
event($session, 4, 'tx', 'DL1ABC DE IU0ABC R KN');
ok(!$session->snapshot->complete, 'both reports plus unrelated R do not complete a QSO');
event($session, 5, 'tx', 'DL1ABC DE IU0ABC RST 579 KN');
event($session, 6, 'rx', 'IU0ABC DE DL1ABC R KN');
ok($session->snapshot->complete,
    'explicit repeated report followed by R supplies the missing proof');
is($session->snapshot->facts->{received_message_ack_for},
    'e5', 'generic acknowledgement records actual over');
is($session->snapshot->facts->{received_ack_for},
    'e1', 'identical report value retains its original evidence identity');

$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC RST 589 KN');
event($session, 2, 'rx', 'IU0ABC DE DL1ABC AGN KN');
ok($session->prepare(ack => 1),
    'generic request acknowledgement can be prepared without claiming report reception');
event($session, 3, 'tx', 'DL1ABC DE IU0ABC R RST 579 KN');
is($session->snapshot->facts->{sent_message_ack_for}, 'e2',
    'local R acknowledges the request only');
ok(!$session->snapshot->facts->{sent_ack_for},
    'local R does not certify the older received report');
event($session, 4, 'rx', 'IU0ABC DE DL1ABC R KN');
ok(!$session->snapshot->complete,
    'remote confirmation does not repair missing local report acknowledgement');
event($session, 5, 'rx', 'IU0ABC DE DL1ABC RST 589 KN');
ok($session->prepare(ack => 1), 'fresh unambiguous repeat allows preparation');
event($session, 6, 'tx', 'DL1ABC DE IU0ABC R KN');
ok($session->snapshot->complete, 'actual local acknowledgement completes the repaired exchange');

for my $case (['tx', 'DL1? DE IU0ABC KN', 0], ['tx', 'DL1ABC DE IU0ABC RST 579 KN', 1]) {
    $session->reset;
    event($session, 1, 'tx',       'DL1ABC DE IU0ABC RST 579 KN');
    event($session, 2, $case->[0], $case->[1], uncertain => $case->[2]);
    event($session, 3, 'rx',       'IU0ABC DE DL1ABC R RST 589 KN');
    ok(!$session->snapshot->facts->{received_ack_for},
        'unknown or uncertain intervening TX blocks report association');
    ok(grep($_->{code} eq 'QSO_W_ACK_CONTEXT', @{$session->snapshot->diagnostics}),
        'ambiguous R context is explicit');
}
$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC RST 589 KN');
event($session, 2, 'rx', 'IU0ABC DE DL1ABC RST 599 KN', uncertain => 1);
throws(
    'QSO_E_SEQUENCE',
    sub { $session->prepare(ack => 1) },
    'uncertain RX blocks prepared acknowledgement'
);
is($session->snapshot->facts->{received_report}{value},
    '589', 'older report remains received but unconfirmed');

$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC RST 589 KN');
event($session, 2, 'rx', 'CQ DE F1ABC K');
event($session, 3, 'tx', 'DL1ABC DE IU0ABC R RST 579 KN');
is($session->snapshot->facts->{sent_ack_for},
    'e1', 'unrelated CQ does not destroy the peer report context');
event($session, 4, 'rx', 'G4ABC DE F1ABC RST 599 KN');
event($session, 5, 'rx', 'IU0ABC DE DL1ABC R KN');
ok($session->snapshot->complete,
    'known third-party traffic cannot redirect acknowledgement evidence');

$session->reset;
event($session, 1, 'tx', 'DL1ABC DE IU0ABC RST 579 KN');
event($session, 2, 'tx', 'CQ DE IU0ABC K');
event($session, 3, 'rx', 'IU0ABC DE DL1ABC R RST 589 KN');
ok(
    !$session->snapshot->facts->{received_ack_for},
    'R after a local CQ cannot confirm an earlier report'
);
$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC RST 589 KN');
event($session, 2, 'rx', 'CQ DE DL1ABC K');
throws(
    'QSO_E_SEQUENCE',
    sub { $session->prepare(ack => 1) },
    'new peer broadcast removes directed report context'
);
done_testing;
