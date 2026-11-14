package Ham::QSO::Profile;
use 5.020;
use strict;
use warnings;
use Storable                      qw(dclone);
use Ham::QSO::_Internal::Validate qw(fail named_arguments options integer);
our $VERSION = '0.001';

my $eop = 'https://www.iaru-r1.org/wp-content/uploads/2026/07/'
    . 'IARU-Ethics-and-Operating-Procedures-for-the-Radio-Amateur-4th-Ed-v4.2.0_F.pdf';
my $italy =
      'https://www.gazzettaufficiale.it/atto/serie_generale/caricaArticolo?'
    . 'art.codiceRedazionale=21A01607&art.dataPubblicazioneGazzetta=2021-03-22'
    . '&art.flagTipoArticolo=1&art.idArticolo=12&art.idGruppo=2'
    . '&art.idSottoArticolo=1&art.idSottoArticolo1=10&art.progressivo=0&art.versione=1';
my %rules = (
    'QSO-R001' => {
        source      => $eop,
        section     => '12.1',
        authority   => 'IARU recommendation',
        requirement => 'Mutual identification, reports and acknowledgements are separate evidence.'
    },
    'QSO-R002' => {
        source      => $eop,
        section     => '12.2, 12.6.1',
        authority   => 'IARU guidance',
        requirement => 'Preserve full callsigns; addressed headers put the recipient first.'
    },
    'QSO-R003' => {
        source      => $eop,
        section     => '13.3, 13.6, 13.7',
        authority   => 'IARU guidance',
        requirement => 'Distinguish invitation, message end, contact end and station closure.'
    },
    'QSO-R004' => {
        source      => $eop,
        section     => '13.4, 14.1',
        authority   => 'IARU guidance',
        requirement => 'Validate explicit RST reports without inventing measured values.'
    },
    'IT-R001' => {
        source      => $italy,
        section     => '12(6)',
        authority   => 'Italian regulation',
        requirement => 'Identify at opening and closing and at intervals of ten minutes.'
    },
    'ENG-R001' => {
        source      => 'docs/architecture.md',
        section     => 'Evidence boundary',
        authority   => 'Implementation contract',
        requirement => 'Preparation never records transmission; uncertain input proves no facts.'
    },
    'ENG-R002' => {
        source      => 'docs/architecture.md',
        section     => 'Evidence boundary',
        authority   => 'Implementation contract',
        requirement => 'Correction invalidates evidence dependent on the corrected value.'
    },
);

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'name');
    my $name = $args{name} // 'it-cw';
    my ($jurisdiction, $mode) = !ref($name) ? $name =~ /\A(it|iaru)-(cw|rtty)\z/x : ();
    fail('QSO_E_PROFILE', 'Expected it-cw, it-rtty, iaru-cw or iaru-rtty')
        unless defined $jurisdiction;
    $mode = uc $mode;
    return bless {
        name                       => $name,
        mode                       => $mode,
        jurisdiction               => $jurisdiction eq 'it' ? 'IT' : undef,
        revision                   => '2026-11-07',
        eop_version                => '4.2.0',
        identification_interval_ms => $jurisdiction eq 'it' ? 600_000 : undef
    }, $class;
}

sub as_hash { my ($self) = @_; return dclone({%{$self}}) }
sub name    { my ($self) = @_; return $self->{name} }
sub mode    { my ($self) = @_; return $self->{mode} }
sub rules   { return dclone(\%rules) }

sub check_identification {
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(duration_ms identifications));
    my $duration = integer('duration_ms', $args{duration_ms}, 1, 2**52);
    return {
        status => $self->{jurisdiction} ? 'indeterminate' : 'not_assessed',
        rule   => 'IT-R001',
        reason => 'Identification timing absent'
        }
        unless exists $args{identifications};
    my $interval = $self->{identification_interval_ms} // 2**52;
    my $ids      = $args{identifications};
    fail('QSO_E_ARGUMENT', 'identifications must be an array of identification spans')
        unless ref($ids) eq 'ARRAY';
    fail('QSO_E_RESOURCE', 'Too many identification spans') if @{$ids} > 10_000;
    my ($previous_end, $opening, $closing, $gap) = (0, 0, 0, 0);

    for my $span (@{$ids}) {
        fail('QSO_E_ARGUMENT', 'Each identification needs start_ms and end_ms')
            unless ref($span) eq 'HASH';
        options($span, qw(start_ms end_ms));
        my $start = integer('start_ms', $span->{start_ms}, 0,      $duration);
        my $end   = integer('end_ms',   $span->{end_ms},   $start, $duration);
        fail('QSO_E_ARGUMENT', 'Identification spans must be positive, ordered and disjoint')
            if $start == $end || $start < $previous_end;
        $opening      = 1 if $start == 0;
        $closing      = 1 if $end == $duration;
        $gap          = 1 if $end - $previous_end > $interval;
        $previous_end = $end;
    }
    $gap = 1 if $duration - $previous_end > $interval;
    return {status => 'not_assessed', rule => 'IT-R001'} unless $self->{jurisdiction};
    return {
        status            => ($opening && $closing && !$gap) ? 'satisfied' : 'violated',
        rule              => 'IT-R001',
        opening           => $opening,
        closing           => $closing,
        interval_exceeded => $gap
    };
}
1;

=encoding UTF-8

=head1 NAME

Ham::QSO::Profile - versioned CW and RTTY operating profiles, including Italy

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Ham::QSO::Profile;
    my $profile = Ham::QSO::Profile->new(name => 'it-cw');
    my $rules = $profile->rules;
    my $check = $profile->check_identification(
        duration_ms => 10000,
        identifications => [{start_ms => 0, end_ms => 2000},
                            {start_ms => 8000, end_ms => 10000}]);
    print $check->{status}, "\n";

=head1 METHODS

=head2 new

    my $profile = Ham::QSO::Profile->new(name => 'it-cw');

Names: C<it-cw> (default), C<it-rtty>, C<iaru-cw>, C<iaru-rtty>.
Unknown names throw C<QSO_E_PROFILE>. Sources were checked on 2026-11-07.
Profiles cover a declared subset of ordinary two-station conversational QSOs.
They do not certify station authorisation or compliance with all radio law.

=head2 as_hash

    my $metadata = $profile->as_hash;

Returns copied metadata, including mode, jurisdiction, edition and review date.

=head2 name

    my $name = $profile->name;

Returns the exact profile name.

=head2 mode

    my $mode = $profile->mode;

Returns C<CW> or C<RTTY>.

=head2 rules

    my $rules = $profile->rules;

Returns an independent hash mapping stable rule identifiers to sources,
sections, authority and original implementation requirements.

=head2 check_identification

    my $check = $profile->check_identification(duration_ms => 10000);

Returns C<status> and C<rule>. Duration is an integer in 1..2**52 milliseconds.
For Italy, absent spans give C<indeterminate>, an empty list gives C<violated>.
Each span is a caller-attested complete identification of the configured station,
including its opening/closing identification phrase. Spans have integer
C<start_ms> and C<end_ms> relative to the over, are ordered and nonoverlapping,
and have positive length. At most 10,000 spans are accepted.
The conservative policy requires an opening span starting at zero, a closing
span ending at duration, and no interval between completed identifications
exceeding 600,000 ms. The initial interval starts at zero. This boundary policy
is an implementation interpretation, not a statutory definition of phrase length.
It verifies supplied evidence, not audio or the actual on-air identity.
Non-Italian profiles return C<not_assessed>. Invalid metadata throws
C<QSO_E_ARGUMENT> or C<QSO_E_RESOURCE> without changing the profile.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli. Artistic License 2.0.

=cut
