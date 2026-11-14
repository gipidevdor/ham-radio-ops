package Ham::QSO;
use 5.020;
use strict;
use warnings;
use Ham::QSO::Profile;
use Ham::QSO::Message;
use Ham::QSO::Session;
use Ham::QSO::Adapter;
use Ham::QSO::_Internal::Validate qw(named_arguments options);
our $VERSION = '0.001';

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'profile');
    my $profile = Ham::QSO::Profile->new(name => $args{profile} // 'it-cw');
    return bless {
        profile  => $profile,
        messages => Ham::QSO::Message->new(profile => $profile->name)
    }, $class;
}
sub profile { my ($self) = @_; return $self->{profile}->as_hash }

sub parse {
    my ($self, $text) = @_;
    return $self->{messages}->parse($text);
}

sub compose {
    my ($self, @pairs) = @_;
    return $self->{messages}->compose(@pairs);
}

sub session {
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(station peer max_events));
    return Ham::QSO::Session->new(profile => $self->{profile}->name, %args);
}

sub adapter {
    my ($self, @pairs) = @_;
    return Ham::QSO::Adapter->new(profile => $self->{profile}->name, @pairs);
}

sub logbook {
    my ($self, @pairs) = @_;
    require Ham::QSO::Logbook;
    return Ham::QSO::Logbook->new(@pairs);
}

sub adif {
    my ($self, @pairs) = @_;
    require Ham::QSO::ADIF;
    return Ham::QSO::ADIF->new(@pairs);
}
1;

=encoding UTF-8

=head1 NAME

Ham::QSO - evidence-based CW and RTTY QSO semantics and operating sessions

=head1 SYNOPSIS

    use 5.020;
    use strict;
    use warnings;
    use Ham::QSO;
    my $qso = Ham::QSO->new(profile => 'it-cw');
    my $session = $qso->session(station => 'IU0ABC');
    my $proposal = $session->prepare(kind => 'cq');
    print $proposal->{text}, "\n";
    print $session->snapshot->state, "\n"; # READY: preparation is not transmission

=head1 DESCRIPTION

Pure Perl semantic messages, strict evidence tracking and bounded two-station
sessions for ordinary CW and RTTY contacts. Italian profiles include explicit
identification timing checks. No radio, audio device, network or PDL is loaded.
Optional adapters use Ham::CW or Ham::RTTY for actual symbolic/audio conversion.
The checked scope is explicit: this library does not certify complete regulatory
compliance or infer missing callsigns, reports, acknowledgements or transmission.

=head1 METHODS

=head2 new

    my $qso = Ham::QSO->new(profile => 'it-cw');

Creates a facade. Profile defaults to it-cw; see L<Ham::QSO::Profile> for names.
Unknown/duplicate options throw QSO_E_ARGUMENT; unsupported profiles QSO_E_PROFILE.

=head2 profile

    my $metadata = $qso->profile;

Returns independent profile metadata.

=head2 parse

    my $result = $qso->parse('IU0ABC DE DL1ABC R RST 579 KN');

Returns a Message analysis Result. Does not change session state.

=head2 compose

    my $text = $qso->compose(from => 'IU0ABC', to => 'DL1ABC', report => '579');

Returns canonical text. Accepts L<Ham::QSO::Message/compose> options.

=head2 session

    my $session = $qso->session(station => 'IU0ABC', max_events => 5000);

Returns an independent Session with this profile. Accepts station, optional peer
and max_events. See L<Ham::QSO::Session> for timing, evidence and lifecycle rules.

=head2 adapter

    my $adapter = $qso->adapter(options => {wpm => 20});

Returns an Adapter with this profile. Loads only the selected optional codec.
See L<Ham::QSO::Adapter>. Construction fails clearly if it is unavailable.

=head2 logbook

    my $log = $qso->logbook(path => 'station.jsonl', station => 'IU0ABC');

Opens the integrated append-only station log. See L<Ham::QSO::Logbook> for
exclusive creation, session archiving, corrections and trusted checkpoints.

=head2 adif

    my $adif = $qso->adif;

Creates an independent L<Ham::QSO::ADIF> ADI/ADX interchange codec. Importing or
exporting never records an on-air event. Accepts ADIF constructor resource bounds.

=head1 ERRORS

L<Ham::QSO::Error> exceptions expose code, message and copied context.
QSO_E_ARGUMENT: malformed inputs; QSO_E_PROFILE: unknown profile;
QSO_E_RESOURCE: declared bound exceeded; QSO_E_SEQUENCE: invalid ordering or
missing evidence; QSO_E_STALE: invalidated proposal; QSO_E_DUPLICATE: conflicting
event ID; QSO_E_LIFECYCLE: finished stream; QSO_E_DEPENDENCY: unavailable codec;
QSO_E_IO: command input/output failure. Semantic uncertainty and observed
violations are Result diagnostics, not argument exceptions.

=head1 AUTHOR

Giacomo Picchiarelli

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli.
Artistic License 2.0. See LICENSE in the source distribution.

=cut
