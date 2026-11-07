#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Carp    qw(croak);
use FindBin qw($Bin);
use File::Spec;
use JSON::PP;
my $lib       = File::Spec->catdir($Bin, '..', 'lib');
my $installed = @ARGV && $ARGV[0] eq '--installed';
croak 'Expected no arguments or --installed' if @ARGV && (!$installed || @ARGV != 1);
my @library = $installed ? () : ("-I$lib");
open my $input, '<', "$Bin/routes.json" or croak $!;
my $catalog = JSON::PP->new->decode(do { local $/ = undef; <$input> });
close $input or croak $!;

for my $entry (@{$catalog->{examples}}) {
    my $script = $entry->{file};
    croak 'Invalid example filename'
        if !defined($script)
        || ref($script)
        || $script !~ /\A[a-z-]+\.pl\z/x;
    my $available = 1;
    for my $module (@{$entry->{requires}}) {
        croak 'Unexpected optional codec' if $module ne 'Ham::CW' && $module ne 'Ham::RTTY';
        my $path = $module;
        $path =~ s{::}{/}gx;
        $path .= '.pm';
        my $loaded = eval { require $path; 1 };
        $available = 0 unless $loaded;
    }
    if (!$available) { print "SKIP optional codec example $script\n"; next }
    my $args = $entry->{args} // [];
    system $^X, @library, "$Bin/$script", @{$args};
    croak "Example failed: $script" if $?;
}
