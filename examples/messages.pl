#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Carp qw(croak);
use Ham::QSO;
my $qso = Ham::QSO->new;
print $qso->compose(from => 'IU0ABC', kind => 'cq'), "\n";
my $analysis = $qso->parse('IU0ABC DE DL1? RST 5?9 KN');
croak 'Partial identity was guessed'
    if $analysis->status ne 'ambiguous' || defined $analysis->message;
print $analysis->status, "\n";
