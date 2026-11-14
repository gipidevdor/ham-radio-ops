#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Archive::Tar 3.10;
use Carp qw(croak);
use Config;
use Cwd qw(abs_path getcwd);
use File::Spec;
use File::Temp qw(tempdir);

my $original = getcwd();
END { chdir $original if defined $original }

sub run_command {
    my (@command) = @_;
    system @command;
    croak "Command failed: @command" if $?;
    return;
}

my ($path) = @ARGV;
croak "Usage: perl maint/check-install.pl DISTRIBUTION.tar.gz\n" unless defined($path) && -f $path;
my $archive = abs_path($path);
my $root    = tempdir('ham-radio-ops-install-XXXXXX', TMPDIR => 1, CLEANUP => 1);
chdir $root                                or croak "Cannot enter temporary directory: $!\n";
Archive::Tar->extract_archive($archive, 1) or croak "Cannot extract $archive\n";
my @directories = grep { -d $_ } glob('Ham-QSO-*');
croak "Expected one extracted distribution\n" unless @directories == 1;
chdir $directories[0] or croak $!;
my $prefix = File::Spec->catdir($root, 'installed tools');
my $make   = $Config{make} || 'make';
run_command($^X, 'Makefile.PL', "INSTALL_BASE=$prefix");
run_command($make);
run_command($make, 'test');
run_command($make, 'install');
local $ENV{PERL5LIB} = File::Spec->catdir($prefix, 'lib', 'perl5');
run_command($^X, 'maint/check-cli-install.pl', $prefix);
run_command($^X, 'examples/run-all.pl',        '--installed');
print "Installed distribution, CLI and examples PASS\n";
