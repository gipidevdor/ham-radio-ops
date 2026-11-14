use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO::Profile;
my $profile = Ham::QSO::Profile->new;
is($profile->as_hash->{jurisdiction},               'IT',    'Italy is default');
is($profile->as_hash->{identification_interval_ms}, 600000,  'art 12(6): ten minutes, not five');
is($profile->as_hash->{eop_version},                '4.2.0', 'fixed source edition');
my $rules = $profile->rules;

for my $id (qw(QSO-R001 QSO-R002 QSO-R003 QSO-R004 IT-R001 ENG-R001 ENG-R002)) {
    ok($rules->{$id}{section} && $rules->{$id}{source} && $rules->{$id}{authority},
        "$id has provenance");
}
is($rules->{'IT-R001'}{authority}, 'Italian regulation', 'law distinguished from guidance');
is(
    $rules->{'ENG-R001'}{authority},
    'Implementation contract',
    'policy not attributed to regulation'
);
$rules->{'IT-R001'}{section} = 'wrong';
isnt($profile->rules->{'IT-R001'}{section}, 'wrong', 'copied rules');
is($profile->check_identification(duration_ms => 1000)->{status},
    'indeterminate', 'no timing is unknown');
is($profile->check_identification(duration_ms => 1000, identifications => [])->{status},
    'violated', 'explicitly no ID');
for my $case (
    [
        600000, [{start_ms => 0, end_ms => 1000}, {start_ms => 599000, end_ms => 600000}],
        'satisfied'
    ],
    [601001, [{start_ms => 0, end_ms => 1000}, {start_ms => 600001, end_ms => 601001}], 'violated'],
    [
        601000, [{start_ms => 0, end_ms => 1000}, {start_ms => 600000, end_ms => 601000}],
        'satisfied'
    ],
    [
        1201000,
        [
            {start_ms => 0,       end_ms => 1000},
            {start_ms => 599000,  end_ms => 600000},
            {start_ms => 1199000, end_ms => 1201000}
        ],
        'violated'
    ],
    [10000, [{start_ms => 1000, end_ms => 2000}, {start_ms => 9000, end_ms => 10000}], 'violated'],
    [10000, [{start_ms => 0,    end_ms => 1000}],                                      'violated'],
    [10000, [{start_ms => 0,    end_ms => 10000}],                                     'satisfied'],
    )
{
    is(
        $profile->check_identification(duration_ms => $case->[0], identifications => $case->[1])
            ->{status},
        $case->[2],
        'independent timing boundary vector'
    );
}
for my $ids (
    undef,
    {},
    [{start_ms => 1,   end_ms => 1}],
    [{start_ms => 0,   end_ms => 2000}],
    [{start_ms => 0,   end_ms => 500}, {start_ms => 400, end_ms => 600}],
    [{start_ms => 0.5, end_ms => 100}],
    [{start_ms => 0,   end_ms => 100, unknown => 1}]
    )
{
    throws(
        'QSO_E_ARGUMENT',
        sub { $profile->check_identification(duration_ms => 1000, identifications => $ids) },
        'invalid ID evidence rejected'
    );
}
is(
    Ham::QSO::Profile->new(name => 'iaru-cw')->check_identification(duration_ms => 1000)->{status},
    'not_assessed',
    'no invented ten-minute rule for other jurisdictions'
);
done_testing;
