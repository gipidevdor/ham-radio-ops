package Ham::QSO::_Internal::CLI;
use 5.020;
use strict;
use warnings;
use Getopt::Long ();
use JSON::PP;
use Ham::QSO;
use Ham::QSO::_Internal::Validate qw(fail);
use Ham::QSO::_Internal::IO       qw(with_file write_bytes);

sub _help {
    return <<'HELP';
ham-qso COMMAND [OPTIONS] [TEXT]
  compose   --station CALL [--to CALL] [--kind cq|probe|directed]
            [--report RST] [--ack] [--request AGN|QRX|QRS] [--ending TOKEN]
  parse     [--json] [--strict] TEXT
  replay    --station CALL [--peer CALL] [--strict] --input EVENTS.jsonl
  profiles  Print profile metadata and source/rule inventory as JSON
  encode    Encode supported text using Ham::CW or Ham::RTTY
  decode    Decode symbolic Morse or ITA2 and analyse semantics
  wav       --output FILE [--overwrite] TEXT
  receive   --input FILE.wav [--json] [--strict]
Common: --profile it-cw|it-rtty|iaru-cw|iaru-rtty (default it-cw)
Text: --input FILE or stdin; --output FILE, '-' for stdout; --overwrite
Audio: --wpm N --frequency HZ (CW); --baud N --mark HZ --shift HZ (RTTY)
       --sample-rate HZ (generation)
Exit: 0 success; 1 strict uncertainty/violation/incomplete QSO; 2 usage/I/O failure.
No command records on-air transmission except explicit tx events in replay.
HELP
}

sub _read {
    my ($handle) = @_;
    my $text = '';
    while (1) {
        my $count = read $handle, my $chunk, 8192;
        fail('QSO_E_IO', 'Cannot read input') unless defined $count;
        last                                  unless $count;
        $text .= $chunk;
        fail('QSO_E_RESOURCE', 'CLI input exceeds 16 MiB') if length($text) > 16_777_216;
    }
    return $text;
}

sub _options {
    my ($command, $args, $err) = @_;
    my %opt;
    my $parser = Getopt::Long::Parser->new(config => [qw(no_auto_abbrev no_ignore_case)]);
    my $parsed;
    {
        local $SIG{__WARN__} = sub { write_bytes($err, join '', @_); };
        $parsed = $parser->getoptionsfromarray(
            $args, \%opt, qw(profile=s input=s output=s
                overwrite json strict station=s peer=s kind=s to=s report=s ack request=s ending=s
                wpm=f frequency=f baud=f mark=f shift=f sample-rate=i)
        );
    }
    fail('QSO_E_ARGUMENT', 'Invalid command options') unless $parsed;
    my %allowed = map { $_ => 1 } qw(profile input output overwrite json strict);
    $allowed{$_} =
        1
        for $command eq 'compose'                    ? qw(station kind to report ack request ending)
        : $command eq 'replay'                       ? qw(station peer)
        : $command eq 'wav' || $command eq 'receive' ? qw(wpm frequency baud mark shift sample-rate)
        :                                              ();
    fail('QSO_E_ARGUMENT', "Option is not applicable to $command: $_")
        for grep { !$allowed{$_} } keys %opt;
    return \%opt;
}

sub _input_text {
    my ($command, $args, $opt, $in) = @_;
    fail('QSO_E_ARGUMENT', 'Text arguments and --input are mutually exclusive')
        if @{$args} && exists $opt->{input};
    return join ' ', @{$args} if @{$args};
    return '' if $command eq 'receive';
    return with_file($opt->{input}, 'read', sub { return _read($_[0]) }, 0)
        if exists($opt->{input}) && $opt->{input} ne '-';
    return _read($in);
}

sub _replay {
    my ($qso, $text, $opt, $json) = @_;
    my $session = $qso->session(
        station => $opt->{station},
        exists($opt->{peer}) ? (peer => $opt->{peer}) : ()
    );
    my $decoder = JSON::PP->new->utf8;
    for my $line (split /\n/x, $text) {
        next unless $line =~ /\S/x;
        my $event = $decoder->decode($line);
        fail('QSO_E_ARGUMENT', 'Each event must be a JSON object') unless ref($event) eq 'HASH';
        if (exists $event->{operator}) {
            my %action   = %{$event};
            my $operator = delete $action{operator};
            fail('QSO_E_ARGUMENT', 'Expected an operator name')
                if !defined($operator) || ref($operator);
            if    ($operator eq 'select_peer') { $session->select_peer(%action) }
            elsif ($operator eq 'abort')       { $session->abort(%action) }
            else                               { fail('QSO_E_ARGUMENT', 'Unknown operator event') }
        }
        else { $session->feed(%{$event}) }
    }
    my $result = $session->finish;
    my $status = $opt->{strict}
        && (!$result->complete || $result->conformance->{status} ne 'satisfied') ? 1 : 0;
    return ($json->encode($result->as_hash), $status);
}

sub _receive_audio {
    my ($qso, $adapter, $opt, $config, $json) = @_;
    fail('QSO_E_ARGUMENT', 'receive requires --input FILE.wav')
        if !exists($opt->{input}) || $opt->{input} eq '-';
    my %hints = %{$config};
    delete $hints{sample_rate};
    my $reception = $adapter->read_wav($opt->{input}, %hints);
    my $analysis  = $qso->parse($reception->text);
    my $output    = $json->encode(
        {
            analysis  => $analysis->as_hash,
            reception => {
                text     => $reception->text,
                complete => $reception->complete,
                warnings => $reception->warnings
            }
        }
    );
    my $status = $opt->{strict}
        && (!$reception->complete
        || @{$reception->warnings}
        || $analysis->status ne 'supported') ? 1 : 0;
    return ($output, $status);
}

sub _codec_output {
    my ($command, $qso, $text, $opt, $context) = @_;
    my ($out, $json) = @{$context}{qw(out json)};
    my %config =
        map { exists($opt->{$_}) ? ($_ => $opt->{$_}) : () } qw(wpm frequency baud mark shift);
    $config{sample_rate} = $opt->{'sample-rate'} if exists $opt->{'sample-rate'};
    my $adapter = $qso->adapter(options => \%config);
    return ($adapter->encode($text) . "\n", 0) if $command eq 'encode';
    if ($command eq 'decode') {
        my $result = $adapter->decode($text);
        return ($json->encode($result->as_hash),
            $opt->{strict} && $result->status ne 'supported' ? 1 : 0);
    }
    return _receive_audio($qso, $adapter, $opt, \%config, $json) if $command eq 'receive';
    fail('QSO_E_ARGUMENT', 'wav requires --output FILE or -') unless exists $opt->{output};
    if ($opt->{output} ne '-') {
        $adapter->write_wav($text, $opt->{output}, overwrite => $opt->{overwrite} // 0);
        return ('', 0, 1);
    }
    binmode $out or fail('QSO_E_IO', 'Cannot set binary stdout');
    return ($adapter->wav_bytes($text), 0);
}

sub _command_output {
    my ($command, $qso, $args, $opt, $context) = @_;
    my ($in, $json) = @{$context}{qw(in json)};
    if ($command eq 'compose' || $command eq 'profiles') {
        fail('QSO_E_ARGUMENT', "$command takes no input text") if @{$args} || exists $opt->{input};
        return ($json->encode({profile => $qso->profile, rules => Ham::QSO::Profile->rules}), 0)
            if $command eq 'profiles';
        my %fields = map { exists($opt->{$_}) ? ($_ => $opt->{$_}) : () }
            qw(kind to report ack request ending);
        return ($qso->compose(from => $opt->{station}, %fields) . "\n", 0);
    }
    my $text = _input_text($command, $args, $opt, $in);
    return _replay($qso, $text, $opt, $json) if $command eq 'replay';
    if ($command eq 'parse') {
        my $result = $qso->parse($text);
        return ($opt->{json} ? $json->encode($result->as_hash) : $result->status . "\n",
            $opt->{strict} && $result->status ne 'supported' ? 1 : 0);
    }
    return _codec_output($command, $qso, $text, $opt, $context);
}

sub _execute {
    my ($argv, $in, $out, $err) = @_;
    my @args = @{$argv};
    if (@args && $args[0] eq '--version') {
        fail('QSO_E_ARGUMENT', '--version takes no arguments') unless @args == 1;
        write_bytes($out, "ham-qso $Ham::QSO::VERSION\n");
        return 0;
    }
    my $command = shift(@args) // 'help';
    if ($command eq 'help' || $command eq '--help') { write_bytes($out, _help()); return 0 }
    my %commands = map { $_ => 1 } qw(compose parse replay profiles encode decode wav receive);
    fail('QSO_E_ARGUMENT', 'Unknown command') unless $commands{$command};
    my $opt  = _options($command, \@args, $err);
    my $qso  = Ham::QSO->new(profile => $opt->{profile} // 'it-cw');
    my $json = JSON::PP->new->utf8->canonical->pretty;
    my ($output, $status, $written) =
        _command_output($command, $qso, \@args, $opt, {in => $in, out => $out, json => $json});
    return $status if $written;

    if (exists($opt->{output}) && $opt->{output} ne '-') {
        with_file(
            $opt->{output}, 'write',
            sub { write_bytes($_[0], $output) },
            $opt->{overwrite} // 0
        );
    }
    else { write_bytes($out, $output) }
    return $status;
}

sub run {
    my ($argv, $in, $out, $err) = @_;
    my $status;
    my $ok = eval { $status = _execute($argv, $in, $out, $err); 1 };
    if (!$ok) {
        my $error = $@;
        print {$err} "$error\n";    ## no critic (InputOutput::RequireCheckedSyscalls)
        return 2;
    }
    return $status;
}
1;
