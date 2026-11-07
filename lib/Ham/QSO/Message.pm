package Ham::QSO::Message;
use 5.020;
use strict;
use warnings;
use Ham::QSO::Profile;
use Ham::QSO::Result;
use Ham::QSO::_Internal::Validate qw(fail named_arguments options integer is_callsign);
our $VERSION = '0.001';

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'profile');
    return bless {profile => Ham::QSO::Profile->new(name => $args{profile} // 'it-cw')}, $class;
}

sub _analysis {
    my ($text, $status, $code, $message, $semantic) = @_;
    return Ham::QSO::Result->new(
        data => {
            text        => $text,
            status      => $status,
            message     => $semantic,
            diagnostics => defined($code)
            ? [
                {
                    code     => $code,
                    message  => $message,
                    rule     => $code =~ /REPORT/x     ? 'QSO-R004'  : 'QSO-R002',
                    severity => $status eq 'violation' ? 'violation' : 'unknown'
                }
                ]
            : []
        }
    );
}

sub _directed {
    my ($text, $to, $from, $body, $ending) = @_;
    return _analysis($text, 'ambiguous', 'QSO_W_PARTIAL', 'Partial station identity')
        if "$to $from" =~ /\?/x;
    return _analysis($text, 'unsupported', 'QSO_W_HEADER', 'Full addressed identities required')
        unless is_callsign($to) && is_callsign($from);
    my $message = {kind => 'directed', to => $to, from => $from, ending => $ending, ack => 0};
    my $header  = "$to DE $from";
    $body =~ s/(?:\A|[ ])\Q$header\E\z//x;
    if ($body =~ s/\A(?:R|RR)(?:[ ]|\z)//x) { $message->{ack} = 1 }
    if ($body =~ s/\ARST[ ](\S+)(?:[ ]|\z)//x) {
        my $report = $1;
        return _analysis($text, 'ambiguous', 'QSO_W_REPORT', 'Uncertain report')
            if $report =~ /\?/x;
        return _analysis($text, 'unsupported', 'QSO_W_REPORT', 'Abbreviated or nonnumeric report')
            unless $report =~ /\A[0-9]+\z/x;
        return _analysis($text, 'violation', 'QSO_V_REPORT', 'RST must have R=1..5, S=1..9, T=1..9')
            unless $report =~ /\A[1-5][1-9][1-9]\z/x;
        $message->{report} = $report;
    }
    if ($body =~ s/\A(PSE[ ]AGN|AGN|QRX|QRS)(?:[ ]|\z)//x) {
        $message->{request} = $1 eq 'PSE AGN' ? 'AGN' : $1;
    }
    $body =~ s/\A(?:TU[ ])?73\z//x;
    return _analysis($text, 'unsupported', 'QSO_W_BODY',
        'Uninterpreted body; no semantic facts inferred')
        if length($body);
    $message->{kind} = 'close' if $ending eq '<SK>' || $ending eq 'SK' || $ending eq 'CL';
    return _analysis($text, 'supported', undef, undef, $message);
}

sub _broadcast {
    my ($text, $normalized, $ending) = @_;
    if ($normalized =~ /\ACQ(?:[ ]CQ)*[ ]DE[ ](.+)\z/x) {
        my @calls = split /[ ]/x, $1;
        pop @calls if @calls && $calls[-1] eq 'CQ';
        my $from = shift @calls;
        return _analysis($text, 'ambiguous', 'QSO_W_PARTIAL', 'Partial station identity')
            if grep { /\?/x } ($from, @calls);
        return _analysis($text, 'unsupported', 'QSO_W_HEADER', 'Unsupported CQ identity')
            unless is_callsign($from);
        return _analysis($text, 'violation', 'QSO_V_IDENTITY', 'Repeated CQ identities disagree')
            if grep { $_ ne $from } @calls;
        return _analysis($text, 'unsupported', 'QSO_W_ENDING', 'Unsupported CQ termination')
            if $ending ne 'K' && $ending ne 'NONE';
        return _analysis($text, 'supported', undef, undef,
            {kind => 'cq', from => $from, ending => $ending, ack => 0});
    }
    if ($normalized =~ /\AQRL\?[ ]DE[ ](\S+)\z/x) {
        my $from = $1;
        return _analysis($text, 'ambiguous', 'QSO_W_PARTIAL', 'Partial station identity')
            if $from =~ /\?/x;
        return _analysis($text, 'supported', undef, undef,
            {kind => 'probe', from => $from, ending => $ending, ack => 0})
            if is_callsign($from);
    }
    return _analysis($text, 'unsupported', 'QSO_W_GRAMMAR',
        'Outside the supported message grammar');
}

sub parse {
    my ($self, $text) = @_;
    fail('QSO_E_ARGUMENT', 'text must be a defined scalar') if !defined($text) || ref($text);
    fail('QSO_E_RESOURCE', 'text exceeds 8192 characters')  if length($text) > 8192;
    my $normalized = uc $text;
    $normalized =~ s/\s+/ /gx;
    $normalized =~ s/\A[ ]|[ ]\z//gx;
    return _analysis($text, 'unsupported', 'QSO_W_CHARACTER', 'Unsupported character or empty text')
        if !length($normalized)
        || $text       =~ /[^\x09\x0A\x0D\x20-\x7E]/x
        || $normalized =~ /[^A-Z0-9 <>\/?.]/x;
    my $ending = 'NONE';

    if ($normalized =~ s/[ ](K[ ]N|<KN>|KN|K|<AR>|<SK>|SK|CL)\z//x) {
        $ending = $1 eq 'K N' ? 'KN' : $1;
    }
    my $rtty = $self->{profile}->mode eq 'RTTY';
    return _analysis($text, 'unsupported', 'QSO_W_PROSIGN',
        'Mode-specific closing notation required')
        if ($rtty && $ending =~ /[<>]/x) || (!$rtty && $ending eq 'SK');
    return _broadcast($text, $normalized, $ending) if $normalized =~ /\A(?:CQ|QRL\?)(?:[ ]|\z)/x;
    if ($normalized =~ /\A(\S+)[ ]DE[ ](\S+)(?:[ ](.*))?\z/x) {
        return _directed($text, $1, $2, $3 // '', $ending);
    }
    return _broadcast($text, $normalized, $ending);
}

sub _body {
    my ($args) = @_;
    my @body;
    push @body, 'R' if exists($args->{ack}) && integer('ack', $args->{ack}, 0, 1);
    if (exists $args->{report}) {
        fail('QSO_E_ARGUMENT', 'Invalid RST report')
            if !defined($args->{report})
            || ref($args->{report})
            || $args->{report} !~ /\A[1-5][1-9][1-9]\z/x;
        push @body, 'RST', $args->{report};
    }
    if (exists $args->{request}) {
        fail('QSO_E_ARGUMENT', 'request must be AGN, QRX or QRS')
            if !defined($args->{request})
            || ref($args->{request})
            || $args->{request} !~ /\A(?:AGN|QRX|QRS)\z/x;
        push @body, $args->{request};
    }
    return @body;
}

sub _compose_directed {
    my ($args, $ending) = @_;
    fail('QSO_E_ARGUMENT', 'to must be a different full uppercase callsign')
        if !is_callsign($args->{to}) || $args->{to} eq $args->{from};
    my @body = _body($args);
    push @body, '73' if $ending eq '<SK>' || $ending eq 'SK' || $ending eq 'CL';
    return join ' ', $args->{to}, 'DE', $args->{from}, @body, $args->{to}, 'DE', $args->{from};
}

sub _compose_broadcast {
    my ($args, $kind, $rtty) = @_;
    my $ack = exists($args->{ack}) ? integer('ack', $args->{ack}, 0, 1) : 0;
    fail('QSO_E_ARGUMENT', 'CQ/probe cannot carry directed fields')
        if exists($args->{to}) || exists($args->{report}) || exists($args->{request}) || $ack;
    my $from = $args->{from};
    return "QRL? DE $from" if $kind eq 'probe';
    return $rtty ? "CQ DE $from $from CQ" : "CQ CQ CQ DE $from $from $from";
}

sub compose {
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(kind from to ack report request ending));
    my $kind = $args{kind} // 'directed';
    fail('QSO_E_ARGUMENT', 'kind must be directed, cq or probe')
        if ref($kind) || $kind !~ /\A(?:directed|cq|probe)\z/x;
    fail('QSO_E_ARGUMENT', 'from must be a full uppercase callsign')
        unless is_callsign($args{from});
    my $rtty   = $self->{profile}->mode eq 'RTTY';
    my $ending = $args{ending}
        // ($kind eq 'directed' ? 'KN' : ($kind eq 'cq' && !$rtty) ? 'K' : 'NONE');
    fail('QSO_E_ARGUMENT', 'Unsupported canonical ending; use spelled KN, not <KN>')
        if ref($ending)
        || $ending !~ /\A(?:NONE|K|KN|<AR>|<SK>|SK|CL)\z/x;
    fail('QSO_E_ARGUMENT', 'RTTY uses text signals, not CW prosign tokens')
        if $rtty && $ending =~ /[<>]/x;
    my $text =
        $kind eq 'directed'
        ? _compose_directed(\%args, $ending)
        : _compose_broadcast(\%args, $kind, $rtty);
    $text .= " $ending" unless $ending eq 'NONE';
    fail('QSO_E_ARGUMENT', 'Unsupported combination of message fields')
        unless $self->parse($text)->status eq 'supported';
    return $text;
}
1;

=encoding UTF-8

=head1 NAME

Ham::QSO::Message - conservative semantic parsing and canonical composition

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Ham::QSO::Message;
    my $messages = Ham::QSO::Message->new(profile => 'it-cw');
    my $text = $messages->compose(from => 'IU0ABC', to => 'DL1ABC', report => '579');
    my $analysis = $messages->parse($text);
    print $analysis->status, "\n";

=head1 METHODS

=head2 new

    my $messages = Ham::QSO::Message->new(profile => 'it-rtty');

Accepts a Profile name, default it-cw. Unknown/duplicate options are rejected.

=head2 parse

    my $analysis = $messages->parse('IU0ABC DE DL1ABC R RST 579 KN');

Returns L<Ham::QSO::Result>. Keeps original input; compares uppercase text with
whitespace folded. Maximum length 8192 characters. Supported forms are explicit
C<CQ ... DE CALL [CALL ...]>, C<QRL? DE CALL>, or C<TO DE FROM [body]>, optionally
repeating the identical addressed header at the end. Body is an optional leading
C<R> or C<RR>, optional C<RST nnn>, optional C<AGN>, C<PSE AGN>, C<QRX> or C<QRS>,
and optional C<73> or C<TU 73>, in that order. RST ranges: R 1..5, S/T 1..9.
Endings: K, KN (also K N), E<lt>KNE<gt>, E<lt>ARE<gt>, E<lt>SKE<gt>, SK, CL or none.
RTTY rejects angle-bracket CW notation. SK/CL close; 73, TU and AR do not acknowledge
reports or prove contact closure. CW requires E<lt>SKE<gt> for the unspaced closing signal; literal SK is a
RTTY text convention. Received E<lt>KNE<gt> is recognised semantically, but
canonical composition uses spelled KN, matching the Ham::CW repertoire.

Partial calls and uncertain numeric fields return ambiguous. Recognised invalid
RST/repeated identities return violation. Other input is unsupported, never
silently guessed or called illegal. No facts are extracted from unsupported text.
Lexical callsign checks do not prove assignment, nationality or authorisation.
Invalid argument types throw QSO_E_ARGUMENT; oversized text throws QSO_E_RESOURCE.

=head2 compose

    my $text = $messages->compose(from => 'IU0ABC', to => 'DL1ABC', ack => 1,
        report => '579', ending => 'KN');

Returns canonical text, without recording any transmission. Options: kind
(directed default, cq, probe), from, to, ack (0/1, default 0), report, request,
ending (canonical composition excludes E<lt>KNE<gt>). All calls must be uppercase full lexical identities. Directed output
repeats the addressed header at both boundaries. Default ending is KN for directed
messages, K for CW CQ, none for RTTY CQ/probes. CQ/probe forbid directed fields.
Invalid values/combinations throw QSO_E_ARGUMENT; profile errors QSO_E_PROFILE.
These are supported implementation forms, not a claimed universal QSO grammar.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli. Artistic License 2.0.

=cut
