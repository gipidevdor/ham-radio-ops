#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Config;
use File::Spec;
use File::Temp qw(tempdir);
use Carp       qw(croak);

sub run_command {
    my (@command) = @_;
    system @command;
    croak "Command failed: @command" if $?;
    return;
}

my ($prefix, $build) = @ARGV;
croak "Usage: perl maint/check-cli-install.pl PREFIX [--build]\n"
    if !defined($prefix) || @ARGV > 2 || (defined($build) && $build ne '--build');
$prefix = File::Spec->rel2abs($prefix);
if ($build) {
    run_command($^X, 'Makefile.PL', "INSTALL_BASE=$prefix");
    my $make = $Config{make} || 'make';
    run_command($make);
    run_command($make, 'install');
}
local $ENV{PERL5LIB} = File::Spec->catdir($prefix, 'lib', 'perl5');
my $cli = File::Spec->catfile($prefix, 'bin', $^O eq 'MSWin32' ? 'ham-qso.bat' : 'ham-qso');
croak "Installed command is missing: $cli" unless -f $cli;
run_command($cli, '--version');
run_command($cli, 'compose',  '--station', 'IU0ABC',   '--kind', 'cq');
run_command($cli, 'parse',    '--json',    '--strict', 'IU0ABC DE DL1ABC RST 579 KN');
run_command($cli, 'profiles', '--profile', 'it-rtty');
print "Installed command and launcher PASS\n";
