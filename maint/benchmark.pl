#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Carp    qw(croak);
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Config;
use Digest::SHA  qw(sha256_hex);
use Getopt::Long qw(GetOptions);
use JSON::PP;
use Time::HiRes qw(time);
use Ham::QSO;
my ($iterations, $json) = (1000, 0);
GetOptions('iterations=i' => \$iterations, 'json' => \$json) or croak 'Invalid options';
croak 'iterations must be 1..1000000' if @ARGV || $iterations < 1 || $iterations > 1_000_000;
my $text       = 'IU0ABC DE DL1ABC R RST 579 KN';
my $qso        = Ham::QSO->new;
my %operations = (
    parse   => sub { return $qso->parse($text) },
    compose => sub { return $qso->compose(from => 'IU0ABC', to => 'DL1ABC', report => '579') },
    new_session_and_rx => sub {
        my $session = $qso->session(station => 'IU0ABC');
        return $session->receive($text, id => 'rx1', at_ms => 0, duration_ms => 1000);
    }
);
my %results;
for my $name (sort keys %operations) {
    my $start = time;
    for (1 .. $iterations) { $operations{$name}->() }
    my $elapsed = time - $start;
    $results{$name} = {wall_seconds => $elapsed, mean_seconds => $elapsed / $iterations};
}
my $report = {version => $Ham::QSO::VERSION, perl => "$]", os => $^O,
    archname     => $Config{archname},
    profile      => $qso->profile,
    iterations   => $iterations,
    input_sha256 => sha256_hex($text),
    timer        => 'wall; startup excluded',
    results      => \%results,
    rss          => 'not measured'};
print $json
    ? JSON::PP->new->canonical->pretty->encode($report)
    : join('', map { "$_: $results{$_}{mean_seconds} seconds/call\n" } sort keys %results)
    or croak 'Cannot write benchmark output';
