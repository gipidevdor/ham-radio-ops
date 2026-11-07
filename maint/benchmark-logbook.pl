#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Carp qw(croak);
use Config;
use Digest::SHA qw(sha256_hex);
use File::Temp  qw(tempdir);
use FindBin     qw($Bin);
use lib "$Bin/../lib";
use Getopt::Long qw(GetOptions);
use JSON::PP;
use POSIX       qw(strftime);
use Time::HiRes qw(time);
use Ham::QSO;

my ($contacts, $iterations) = (128, 3);
GetOptions('contacts=i' => \$contacts, 'iterations=i' => \$iterations) or croak 'Invalid options';
croak 'Expected contacts 1..10000 and iterations 1..100'
    if @ARGV || $contacts < 1 || $contacts > 10000 || $iterations < 1 || $iterations > 100;
my $directory = tempdir(CLEANUP => 1);
my $qso       = Ham::QSO->new;
my $adif      = $qso->adif;
my @fields    = map {
    {
        CALL             => 'DL1ABC',
        STATION_CALLSIGN => 'IU0ABC',
        OPERATOR         => 'IU0ABC',
        MODE             => 'CW',
        QSO_DATE         => '20261107',
        TIME_ON          => '120000',
        FREQ             => '14.025',
        RST_SENT         => '579',
        RST_RCVD         => '589',
        COMMENT          => "Synthetic benchmark contact $_"
    }
} 1 .. $contacts;
my $source = $adif->encode(records => \@fields);
my $seed   = $qso->logbook(
    path    => "$directory/export.jsonl",
    station => 'IU0ABC',
    create  => 1,
    log_id  => 'benchmark-export'
);
$seed->import_adif(bytes => $source, id_prefix => 'seed', operator => 'IU0ABC');

sub measure {
    my ($callback, $count) = @_;
    my @samples;
    for my $iteration (1 .. $count) {
        my $start = time;
        $callback->($iteration);
        push @samples, time - $start;
    }
    @samples = sort { $a <=> $b } @samples;
    my $middle = int(@samples / 2);
    my $median = @samples % 2 ? $samples[$middle] : ($samples[$middle - 1] + $samples[$middle]) / 2;
    return {
        samples_seconds => \@samples,
        median_seconds  => $median
    };
}

my %operations = (
    adi_encode      => sub { return $adif->encode(records => \@fields) },
    adi_decode      => sub { return $adif->decode($source) },
    verified_export => sub { return $seed->export_adif },
    batch_import    => sub {
        my ($iteration) = @_;
        my $log = $qso->logbook(
            path    => "$directory/import-$iteration.jsonl",
            station => 'IU0ABC',
            create  => 1,
            log_id  => "benchmark-$iteration"
        );
        return $log->import_adif(bytes => $source, id_prefix => 'import', operator => 'IU0ABC');
    }
);
if (eval { require XML::Parser; require XML::LibXML; 1 }) {
    my $xml = $adif->encode(format => 'adx', records => [$fields[0]]);
    $operations{adx_validation} = sub { return $adif->validate_adx($xml) };
}
my %results = map { $_ => measure($operations{$_}, $iterations) } sort keys %operations;
print JSON::PP->new->canonical->pretty->encode(
    {
        date         => strftime('%Y-%m-%d', gmtime),
        perl         => "$^V",
        os           => $^O,
        archname     => $Config{archname},
        contacts     => $contacts,
        iterations   => $iterations,
        input_sha256 => sha256_hex($source),
        timer        => 'wall; batch import includes exclusive creation and durable commit',
        rss          => 'not measured',
        results      => \%results
    }
) or croak 'Cannot write benchmark output';
