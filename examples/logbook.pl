#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Carp       qw(croak);
use File::Temp qw(tempdir);
use Ham::QSO;

my $directory = tempdir(CLEANUP => 1);
my $qso       = Ham::QSO->new;
my $log       = $qso->logbook(
    path    => "$directory/station.jsonl",
    station => 'IU0ABC',
    log_id  => 'example-2026',
    create  => 1
);
my %fields = (
    CALL         => 'DL1ABC',
    OPERATOR     => 'IU0ABC',
    MODE         => 'CW',
    QSO_DATE     => '20261107',
    TIME_ON      => '120000',
    QSO_DATE_OFF => '20261107',
    TIME_OFF     => '120100',
    FREQ         => '14.025',
    RST_SENT     => '579',
    RST_RCVD     => '589',
    QSO_COMPLETE => '?'
);
$log->record(id => 'qso1', operator => 'IU0ABC', fields => \%fields);
my $checkpoint = $log->verify;
$log->correct(
    id       => 'fix1',
    corrects => 'qso1',
    operator => 'IU0ABC',
    reason   => 'Corrected frequency from original operator notes',
    fields   => {%fields, FREQ => '14.026'}
);
$log->verify(checkpoint => $checkpoint);
croak 'Original contact was replaced' unless $log->records->[1]{data}{fields}{FREQ} eq '14.025';
my $adi     = $log->export_adif;
my $decoded = $qso->adif->decode($adi);
croak 'Export failed to select correction' unless $decoded->{records}[0]{FREQ} eq '14.026';
print $adi;
my $adx = $log->export_adif(format => 'adx');

if (
    eval {
        require XML::Parser;
        XML::Parser->VERSION('2.59');
        require XML::LibXML;
        XML::LibXML->VERSION('2.0213');
        1;
    }
    )
{
    $qso->adif->validate_adx($adx);
    print "Official ADX schema validation PASS\n";
}
else {
    print "SKIP optional ADX schema validation (requires XML::Parser 2.59+, XML::LibXML 2.0213+)\n";
}
