use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO;
my $qso      = Ham::QSO->new;
my $session  = $qso->session(station => 'IU0ABC');
my $before   = $session->snapshot->as_hash;
my $proposal = $session->prepare(kind => 'cq');
is_deeply($session->snapshot->as_hash, $before, 'preparing does not mutate anything');
throws(
    'QSO_E_SEQUENCE',
    sub { $session->prepare(to => 'DL1ABC', ack => 1) },
    'no acknowledgement before report'
);
my $tx = $session->transmitted($proposal, id => 'cq1', at_ms => 0, duration_ms => 1000);
is($tx->state,                 'CALLING',       'actual transmission advances session');
is($tx->conformance->{status}, 'indeterminate', 'Italian timing absence remains unknown');
throws('QSO_E_STALE', sub { $session->transmitted($proposal) }, 'stale preparation');
$session->reset;
throws('QSO_E_STALE', sub { $session->transmitted($proposal) }, 'reset invalidates proposal');
my $result = completed($session);
ok($result->complete,    'both identities, reports and acknowledgements satisfy QSO predicate');
ok(!$result->terminated, 'completion does not imply closure');
is($result->state,                       'COMPLETE',  'complete state');
is($result->conformance->{status},       'satisfied', 'supplied evidence satisfies checked scope');
is($result->conformance->{legal_status}, 'not_assessed', 'never claims absolute legal approval');
my $copy = $result->facts;
$copy->{sent_report}{value} = '111';
is($result->facts->{sent_report}{value}, '579', 'immutable public snapshot');
event($session, 4, 'rx', 'IU0ABC DE DL1ABC 73 KN');
ok(!$session->snapshot->terminated, '73 is not closure');
event($session, 5, 'rx', 'IU0ABC DE DL1ABC 73 <SK>');
is($session->snapshot->state, 'CLOSING', 'one party closing');
throws(
    'QSO_E_SEQUENCE',
    sub { $session->prepare(report => '579') },
    'only final closing after peer closure'
);
event($session, 6, 'tx', 'DL1ABC DE IU0ABC 73 <SK>');
ok($session->snapshot->terminated && $session->snapshot->complete,
    'closure preserves completed exchange');
throws('QSO_E_SEQUENCE', sub { $session->prepare() }, 'no preparation after local close');
event($session, 7, 'rx', 'IU0ABC DE DL1ABC RST 599 KN');
ok(grep($_->{code} eq 'QSO_V_ENDED', @{$session->snapshot->diagnostics}),
    'late evidence diagnosed');
my $last = $session->finish->as_hash;
is_deeply($session->finish->as_hash, $last, 'finish idempotent');
throws('QSO_E_LIFECYCLE', sub { $session->receive('R') },            'feed after finish');
throws('QSO_E_LIFECYCLE', sub { $session->abort(reason => 'done') }, 'abort after finish');
$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC 73 <SK>');
event($session, 2, 'tx', 'DL1ABC DE IU0ABC 73 CL');
ok($session->snapshot->terminated && !$session->snapshot->complete, 'terminated but incomplete');
ok($session->snapshot->facts->{station_closed},                     'CL closes station separately');
$session->reset;
event($session, 1, 'rx', 'IU0ABC DE DL1ABC QRX <AR>');
is($session->snapshot->facts->{turn}, 'peer', 'AR/QRX does not invite local transmission');
ok(!$session->snapshot->terminated, 'AR does not close QSO');
$session->abort(reason => 'Lost propagation');
ok($session->snapshot->terminated && !$session->snapshot->complete, 'abort creates no success');
is($session->snapshot->state, 'ABORTED', 'operator abort state');
my $revision = $session->snapshot->revision;
$session->abort(reason => 'Again');
is($session->snapshot->revision, $revision, 'abort idempotent');
$session->reset;
$session->finish;
ok(!$session->snapshot->terminated, 'EOF does not invent contact closure');
done_testing;
