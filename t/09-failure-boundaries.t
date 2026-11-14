use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Scalar::Util qw(refaddr);
use File::Temp   qw(tempdir);
use File::Spec;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO;
use Ham::QSO::Adapter;
use Ham::QSO::Profile;
use Ham::QSO::_Internal::IO qw(with_file write_bytes);
my $qso = Ham::QSO->new;

for my $args (['odd'], [undef, 1], [[], 1]) {
    throws('QSO_E_ARGUMENT', sub { Ham::QSO->new(@{$args}) }, 'malformed named arguments');
}
throws('QSO_E_PROFILE', sub { Ham::QSO::Profile->new(name => []) }, 'reference profile');
for my $case (
    ['ABC DE DL1ABC KN',            'unsupported'],
    ['IU0ABC DE ABC KN',            'unsupported'],
    ['IU0ABC DE DL1ABC RST ? KN',   'ambiguous'],
    ['IU0ABC DE DL1ABC PSE AGN KN', 'supported'],
    ['CQ DE ABC K',                 'unsupported'],
    ['CQ DE IU0ABC <AR>',           'unsupported'],
    ['QRL? DE ABC',                 'unsupported'],
    ['',                            'unsupported'],
    ["\x00",                        'unsupported'],
    ['IU0ABC DE DL1ABC SK',         'unsupported']
    )
{
    is($qso->parse($case->[0])->status, $case->[1], 'conservative grammar boundary');
}
throws(
    'QSO_E_ARGUMENT',
    sub { $qso->compose(from => 'IU0ABC', kind => 'cq', ack => 1) },
    'CQ cannot acknowledge'
);
throws(
    'QSO_E_ARGUMENT',
    sub { $qso->compose(from => 'IU0ABC', kind => 'cq', ending => '<SK>') },
    'CQ cannot close contact'
);
throws(
    'QSO_E_ARGUMENT',
    sub {
        Ham::QSO->new(profile => 'it-rtty')->compose(
            from   => 'IU0ABC',
            to     => 'DL1ABC',
            ending => '<SK>'
        );
    },
    'RTTY composition forbids CW token'
);
my $profile = Ham::QSO::Profile->new;
throws(
    'QSO_E_RESOURCE',
    sub {
        $profile->check_identification(
            duration_ms     => 1000,
            identifications => [(undef) x 10001]
        );
    },
    'identification resource ceiling'
);
throws(
    'QSO_E_ARGUMENT',
    sub {
        $profile->check_identification(
            duration_ms     => 1000,
            identifications => [1]
        );
    },
    'identification span must be structured'
);
is(
    $profile->check_identification(
        duration_ms     => 700000,
        identifications => [{start_ms => 0, end_ms => 1000}]
    )->{status},
    'violated',
    'final identification deadline'
);
my $international = Ham::QSO::Profile->new(name => 'iaru-cw');
throws(
    'QSO_E_ARGUMENT',
    sub {
        $international->check_identification(
            duration_ms     => 1000,
            identifications => {}
        );
    },
    'non-Italian evidence still requires valid types'
);
is(
    $international->check_identification(
        duration_ms     => 1000,
        identifications => [{start_ms => 0, end_ms => 1}]
    )->{status},
    'not_assessed',
    'no national timing rule inferred'
);
my $session = $qso->session(station => 'IU0ABC', peer => 'DL1ABC');
throws('QSO_E_SEQUENCE', sub { $session->prepare(to => 'F1ABC') }, 'prepared peer mismatch');
my $proposal = $session->prepare(kind => 'cq');
$session->transmitted($proposal, id => 'x', at_ms => 0, duration_ms => 1000, identifications => []);
is($session->snapshot->conformance->{status},
    'violated', 'actual TX identification failure is retained');
$session->reset;
is($session->snapshot->as_hash->{peer}, 'DL1ABC', 'reset retains initial peer');
event($session, 1, 'rx', 'CQ DE DL1ABC K');
ok(!$session->snapshot->facts->{calling}, 'hearing CQ is not own transmission');
event($session, 2, 'tx', 'QRL? DE IU0ABC');
ok(!$session->snapshot->complete, 'frequency inquiry proves no report');
event($session, 3, 'tx', 'DL1ABC DE IU0ABC QRX <AR>');
is($session->snapshot->facts->{turn}, 'local', 'local wait retains turn');
event($session, 4, 'rx', 'IU0ABC DE DL1ABC 73 <SK>');
event($session, 5, 'rx', 'IU0ABC DE DL1ABC RST 599 KN');
ok(grep($_->{code} eq 'QSO_V_CLOSED_PARTY', @{$session->snapshot->diagnostics}),
    'closed peer cannot add new reports');
throws(
    'QSO_E_SEQUENCE',
    sub { $session->select_peer(callsign => 'DL1ABC', evidence_id => 'e4') },
    'no peer correction after closing'
);
my $small = $qso->session(station => 'IU0ABC', max_events => 1);
event($small, 1, 'rx', 'IU0ABC DE DL1ABC KN');
throws('QSO_E_RESOURCE', sub { $small->abort(reason => 'full') }, 'abort respects resource bound');
throws(
    'QSO_E_RESOURCE',
    sub { $small->select_peer(callsign => 'DL1ABC', evidence_id => 'e1') },
    'selection respects resource bound'
);
throws(
    'QSO_E_SEQUENCE',
    sub { $small->select_peer(callsign => 'DL1ABC', evidence_id => 'missing') },
    'selection needs recorded evidence'
);

# Simulate an installation where neither optional codec can be found. The real
# integrations run separately; an absent codec must never select another mode.
for my $mode (qw(cw rtty)) {
    local @INC = (
        sub {
            die 'Selected optional codec is unavailable' if $_[1] =~ m{\AHam/(?:CW|RTTY)\.pm\z}x;
            return;
        },
        @INC
    );
    throws(
        'QSO_E_DEPENDENCY',
        sub { Ham::QSO::Adapter->new(profile => "it-$mode") },
        'missing selected optional codec'
    );
}

my $inconsistent = $qso->session(station => 'IU0ABC');
$inconsistent->feed(
    direction       => 'tx',
    id              => 'false-id',
    at_ms           => 0,
    duration_ms     => 1000,
    text            => 'DL1ABC DE IU0ABC RST 579 KN',
    identifications => [{start_ms => 0, end_ms => 100}, {start_ms => 900, end_ms => 1000}]
);
is($inconsistent->snapshot->conformance->{status},
    'violated', 'timing claims cannot invent missing identity occurrences');
my $directory = tempdir(CLEANUP => 1);
for my $path (undef, [], '', "bad\0path") {
    throws(
        'QSO_E_ARGUMENT',
        sub {
            with_file($path, 'write', sub { return }, 0);
        },
        'invalid output path'
    );
}
my $fresh = File::Spec->catfile($directory, 'new.txt');
with_file($fresh, 'write', sub { write_bytes($_[0], 'new') }, 1);
ok(-f $fresh, 'explicit overwrite also creates a missing destination');
throws(
    'QSO_E_IO',
    sub {
        with_file($directory, 'write', sub { return }, 1);
    },
    'directory cannot be replaced'
);
throws(
    'QSO_E_IO',
    sub {
        with_file("$fresh/child", 'write', sub { return }, 1);
    },
    'non-directory parent'
);
throws(
    'QSO_E_IO',
    sub {
        with_file("$directory/absent/child", 'write', sub { return }, 1);
    },
    'missing output directory'
);
SKIP: {
    my $link = File::Spec->catfile($directory, 'link');
    skip 'Symlinks unavailable', 1 unless symlink($fresh, $link);
    throws(
        'QSO_E_IO',
        sub {
            with_file($link, 'write', sub { return }, 1);
        },
        'symlink replacement rejected'
    );
}
my $failed = File::Spec->catfile($directory, 'failed.txt');
my $marker = Ham::QSO::Error->new(code => 'QSO_E_TEST', message => 'Caller failure');
for my $case ([$failed, 'write', 0], [$fresh, 'write', 1], [$fresh, 'read', 0]) {
    my $ok = eval {
        with_file($case->[0], $case->[1], sub { die $marker }, $case->[2]);
        1;
    };
    my $error = $@;
    ok(!$ok && ref($error) && refaddr($error) == refaddr($marker),
        'callback error identity preserved');
}
ok(!-e $failed, 'new partial output removed on failure');
open my $readback, '<', $fresh or die $!;
is(do { local $/; <$readback> }, 'new', 'failed overwrite preserves original');
close $readback or die $!;
my $bytes = '';
open my $closed, '>', \$bytes or die $!;
close $closed or die $!;
{
    local $SIG{__WARN__} = sub { return };
    throws(
        'QSO_E_IO',
        sub { write_bytes($closed, 'lost') },
        'closed output becomes structured error'
    );
}
SKIP: {
    skip 'SIGPIPE unavailable', 1 unless exists $SIG{PIPE};
    pipe my $reader, my $writer or skip 'Pipes unavailable', 1;
    close $reader or die $!;
    throws(
        'QSO_E_IO',
        sub { write_bytes($writer, 'buffered output') },
        'a broken pipe fails before a buffered write can report success'
    );
    local $SIG{PIPE} = 'IGNORE';
    close $writer;    ## no critic (InputOutput::RequireCheckedSyscalls)
}
done_testing;
