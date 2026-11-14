use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use File::Temp qw(tempdir);
use File::Spec;
use JSON::PP;
use Ham::QSO::_Internal::CLI;
my $directory = tempdir(CLEANUP => 1);

sub cli {
    my ($input,  @args)   = @_;
    my ($output, $errors) = ('', '');
    open my $in,  '<', \$input  or die $!;
    open my $out, '>', \$output or die $!;
    open my $err, '>', \$errors or die $!;
    my $status = Ham::QSO::_Internal::CLI::run(\@args, $in, $out, $err);
    close $in  or die $!;
    close $out or die $!;
    close $err or die $!;
    return ($status, $output, $errors);
}
for my $mode (qw(cw rtty)) {
    subtest "CLI real $mode codec" => sub {
        my $available = eval { $mode eq 'cw' ? require Ham::CW : require Ham::RTTY; 1 };
        plan skip_all => "Optional $mode codec is not installed" unless $available;
        my @profile = ('--profile', "it-$mode");
        my @hints =
            $mode eq 'cw'
            ? ('--wpm', 40, '--frequency', 700)
            : ('--baud', 100, '--mark', 2125, '--shift', 170);
        my ($status, $symbols, $error) = cli('', 'encode', @profile, 'CQ DE IU0ABC K');
        is($status, 0,  'encode command');
        is($error,  '', 'encoding diagnostics clean');
        ($status, my $output) = cli($symbols, 'decode', @profile, '--strict');
        is($status,                                  0,           'decode command');
        is(JSON::PP->new->decode($output)->{status}, 'supported', 'actual symbolic semantics');
        my $module  = $mode eq 'cw' ? 'Ham::CW' : 'Ham::RTTY';
        my $outside = $module->new->encode('HELLO');
        is((cli($outside, 'decode', @profile, '--strict'))[0],
            1, 'valid symbols with unsupported semantics stay unknown');
        is((cli('', 'wav', @profile, 'CQ DE IU0ABC K'))[0], 2, 'audio output must be explicit');
        my $path = File::Spec->catfile($directory, "$mode.wav");
        ($status, $output, $error) = cli(
            '',         'wav', @profile, @hints, '--sample-rate', 8000,
            '--output', $path, 'CQ DE IU0ABC K'
        );
        is($status, 0,  'WAV file command') or diag($error);
        is($output, '', 'binary file does not leak to stdout');
        ($status, $output, $error) =
            cli('', 'receive', @profile, @hints, '--input', $path, '--strict');
        is($status, 0, 'real WAV reception command') or diag($error);
        is(JSON::PP->new->decode($output)->{analysis}{status},
            'supported', 'native reception semantics');
        is((cli('', 'receive', @profile, @hints, '--input', $path))[0],
            0, 'ordinary reception without strict');
        ($status, $output) = cli('', 'wav', @profile, @hints, '--output', '-', 'CQ DE IU0ABC K');
        is($status,               0,      'explicit binary stdout');
        is(substr($output, 0, 4), 'RIFF', 'binary stdout is real WAV');
        is((cli('', 'receive', @profile, '--input', '-'))[0], 2,
            'receive requires a seekable file');
    };
}
my ($status, $output) = cli('CQ DE IU0ABC K', 'parse', '--input', '-', '--output', '-', '--strict');
is($status, 0, 'explicit text stdin/stdout');
my $rx =
    {id => 'r1', direction => 'rx', text => 'IU0ABC DE DL1ABC KN', at_ms => 0, duration_ms => 1000};
my $selection = {operator => 'select_peer', callsign => 'DL1ABC', evidence_id => 'r1'};
my $json      = JSON::PP->new;
($status, $output) = cli("\n" . $json->encode($rx) . "\n\n" . $json->encode($selection) . "\n",
    'replay', '--station', 'IU0ABC', '--peer', 'DL1ABC');
is($status,                                0, 'operator peer selection replay with blank lines');
is(JSON::PP->new->decode($output)->{peer}, 'DL1ABC', 'selected peer retained');
is((cli('X' x 16_777_217, 'parse'))[0],    2,        'input resource ceiling');
done_testing;
