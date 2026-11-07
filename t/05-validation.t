use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO;
use Ham::QSO::Result;
use Ham::QSO::Error;
use Ham::QSO::_Internal::Data qw(plain_data);
my $qso = Ham::QSO->new;

for my $options (
    [],
    [station => 'IU0?'],
    [station => 'IU0ABC', peer       => 'IU0ABC'],
    [station => 'IU0ABC', max_events => 0],
    [station => 'IU0ABC', max_events => 'NaN'],
    [station => 'IU0ABC', unknown    => 1],
    [station => 'IU0ABC', station    => 'IU0XYZ']
    )
{
    throws('QSO_E_ARGUMENT', sub { $qso->session(@{$options}) }, 'invalid constructor');
}
my $session = $qso->session(station => 'IU0ABC', max_events => 2);
my %base    = (
    id          => 'a',
    direction   => 'rx',
    at_ms       => 0,
    duration_ms => 1000,
    text        => 'IU0ABC DE DL1ABC KN'
);
for my $change (
    {id              => undef},
    {id              => []},
    {id              => 'bad id'},
    {direction       => 'other'},
    {direction       => undef},
    {duration_ms     =>  0},
    {at_ms           => -1},
    {at_ms           => 'Inf'},
    {duration_ms     => 0.5},
    {duration_ms     => 2**52, at_ms => 1},
    {uncertain       => 2},
    {text            => undef},
    {identifications => []},
    {unknown         => 1}
    )
{
    my $before = $session->snapshot->as_hash;
    throws('QSO_E_ARGUMENT', sub { $session->feed(%{{%base, %{$change}}}) }, 'invalid evidence');
    is_deeply($session->snapshot->as_hash, $before, 'argument failure is atomic');
}
my $first = $session->feed(%base)->as_hash;
is_deeply($session->feed(%base)->as_hash, $first, 'duplicate identical event idempotent');
throws(
    'QSO_E_DUPLICATE',
    sub { $session->feed(%{{%base, text => 'IU0ABC DE DL1ABC K'}}) },
    'conflicting duplicate'
);
throws('QSO_E_SEQUENCE', sub { $session->feed(%{{%base, id => 'b', at_ms => 999}}) }, 'overlap');
is_deeply($session->snapshot->as_hash, $first, 'sequence failure atomic');
$session->feed(%{{%base, id => 'b', at_ms => 1000}});
throws(
    'QSO_E_RESOURCE',
    sub { $session->feed(%{{%base, id => 'c', at_ms => 2000}}) },
    'event ceiling'
);
my $other    = $qso->session(station => 'IU0ABC');
my $proposal = $other->prepare(kind => 'cq');
throws('QSO_E_STALE',    sub { $session->transmitted($proposal) }, 'cross-session proposal');
throws('QSO_E_ARGUMENT', sub { $other->transmitted([]) },          'nonproposal');
throws(
    'QSO_E_ARGUMENT',
    sub { $other->prepare(from => 'IU0ABC', kind => 'cq') },
    'station fixed by session'
);
throws('QSO_E_ARGUMENT', sub { $other->abort(reason => '') }, 'empty abort reason');
throws(
    'QSO_E_ARGUMENT',
    sub { $other->select_peer(callsign => 'IU0?') },
    'partial operator selection'
);
my $cyclic = {};
$cyclic->{self} = $cyclic;
throws('QSO_E_ARGUMENT', sub { Ham::QSO::Result->new(data => $cyclic) }, 'cyclic result');
throws(
    'QSO_E_ARGUMENT',
    sub {
        Ham::QSO::Result->new(data => {code => sub { return }});
    },
    'executable payload'
);
my $deep   = {};
my $cursor = $deep;
for (1 .. 66) { $cursor->{next} = {}; $cursor = $cursor->{next} }
ok(!plain_data($deep), 'bounded data depth');
my $shared = {value => 1};
ok(plain_data([$shared, $shared]), 'shared acyclic children allowed');
my $error = Ham::QSO::Error->new(code => 'QSO_E_ARGUMENT', message => 'Bad', context => {a => [1]});
is($error->code,    'QSO_E_ARGUMENT',      'error code');
is($error->message, 'Bad',                 'error message');
is("$error",        'QSO_E_ARGUMENT: Bad', 'stringification');
my $context = $error->context;
$context->{a}[0] = 2;
is($error->context->{a}[0], 1, 'copied error context');

for my $args (
    [unknown => 1],
    [code    => undef],
    [context => []],
    [message => []],
    [code    => 'a', code => 'b'], ['odd']
    )
{
    throws('QSO_E_ARGUMENT', sub { Ham::QSO::Error->new(@{$args}) }, 'invalid error');
}
done_testing;
