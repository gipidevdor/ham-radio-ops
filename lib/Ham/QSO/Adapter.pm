package Ham::QSO::Adapter;
use 5.020;
use strict;
use warnings;
use Scalar::Util qw(blessed);
use Ham::QSO::Profile;
use Ham::QSO::Message;
use Ham::QSO::_Internal::Data     qw(plain_data);
use Ham::QSO::_Internal::Validate qw(fail named_arguments options);
our $VERSION = '0.001';

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(profile codec options));
    my $profile = Ham::QSO::Profile->new(name => $args{profile} // 'it-cw');
    my $module  = $profile->mode eq 'CW' ? 'Ham::CW' : 'Ham::RTTY';
    my $codec   = $args{codec};
    if (exists $args{codec}) {
        fail('QSO_E_ARGUMENT', 'codec and options are mutually exclusive') if exists $args{options};
        fail('QSO_E_ARGUMENT', "codec must be a $module object")
            unless blessed($codec) && $codec->isa($module);
    }
    else {
        my $config = $args{options} // {};
        fail('QSO_E_ARGUMENT', 'options must be plain hash data')
            unless ref($config) eq 'HASH' && plain_data($config);
        fail('QSO_E_ARGUMENT', 'Semantic adapters require the pure Perl backend')
            if exists($config->{backend})
            && (!defined($config->{backend})
            || ref($config->{backend})
            || $config->{backend} ne 'perl');
        my $loaded = eval { $module eq 'Ham::CW' ? require Ham::CW : require Ham::RTTY; 1 };
        fail('QSO_E_DEPENDENCY', "Install $module to use the selected adapter") unless $loaded;
        my %configuration = (%{$config}, backend => 'perl');
        $codec = $module->new(%configuration);
    }
    return bless {
        profile  => $profile,
        codec    => $codec,
        messages => Ham::QSO::Message->new(profile => $profile->name)
    }, $class;
}

sub _text {
    my ($self, $input) = @_;
    my $text = $input;
    if (ref($input) eq 'HASH') {
        options($input, qw(session revision profile text));
        fail('QSO_E_PROFILE', 'Proposal and adapter profiles differ')
            if !defined($input->{profile})
            || ref($input->{profile})
            || $input->{profile} ne $self->{profile}->name;
        $text = $input->{text};
    }
    my $analysis = $self->{messages}->parse($text);
    fail('QSO_E_ARGUMENT', 'Only supported messages can be encoded by the semantic adapter')
        unless $analysis->status eq 'supported';
    return $text;
}

sub encode {
    my ($self, $input) = @_;
    return $self->{codec}->encode($self->_text($input));
}

sub decode {
    my ($self, $symbols) = @_;
    my $text =
          $self->{profile}->mode eq 'CW'
        ? $self->{codec}->decode($symbols, prefer_prosigns => 1)
        : $self->{codec}->decode($symbols);
    return $self->{messages}->parse($text);
}

sub wav_bytes {
    my ($self, $input, @pairs) = @_;
    return $self->{codec}->wav_bytes($self->_text($input), @pairs);
}

sub write_wav {
    my ($self, $input, $path, @pairs) = @_;
    return $self->{codec}->write_wav($self->_text($input), $path, @pairs);
}

sub read_wav {
    my ($self, $path, @pairs) = @_;
    return $self->{codec}->read_wav($path, @pairs);
}

sub receive_result {
    my ($self, $session, $result, @pairs) = @_;
    my $result_class = $self->{profile}->mode eq 'CW' ? 'Ham::CW::Result' : 'Ham::RTTY::Result';
    fail('QSO_E_ARGUMENT', 'Expected a QSO Session and a matching codec Result')
        unless blessed($session)
        && $session->isa('Ham::QSO::Session')
        && blessed($result)
        && $result->isa($result_class);
    fail('QSO_E_PROFILE', 'Session and adapter profiles differ')
        if $session->snapshot->as_hash->{profile}{name} ne $self->{profile}->name;
    my %args = named_arguments(@pairs);
    options(\%args, qw(id at_ms duration_ms));
    my $uncertain = !$result->complete || @{$result->warnings} ? 1 : 0;
    return $session->receive($result->text, %args, uncertain => $uncertain);
}
1;

=encoding UTF-8

=head1 NAME

Ham::QSO::Adapter - optional real Ham::CW and Ham::RTTY integration

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Ham::QSO;
    my $qso = Ham::QSO->new(profile => 'it-cw');
    my $text = $qso->compose(kind => 'cq', from => 'IU0ABC');
    # Requires the separately installed Ham::CW distribution:
    my $adapter = $qso->adapter(options => {wpm => 20});
    my $symbols = $adapter->encode($text);
    my $analysis = $adapter->decode($symbols);
    print $analysis->status, "\n";

=head1 METHODS

=head2 new

    my $adapter = Ham::QSO::Adapter->new(profile => 'it-rtty', options => {baud => 50});

Profile defaults to it-cw. Loads Ham::CW or Ham::RTTY lazily. options is a copied-by-
constructor plain configuration hash forwarded to that codec, forcing backend perl.
Alternatively supply codec, an existing object of the matching class, without
options. The application owns that object's configuration. Unknown/duplicate
options throw QSO_E_ARGUMENT; missing codec QSO_E_DEPENDENCY. Codec errors retain
their native structured classes. No PDL is needed or selected by this adapter.

=head2 encode

    my $symbols = $adapter->encode($proposal);

Accepts supported text or a prepared proposal with the identical profile. Returns
the codec's symbolic encoding. Does not record TX or consume the proposal.

=head2 decode

    my $analysis = $adapter->decode($symbols);

Returns a semantic Result from actual symbolic decoding. CW requests prefer_prosigns
to preserve AR/SK tokens. No session state is changed.

=head2 wav_bytes

    my $wav = $adapter->wav_bytes($proposal, sample_rate => 8000);

Returns actual WAV bytes using the codec. Options and bounds are the codec's.
Writing or generating audio does not prove transmission.

=head2 write_wav

    $adapter->write_wav($proposal, 'practice.wav');

Forwards supported text and path to the codec's exclusive-create WAV writer.
Accepts the codec's options, including explicit overwrite. Does not advance a QSO.

=head2 read_wav

    my $reception = $adapter->read_wav('practice.wav', wpm => 20, frequency => 700);

Returns the codec's native reception Result, preserving warnings and diagnostics.
Receive hints must match the selected codec. Does not advance a QSO.

=head2 receive_result

    my $snapshot = $adapter->receive_result($session, $reception,
        id => 'rx1', at_ms => 0, duration_ms => 10000);

Explicitly records reception from the matching native codec Result. Requires the
same session profile. Any codec warning or incomplete result forces uncertain=1,
retaining text but withholding semantic proof. The caller supplies actual timing
and event ID. This method never calls transmitted. No automatic acknowledgement,
callsign repair or report completion is performed.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli. Artistic License 2.0.

=cut
