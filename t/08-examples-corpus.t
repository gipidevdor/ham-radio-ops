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

my $older_xml = tempdir(CLEANUP => 1);
mkdir "$older_xml/XML" or die $!;
for my $module (['Parser', '2.58'], ['LibXML', '2.0212']) {
    open my $output, '>', "$older_xml/XML/$module->[0].pm" or die $!;
    print {$output} "package XML::$module->[0]; our \$VERSION = '$module->[1]'; 1;\n" or die $!;
    close $output                                                                     or die $!;
}
is(system($^X, "-I$older_xml", '-MXML::Parser', '-MXML::LibXML', '-e1'),
    0, 'older optional XML fixtures load successfully');
system $^X, "-I$root/lib", "-I$older_xml", "$root/examples/logbook.pl";
is($?, 0, 'station-log example remains usable with older optional XML libraries installed');
done_testing;
