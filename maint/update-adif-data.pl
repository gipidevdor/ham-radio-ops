#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Carp qw(croak);
use HTML::TreeBuilder;
use JSON::PP;

# Compile factual identifiers, types and numeric constraints only. The official
# specification prose is not distributed. Official schemas have separate CC0 notices.
my ($source, $destination) = @ARGV;
croak 'Usage: update-adif-data.pl ADIF_318.htm ADIFData.pm' unless defined $destination;
my $source_tree = HTML::TreeBuilder->new->parse_file($source);

sub key {
    my ($text) = @_;
    $text =~ s/Enumeration//igx;
    $text =~ s/[^A-Za-z0-9]//gx;
    return uc $text;
}

sub clean {
    my ($text) = @_;
    $text =~ s/\A\s+|\s+\z//gx;
    return $text;
}

sub extract_fields {
    my ($tree) = @_;
    my %fields;
    for my $row ($tree->look_down(_tag => 'tr')) {
        my $id = $row->attr('id') // '';
        next unless $id =~ /\A(?:QSO_Field_|Header_Field_)/x;
        my @cells = grep { ref($_) && $_->tag eq 'td' } $row->content_list;
        next if @cells < 4;
        my ($type_link) = $cells[1]->look_down(_tag => 'a');
        my ($enum_link) = $cells[2]->look_down(_tag => 'a');
        my $type        = $type_link ? $type_link->attr('href') : $cells[1]->as_text;
        $type =~ s/\A\#//x;
        my $enum = $enum_link ? key($enum_link->attr('href') // '') : '';

        for my $name ($cells[0]->as_text =~ /[A-Z][A-Z0-9_]+/gx) {
            next if $name eq 'USERDEF';
            $fields{$name} = {
                type        => clean($type),
                enum        => $enum,
                scope       => $id                =~ /Header/x           ? 'header' : 'record',
                import_only => $cells[3]->as_text =~ /\A\s*import-only/x ? 1        : 0
            };
        }
    }
    return \%fields;
}

sub extract_enums {
    my ($tree) = @_;
    my %enums;
    for my $table ($tree->look_down(_tag => 'table')) {
        my $id = $table->attr('id') // '';
        next unless $id =~ /\AEnumeration_/x;
        my $enum = key($id);
        for my $row ($table->look_down(_tag => 'tr')) {
            my @cells = grep { ref($_) && $_->tag eq 'td' } $row->content_list;
            next unless @cells;
            my $value = $cells[0]->as_text;
            $value =~ s/\(import-only\).*\z//ix;
            $value =~ s/\A[\s\xa0]+|[\s\xa0]+\z//gx;
            $value = uc $value;
            next if !length($value) || $value =~ /[^\x20-\x7e]/x;
            my %entry = (import_only => scalar($row->as_text =~ /import-only/x) ? 1 : 0);
            $entry{mode} = uc clean($cells[1]->as_text) if $enum eq 'SUBMODE';

            if ($enum eq 'BAND') {
                @entry{qw(lower upper)} = map { 0 + $_->as_text } @cells[1, 2];
            }
            if ($enum eq 'REGION') {
                my %period;
                my $dxcc = clean($cells[1]->as_text);
                $period{dxcc} = $dxcc if $dxcc =~ /\A[0-9]+\z/x;
                for my $pair ([5 => 'start'], [6 => 'end']) {
                    my $date = clean($cells[$pair->[0]]->as_text);
                    $date =~ s/[-\/]//gx;
                    $period{$pair->[1]} = $date if $date =~ /\A[0-9]{8}\z/x;
                }
                $enums{$enum}{$value} //= {import_only => $entry{import_only}, periods => []};
                push @{$enums{$enum}{$value}{periods}}, \%period;
                next;
            }
            $enums{$enum}{$value} = \%entry;
        }
    }
    return \%enums;
}

my $fields = extract_fields($source_tree);
my $enums  = extract_enums($source_tree);
croak 'Unexpected ADIF field inventory' if keys(%{$fields}) <= 170 || !$fields->{TIME_ON};
my $data   = JSON::PP->new->ascii->canonical->pretty->encode({fields => $fields, enums => $enums});
my $prefix = <<'PREFIX';
package Ham::QSO::_Internal::ADIFData;
use 5.020;
use strict;
use warnings;
use JSON::PP;
# Factual ADIF 3.1.8 identifiers and constraints; no specification prose/schema.
# Source: https://adif.org.uk/318/ADIF_318.htm (2026-11-07).
# Original compilation: Giacomo Picchiarelli, Artistic License 2.0.
my $data;
sub registry {
    $data //= JSON::PP->new->decode(do { local $/ = undef; <DATA> });
    return $data;
}
1;
__DATA__
PREFIX
open my $out, '>', $destination or croak $!;
print {$out} $prefix, $data or croak $!;
close $out or croak $!;
$source_tree->delete;
