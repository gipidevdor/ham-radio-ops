#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Carp    qw(croak);
use FindBin qw($Bin);
use JSON::PP;
use Ham::QSO;
my $session = Ham::QSO->new->session(station => 'IU0ABC');
open my $input, '<', "$Bin/complete-it-cw.jsonl" or croak $!;

while (my $line = <$input>) {
    my $event = JSON::PP->new->decode($line);
    $session->feed(%{$event});
}
close $input or croak $!;
my $result = $session->finish;
croak 'Synthetic exchange failed'
    unless $result->complete
    && $result->terminated
    && $result->conformance->{status} eq 'satisfied';
print "Synthetic QSO: complete, terminated, checked scope satisfied\n";
