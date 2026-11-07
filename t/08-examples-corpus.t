use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use JSON::PP;
use FindBin qw($Bin);
use File::Spec;
use File::Temp qw(tempdir);
use Cwd        qw(getcwd);
use Ham::QSO;
my $root = File::Spec->rel2abs("$Bin/..");
open my $in, '<', "$root/corpus/semantic.json" or die $!;
my $cases = JSON::PP->new->decode(do { local $/; <$in> });
close $in or die $!;

for my $case (@{$cases}) {
    my $result = Ham::QSO->new->parse($case->{text});
    is($result->status,            $case->{status}, 'original corpus expectation');
    is($result->message->{report}, $case->{report}, 'corpus report') if exists $case->{report};
}
my $temporary = tempdir(CLEANUP => 1);
my $cwd       = getcwd();
chdir $temporary or die $!;
system $^X, "-I$root/lib", "$root/examples/run-all.pl";
my $status = $?;
chdir $cwd or die $!;
is($status, 0, 'independent examples from an empty working directory');
done_testing;
