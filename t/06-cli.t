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
for my $command ([], ['help'], ['help', 'parse'], ['--help'], ['--version']) {
    my ($status, $out) = cli('', @{$command});
    is($status, 0, 'help/version');
    ok(length($out), 'output');
}
my ($status, $out, $err) = cli('', 'compose', '--station', 'IU0ABC', '--kind', 'cq');
is($status, 0, 'compose status');
like($out, qr/CQ.+IU0ABC/x, 'composed text');
is($err, '', 'clean diagnostics');
($status, $out) = cli('IU0ABC DE DL1ABC RST 579 KN', 'parse', '--json', '--strict');
is($status,                                        0,     'parse stdin');
is(JSON::PP->new->decode($out)->{message}{report}, '579', 'structured parse');
($status, $out) = cli('', 'parse', '--strict', 'IU0? DE DL1ABC KN');
is($status, 1, 'strict ambiguity');
like($out, qr/ambiguous/x, 'ambiguous output');
($status, $out) = cli('', 'profiles', '--profile', 'it-rtty');
is(JSON::PP->new->decode($out)->{profile}{mode}, 'RTTY', 'profile inventory');
my $path = File::Spec->catfile($directory, 'result.txt');
is((cli('', 'compose', '--station', 'IU0ABC', '--kind', 'cq', '--output', $path))[0],
    0, 'exclusive output');
is((cli('', 'compose', '--station', 'IU0ABC', '--kind', 'cq', '--output', $path))[0],
    2, 'no silent replacement');
is(
    (
        cli(
            '',         'compose', '--station', 'IU0ABC', '--kind', 'probe',
            '--output', $path,     '--overwrite'
        )
    )[0],
    0,
    'explicit replacement'
);
is((cli('', 'parse', '--input', $path, '--strict'))[0], 0, 'file input');

for my $args (
    ['other'],
    ['--version', 'extra'],
    ['parse',     '--unknown'],
    ['parse',     '--sta',     'IU0ABC'],
    ['compose',   '--station', 'IU0ABC', 'extra'],
    ['profiles',  'extra'],
    ['parse',     '--input',   $path, 'extra'],
    ['parse',     '--station', 'IU0ABC'],
    ['replay'],
    ['receive'],
    ['parse', '--input', "$directory/missing"]
    )
{
    is((cli('', @{$args}))[0], 2, 'usage/I/O error status');
}
my $line = JSON::PP->new->encode(
    {
        id          => 'r1',
        direction   => 'rx',
        at_ms       => 0,
        duration_ms => 100,
        text        => 'IU0ABC DE DL1ABC KN'
    }
);
($status, $out) = cli($line, 'replay', '--station', 'IU0ABC', '--strict');
is($status, 1, 'strict incomplete replay');
ok(!JSON::PP->new->decode($out)->{complete}, 'replay does not invent success');
is((cli('[]',                   'replay', '--station', 'IU0ABC'))[0], 2, 'replay object required');
is((cli('{',                    'replay', '--station', 'IU0ABC'))[0], 2, 'invalid JSON');
is((cli('{"operator":"other"}', 'replay', '--station', 'IU0ABC'))[0], 2, 'unknown operator');
($status, $out) =
    cli('{"operator":"abort","reason":"Lost signal"}', 'replay', '--station', 'IU0ABC');
is($status,                              0,         'operator abort replay');
is(JSON::PP->new->decode($out)->{state}, 'ABORTED', 'operator replay state');
done_testing;
