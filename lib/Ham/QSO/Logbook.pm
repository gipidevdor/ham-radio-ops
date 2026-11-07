package Ham::QSO::Logbook;
use 5.020;
use strict;
use warnings;
use Carp        qw(croak);
use Digest::SHA qw(sha256_hex);
use Fcntl       qw(O_RDONLY O_RDWR O_APPEND O_CREAT O_EXCL LOCK_SH LOCK_EX SEEK_SET);
use IO::Handle;
use File::Spec;
use Encode qw(FB_CROAK LEAVE_SRC);
use JSON::PP;
use POSIX        qw(strftime);
use Scalar::Util qw(blessed);
use Storable     qw(dclone);
use Time::HiRes  qw(time);
use Ham::QSO::ADIF;
use Ham::QSO::_Internal::Data     qw(plain_data);
use Ham::QSO::_Internal::Validate qw(fail named_arguments options integer is_callsign);
our $VERSION = '0.001';
my $format       = 'ham-qso-logbook-1';
my $zero         = '0' x 64;
my $json         = JSON::PP->new->canonical->utf8;
my $record_limit = 16 * 1024 * 1024;
my $file_limit   = 256 * 1024 * 1024;

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(path station create log_id));
    fail('QSO_E_ARGUMENT', 'path must be a nonempty filename without NUL')
        if !defined($args{path})
        || ref($args{path})
        || !length($args{path})
        || index($args{path}, "\0") >= 0;
    fail('QSO_E_ARGUMENT', 'station must be a full uppercase callsign')
        unless is_callsign($args{station});
    my $create = integer('create', $args{create} // 0, 0, 1);
    _identifier($args{log_id}) if exists $args{log_id};
    fail('QSO_E_ARGUMENT', 'Creating a logbook requires an explicit log_id')
        if $create && !exists $args{log_id};
    my $self = bless {
        path    => File::Spec->rel2abs($args{path}),
        station => $args{station},
        adif    => Ham::QSO::ADIF->new
    }, $class;
    $self->_locked(
        $create ? 'create' : 'read',
        sub {
            my ($fh, $records) = @_;
            if ($create) {
                $self->_write($fh, $records, 'header',
                    {log_id => $args{log_id}, station => $args{station}});
            }
            fail('QSO_E_INTEGRITY', 'Logbook identity differs from the requested log_id')
                if exists($args{log_id}) && $records->[0]{data}{log_id} ne $args{log_id};
            return;
        }
    );
    return $self;
}

sub _identifier {
    my ($value) = @_;
    fail('QSO_E_ARGUMENT', 'IDs must be 1..128 ASCII letters, digits, underscores or hyphens')
        if !defined($value) || ref($value) || $value !~ /\A[A-Za-z0-9_-]{1,128}\z/x;
    return $value;
}

sub _operator {
    my ($value) = @_;
    fail('QSO_E_ARGUMENT', 'operator must be a full uppercase callsign')
        unless is_callsign($value);
    return $value;
}

sub _head {
    my ($records) = @_;
    return {
        log_id   => $records->[0]{data}{log_id},
        station  => $records->[0]{data}{station},
        sequence => $records->[-1]{sequence},
        hash     => $records->[-1]{hash}
    };
}

sub _anchor {
    my ($records, $checkpoint) = @_;
    fail('QSO_E_ARGUMENT', 'checkpoint must be a plain hash')
        unless ref($checkpoint) eq 'HASH';
    options($checkpoint, qw(log_id station sequence hash));
    _identifier($checkpoint->{log_id});
    _operator($checkpoint->{station});
    my $sequence = integer('checkpoint sequence', $checkpoint->{sequence}, 1, 2**52);
    fail('QSO_E_ARGUMENT', 'checkpoint hash must be lowercase SHA-256 hex')
        if !defined($checkpoint->{hash})
        || ref($checkpoint->{hash})
        || $checkpoint->{hash} !~ /\A[0-9a-f]{64}\z/x;
    fail('QSO_E_INTEGRITY', 'Logbook no longer contains the trusted checkpoint')
        if $sequence > @{$records}
        || $records->[0]{data}{log_id} ne $checkpoint->{log_id}
        || $records->[0]{data}{station} ne $checkpoint->{station}
        || $records->[$sequence - 1]{hash} ne $checkpoint->{hash};
    return;
}

sub _valid_utf8 {
    my ($bytes) = @_;
    return 1 unless $bytes =~ /[^\x00-\x7f]/x;
    return eval { Encode::decode('UTF-8', $bytes, FB_CROAK | LEAVE_SRC); 1 } ? 1 : 0;
}

sub _decode_line {
    my ($self, $line, $records, $index) = @_;
    my $entry;
    my $valid = eval {
        die "invalid UTF-8\n" unless _valid_utf8($line);
        $entry = $json->decode($line);
        die "noncanonical record\n" unless ref($entry) eq 'HASH' && $json->encode($entry) eq $line;
        options($entry, qw(format sequence previous_hash hash kind recorded_at_ms data));
        die "record structure\n"
            unless defined($entry->{format})
            && $entry->{format} eq $format
            && ref($entry->{data}) eq 'HASH'
            && defined($entry->{kind})
            && ref($entry->{kind}) eq '';
        integer('sequence',       $entry->{sequence},       1, 2**52);
        integer('recorded_at_ms', $entry->{recorded_at_ms}, 0, 2**52);
        my %body     = %{$entry};
        my $hash     = delete $body{hash};
        my $previous = @{$records} ? $records->[-1]{hash} : $zero;
        die "hash chain\n"
            unless defined($hash)
            && ref($hash) eq ''
            && $hash eq sha256_hex("$format\0" . $json->encode(\%body))
            && $body{sequence} == @{$records} + 1
            && defined($body{previous_hash})
            && $body{previous_hash} eq $previous;
        $self->_validate_record($records, $entry->{kind}, $entry->{data}, $index);
        1;
    };
    fail('QSO_E_INTEGRITY', 'Invalid logbook record at sequence ' . (1 + @{$records}))
        unless $valid;
    push @{$records}, $entry;
    return;
}

sub _scan {
    my ($self, $fh) = @_;
    my @records;
    my $index = {ids => {}, superseded => {}};
    my ($buffer, $bytes) = ('', 0);
    while (1) {
        my $count = sysread $fh, my $chunk, 65536;
        next if !defined($count) && $!{EINTR};
        fail('QSO_E_IO', 'Cannot read logbook') unless defined $count;
        last if $count == 0;
        $bytes += $count;
        fail('QSO_E_RESOURCE', 'Logbook exceeds the 256 MiB file limit') if $bytes > $file_limit;
        $buffer .= $chunk;
        my $offset = 0;

        while ((my $end = index($buffer, "\n", $offset)) >= 0) {
            my $length = $end - $offset;
            fail('QSO_E_RESOURCE', 'Logbook record exceeds 16 MiB') if $length + 1 > $record_limit;
            $self->_decode_line(substr($buffer, $offset, $length), \@records, $index);
            $offset = $end + 1;
        }
        substr($buffer, 0, $offset, '')                         if $offset;
        fail('QSO_E_RESOURCE', 'Logbook record exceeds 16 MiB') if length($buffer) >= $record_limit;
    }
    fail('QSO_E_INTEGRITY', 'Incomplete logbook write; preserve the file for recovery')
        if length $buffer;
    return \@records;
}

sub _locked_read {
    my ($self, $fh, $action) = @_;
    my $path = $self->{path};
    binmode $fh, ':raw' or fail('QSO_E_IO', 'Cannot set logbook binary mode');
    flock $fh, $action eq 'read' ? LOCK_SH : LOCK_EX
        or fail('QSO_E_IO', 'Cannot lock logbook');
    my @opened  = stat $fh;
    my @current = lstat $path;
    fail('QSO_E_IO', 'Logbook file identity changed or file is not regular')
        if !@opened
        || !@current
        || !-f $fh
        || -l $path
        || $opened[0] != $current[0]
        || $opened[1] != $current[1];
    fail('QSO_E_RESOURCE', 'Logbook exceeds the 256 MiB file limit')
        if $opened[7] > $file_limit;
    seek $fh, 0, SEEK_SET or fail('QSO_E_IO', 'Cannot rewind logbook');
    my $records = $self->_scan($fh);
    fail('QSO_E_INTEGRITY', 'Missing logbook header')
        if !@{$records} && $action ne 'create';
    _anchor($records, $self->{observed}) if $self->{observed};
    return $records;
}

sub _locked {
    my ($self, $action, $callback) = @_;
    local $self->{context_cache} = {};
    my $path   = $self->{path};
    my @before = lstat $path;
    fail('QSO_E_IO', 'Logbook must be a regular file, not a symlink or device')
        if @before && (-l _ || !-f _);
    fail('QSO_E_IO', 'Cannot inspect logbook') if !@before && !$!{ENOENT};
    my $flags = $action eq 'read' ? O_RDONLY : O_RDWR | O_APPEND;
    $flags |= O_CREAT | O_EXCL if $action eq 'create';
    sysopen my $fh, $path, $flags, oct('0600')
        or fail('QSO_E_IO', 'Cannot open logbook (creation never replaces an existing file)');
    my $value;
    my $ok = eval {
        my $records = $self->_locked_read($fh, $action);
        $value = $callback->($fh, $records);
        $self->{observed} = _head($records);
        1;
    };
    my $error  = $@;
    my $closed = close $fh;
    croak $error                                                              unless $ok;
    fail('QSO_E_IO', 'Cannot close logbook; commit outcome may be uncertain') unless $closed;
    return $value;
}

sub _compiled_context {
    my ($self, $context, $direction) = @_;
    my $cache = $self->{context_cache};
    my $key   = $cache ? $direction . "\0" . $json->encode($context) : undef;
    return $cache->{$key} if $cache && exists $cache->{$key};
    my $compiled = $self->{adif}->_context({%{$context}, direction => $direction, format => 'adx'});
    $cache->{$key} = $compiled if $cache && keys(%{$cache}) < 32 && length($key) <= 65536;
    return $compiled;
}

sub _fields {
    my ($self, $fields, $context, $direction) = @_;
    $context //= {};
    fail('QSO_E_ARGUMENT', 'adif context must be a plain acyclic hash')
        unless ref($context) eq 'HASH' && plain_data($context);
    options($context, qw(header types applications));
    my $compiled = $self->_compiled_context($context, $direction // 'export');
    my $copy     = $self->{adif}->_validate($fields, {%{$compiled}, scope => 'record'});
    $copy->{STATION_CALLSIGN} //= $self->{station};
    fail('QSO_E_ARGUMENT', 'STATION_CALLSIGN differs from this logbook')
        unless $copy->{STATION_CALLSIGN} eq $self->{station};

    for my $required (qw(OPERATOR QSO_DATE TIME_ON MODE)) {
        fail('QSO_E_ARGUMENT', "Station log requires $required")
            unless defined($copy->{$required}) && length($copy->{$required});
    }
    fail('QSO_E_ARGUMENT', 'Station log requires FREQ or BAND')
        unless length($copy->{FREQ} // '') || length($copy->{BAND} // '');
    return
        wantarray ? ($copy, {map { $_ => $compiled->{$_} } qw(header types applications)}) : $copy;
}

sub _record_index {
    my ($records) = @_;
    my $index = {ids => {}, superseded => {}};
    for my $entry (@{$records}) {
        next if $entry->{kind} eq 'header';
        $index->{ids}{$entry->{data}{id}}              = $entry;
        $index->{superseded}{$entry->{data}{corrects}} = 1 if $entry->{kind} eq 'correction';
    }
    return $index;
}

sub _validate_record {
    my ($self, $records, $kind, $data, $index) = @_;
    if (!@{$records}) {
        options($data, qw(log_id station));
        _identifier($data->{log_id});
        fail('QSO_E_INTEGRITY', 'First record must identify this station logbook')
            unless $kind eq 'header' && ($data->{station} // '') eq $self->{station};
        return;
    }
    fail('QSO_E_ARGUMENT', 'Expected a contact or correction record')
        unless $kind eq 'contact' || $kind eq 'correction';
    $index //= _record_index($records);
    options($data, qw(id operator fields evidence corrects reason adif));
    _identifier($data->{id});
    _operator($data->{operator});
    fail('QSO_E_DUPLICATE', 'Logbook record ID already exists')
        if exists $index->{ids}{$data->{id}};
    $self->_fields($data->{fields}, $data->{adif}, 'import');

    if ($kind eq 'correction') {
        _identifier($data->{corrects});
        fail('QSO_E_ARGUMENT', 'Corrections require a printable reason of 1..1024 characters')
            if !defined($data->{reason})
            || ref($data->{reason})
            || $data->{reason} !~ /\A[^\x00-\x1f\x7f]{1,1024}\z/x;
        my $target = $index->{ids}{$data->{corrects}};
        fail('QSO_E_SEQUENCE', 'Correction target does not exist or has already been corrected')
            if !$target || $index->{superseded}{$data->{corrects}};
        fail('QSO_E_ARGUMENT', 'Correction cannot replace the original session evidence')
            if exists $data->{evidence};
    }
    else {
        fail('QSO_E_ARGUMENT', 'Only corrections may name a target or reason')
            if exists($data->{corrects}) || exists($data->{reason});
        fail('QSO_E_ARGUMENT', 'evidence must be a session snapshot hash')
            if exists($data->{evidence}) && ref($data->{evidence}) ne 'HASH';
    }
    $index->{ids}{$data->{id}}              = {kind => $kind, data => $data};
    $index->{superseded}{$data->{corrects}} = 1 if $kind eq 'correction';
    return;
}

sub _prepare_batch {
    my ($self, $records, $pending, $size) = @_;
    my @checked = @{$records};
    my $index   = _record_index($records);
    my (@entries, @lines);
    my $previous = @{$records} ? $records->[-1]{hash} : $zero;
    for my $candidate (@{$pending}) {
        my ($kind, $data) = @{$candidate}{qw(kind data)};
        $self->_validate_record(\@checked, $kind, $data, $index);
        my $entry = {
            format         => $format,
            sequence       => 1 + @checked,
            previous_hash  => $previous,
            kind           => $kind,
            recorded_at_ms => int(time * 1000),
            data           => $data
        };
        $entry->{hash} = sha256_hex("$format\0" . $json->encode($entry));
        my $bytes = $json->encode($entry) . "\n";
        fail('QSO_E_ARGUMENT', 'Logbook data must contain valid Unicode scalar values')
            unless _valid_utf8($bytes);
        $size += length $bytes;
        fail('QSO_E_RESOURCE', 'Logbook record exceeds 16 MiB or file exceeds 256 MiB')
            if length($bytes) > $record_limit || $size > $file_limit;
        push @entries, $entry;
        push @checked, $entry;
        push @lines,   $bytes;
        $previous = $entry->{hash};
    }
    return (\@entries, \@lines);
}

sub _append_batch {
    my ($self, $fh, $records, $pending) = @_;
    my ($entries, $lines) = $self->_prepare_batch($records, $pending, -s $fh);
    for my $bytes (@{$lines}) {
        my $written = 0;
        while ($written < length $bytes) {
            my $count = syswrite $fh, $bytes, length($bytes) - $written, $written;
            next if !defined($count) && $!{EINTR};
            fail('QSO_E_IO', 'Logbook append failed; preserve file and verify before retrying')
                if !defined($count) || $count <= 0;
            $written += $count;
        }
    }
    $fh->sync
        or fail('QSO_E_IO', 'Logbook sync failed; commit outcome may be uncertain')
        if @{$entries};
    push @{$records}, @{$entries};
    return [map { dclone($_) } @{$entries}];
}

sub _write {
    my ($self, $fh, $records, $kind, $data) = @_;
    return $self->_append_batch($fh, $records, [{kind => $kind, data => $data}])->[0];
}

# The public station-log operation uses the domain term record.
sub record {    ## no critic (NamingConventions::ProhibitAmbiguousNames)
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(id operator fields adif));
    my ($fields, $context) = $self->_fields($args{fields}, $args{adif});
    return $self->_locked(
        'append',
        sub {
            my ($fh, $records) = @_;
            return $self->_write($fh, $records, 'contact',
                {%args, fields => $fields, exists($args{adif}) ? (adif => $context) : ()});
        }
    );
}

sub record_session {
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(id operator session time_origin_ms fields));
    fail('QSO_E_ARGUMENT', 'session must be a Ham::QSO::Session')
        unless blessed($args{session}) && $args{session}->isa('Ham::QSO::Session');
    my $snapshot = $args{session}->snapshot->as_hash;
    fail('QSO_E_SEQUENCE', 'Finish observation before archiving a session')
        unless $snapshot->{lifecycle} eq 'FINISHED';
    fail('QSO_E_ARGUMENT', 'Session belongs to another station')
        unless $snapshot->{station} eq $self->{station};
    my @events = map { $_->{event} ? $_->{event} : () } @{$snapshot->{history}};
    fail('QSO_E_SEQUENCE', 'Session contains no observed events') unless @events;
    my $origin = integer('time_origin_ms', $args{time_origin_ms},       0, 2**52);
    my $start  = integer('UTC start',      $origin + $events[0]{at_ms}, 0, 2**52);
    my $end = integer('UTC end', $origin + $events[-1]{at_ms} + $events[-1]{duration_ms}, 0, 2**52);
    my %derived = (
        STATION_CALLSIGN => $snapshot->{station},
        OPERATOR         => _operator($args{operator}),
        MODE             => $snapshot->{profile}{mode},
        QSO_COMPLETE     => $snapshot->{complete} ? 'Y' : 'N',
        QSO_DATE         => strftime('%Y%m%d', gmtime(int($start / 1000))),
        TIME_ON          => strftime('%H%M%S', gmtime(int($start / 1000))),
        QSO_DATE_OFF     => strftime('%Y%m%d', gmtime(int($end / 1000))),
        TIME_OFF         => strftime('%H%M%S', gmtime(int($end / 1000)))
    );
    $derived{CALL} = $snapshot->{peer} if defined $snapshot->{peer};

    for my $pair ([RST_SENT => 'sent_report'], [RST_RCVD => 'received_report']) {
        $derived{$pair->[0]} = $snapshot->{facts}{$pair->[1]}{value}
            if $snapshot->{facts}{$pair->[1]};
    }
    my $extra = $args{fields} // {};
    fail('QSO_E_ARGUMENT', 'fields must be a hash') unless ref($extra) eq 'HASH';
    my %observed = map { $_ => 1 } qw(STATION_CALLSIGN OPERATOR MODE CALL RST_SENT RST_RCVD
        QSO_COMPLETE QSO_DATE TIME_ON QSO_DATE_OFF TIME_OFF);
    fail('QSO_E_ARGUMENT', 'Session-derived fields cannot be overridden')
        if grep { $observed{uc $_} } keys %{$extra};
    my $fields = $self->_fields({%{$extra}, %derived});
    return $self->_locked(
        'append',
        sub {
            my ($fh, $records) = @_;
            return $self->_write(
                $fh, $records,
                'contact',
                {
                    id       => $args{id},
                    operator => $args{operator},
                    fields   => $fields,
                    evidence => {time_origin_ms => $origin, snapshot => $snapshot}
                }
            );
        }
    );
}

sub correct {
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(id operator corrects reason fields));
    return $self->_locked(
        'append',
        sub {
            my ($fh, $records) = @_;
            _identifier($args{corrects});
            my ($target) = grep { ($_->{data}{id} // '') eq $args{corrects} } @{$records};
            fail('QSO_E_SEQUENCE', 'Correction target does not exist') unless $target;
            my $context = $target->{data}{adif} // {};
            my ($fields, $normalized) = $self->_fields($args{fields}, $context);
            return $self->_write($fh, $records, 'correction',
                {%args, fields => $fields, adif => $normalized});
        }
    );
}

sub import_adif {
    my ($self, @pairs) = @_;
    local $self->{context_cache} = {};
    my %args = named_arguments(@pairs);
    options(\%args, qw(bytes format id_prefix operator));
    _identifier($args{id_prefix});
    _operator($args{operator});
    my $document = Ham::QSO::ADIF->new->decode($args{bytes},
        exists($args{format}) ? (format => $args{format}) : ());
    my $context = {map { $_ => $document->{$_} } qw(header types applications)};
    my @pending;
    my $index = 0;

    for my $entry (@{$document->{records}}) {
        my $fields = $self->_fields({OPERATOR => $self->{station}, %{$entry}}, $context, 'import');
        push @pending,
            {
            id       => $args{id_prefix} . '-' . ++$index,
            operator => $args{operator},
            fields   => $fields,
            adif     => $context
            };
    }
    return $self->_locked(
        'append',
        sub {
            my ($fh, $records) = @_;
            return $self->_append_batch($fh, $records,
                [map { {kind => 'contact', data => $_} } @pending]);
        }
    );
}

sub verify {
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'checkpoint');
    return $self->_locked(
        'read',
        sub {
            my ($fh, $records) = @_;
            _anchor($records, $args{checkpoint}) if exists $args{checkpoint};
            return _head($records);
        }
    );
}

sub records {
    my ($self) = @_;
    return $self->_locked('read', sub { my ($fh, $records) = @_; return $records });
}

sub _merge_context {
    my ($self, $merged, $source, $fields) = @_;
    my $context = $self->_compiled_context($source, 'import');
    for my $key (sort keys %{$context->{header}}) {
        next unless $key =~ /\AUSERDEF[1-9][0-9]*\z/x;
        my $declaration = $context->{header}{$key};
        my ($name) = $declaration =~ /\A([^,]+)/x;
        $name = uc $name;
        next unless exists $fields->{$name};
        my $type     = $context->{types}{$key};
        my $identity = $type . "\0" . uc($declaration);
        my $existing = $merged->{declarations}{$name};
        fail('QSO_E_ADIF', 'Imported USERDEF declarations conflict across contacts')
            if $existing && $existing->{identity} ne $identity;
        $merged->{declarations}{$name} //=
            {identity => $identity, type => $type, value => $declaration};
    }
    for my $key (sort keys %{$context->{types}}) {
        next if $key =~ /\AUSERDEF[1-9][0-9]*\z/x || !exists($fields->{$key});
        my $type = $context->{types}{$key};
        fail('QSO_E_ADIF', 'Application field types conflict across contacts')
            if exists($merged->{types}{$key}) && $merged->{types}{$key} ne $type;
        $merged->{types}{$key} = $type;
    }
    for my $key (sort keys %{$context->{applications}}) {
        next unless exists $fields->{$key};
        my $application = $context->{applications}{$key};
        fail('QSO_E_ADIF', 'Application identifiers conflict across contacts')
            if exists($merged->{applications}{$key})
            && (uc($merged->{applications}{$key}{programid}) ne uc($application->{programid})
            || uc($merged->{applications}{$key}{fieldname}) ne uc($application->{fieldname}));
        $merged->{applications}{$key} //= $application;
    }
    return;
}

sub _export_records {
    my ($self, $records, $output_format) = @_;
    my %superseded =
        map { $_->{data}{corrects} => 1 } grep { $_->{kind} eq 'correction' } @{$records};
    my @current = grep { $_->{kind} ne 'header' && !$superseded{$_->{data}{id}} } @{$records};
    my $merged  = {types => {}, applications => {}, declarations => {}};
    for my $entry (@current) {
        $self->_merge_context($merged, $entry->{data}{adif} // {}, $entry->{data}{fields});
    }
    my %header = (ADIF_VER => '3.1.8', PROGRAMID => 'HamQSO', PROGRAMVERSION => $VERSION);
    my $number = 0;
    for my $name (sort keys %{$merged->{declarations}}) {
        my $key = 'USERDEF' . ++$number;
        $header{$key} = $merged->{declarations}{$name}{value};
        $merged->{types}{$key} = $merged->{declarations}{$name}{type};
    }
    return $self->{adif}->encode(
        records      => [map { $_->{data}{fields} } @current],
        format       => $output_format,
        header       => \%header,
        types        => $merged->{types},
        applications => $merged->{applications}
    );
}

sub export_adif {
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'format');
    return $self->_locked(
        'read',
        sub {
            my ($fh, $records) = @_;
            return $self->_export_records($records, $args{format} // 'adi');
        }
    );
}

1;

=encoding UTF-8

=head1 NAME

Ham::QSO::Logbook - append-only station journal with ADIF interchange

=head1 SYNOPSIS

    use strict;
    use warnings;
    use File::Temp qw(tempdir);
    use Ham::QSO;
    my $directory = tempdir(CLEANUP => 1);
    my $log = Ham::QSO->new->logbook(path => "$directory/station.jsonl",
        station => 'IU0ABC', log_id => 'IU0ABC-2026', create => 1);
    $log->record(id => 'qso1', operator => 'IU0ABC', fields => {
        OPERATOR => 'IU0ABC', CALL => 'DL1ABC', MODE => 'CW',
        QSO_DATE => '20261107', TIME_ON => '120000', FREQ => '14.025',
        RST_SENT => '579', RST_RCVD => '589', QSO_COMPLETE => '?'});
    my $checkpoint = $log->verify;
    print $log->export_adif;

=head1 DESCRIPTION

An internal station log, not a mutable Session history. Canonical UTF-8 JSONL
records are sequenced and SHA-256 chained, locked across cooperating writers and
synced before success. No method truncates, replaces or deletes journal records.
Rectification appends a separately attributed record with a reason and predecessor.
ADIF is interchange, not the immutable archive or a statutory certification.

Local hashes cannot prevent an administrator replacing an entire file. Preserve
checkpoints externally and protect original journals with independently controlled
retention/WORM storage for stronger guarantees. OS time and supplied operator
names are not qualified timestamps or authenticated signatures. File creation does
not sync the parent directory; storage and backup durability remain deployment
responsibilities. An uncertain write is never silently repaired or retried.

=head1 METHODS

=head2 new

    my $log = Ham::QSO::Logbook->new(path => 'station.jsonl', station => 'IU0ABC');

Opens and verifies an existing regular file.
The path is resolved at construction, so later working-directory changes cannot
redirect the journal. C<create =E<gt> 1> requires C<log_id>
(1..128 ASCII alphanumeric, underscore/hyphen) and exclusively creates mode 0600.
Never recreates a missing existing log, overwrites a file or follows a final
symlink. Optional log_id on reopening must match. Use a directory protected from
replacement by other writers. Rejects unsupported locking/sync rather than
silently weakening guarantees. Bounds: 16 MiB per record, 256 MiB per file;
larger journals require an explicit archival/rotation policy outside this API.

=head2 record

    my $entry = $log->record(id => 'qso1', operator => 'IU0ABC', fields => $fields);

Appends a manually attested contact. Returns an independent envelope hash.
IDs are unique across the journal. Operator is a lexical callsign, not verified
authentication. Fields use ADIF names/strings. Requires OPERATOR, MODE, QSO_DATE,
TIME_ON and FREQ or BAND; supplies STATION_CALLSIGN, rejecting another station.
Incomplete contacts may omit unknown CALL/reports; no observations are invented.
Optional adif => {header, types, applications} preserves extension declarations.

=head2 record_session

    my $entry = $log->record_session(id => 'qso2', operator => 'IU0ABC',
        session => $session, time_origin_ms => 1794052800000,
        fields => {FREQ => '14.025'});

Archives a finished, nonempty Session of this station, including all original
evidence, uncertainty and diagnostics. Requires explicit Unix UTC origin in
milliseconds (0..2**52); add each event's at_ms to that origin. Use zero when
event clocks already contain Unix milliseconds. Derives UTC on/off dates and
times, peer, mode, actual reports and QSO_COMPLETE, without overriding supplied
evidence or treating EOF as contact closure. fields adds external metadata; it
cannot override derived fields. Does not mutate the Session.

=head2 correct

    my $entry = $log->correct(id => 'fix1', corrects => 'qso1',
        operator => 'IU0ABC', reason => 'Corrected recorded frequency',
        fields => $complete_replacement_fields);

Appends a full revised ADIF field set; preserves predecessor and original
evidence. Requires a current unsuperseded contact/correction ID and a nonempty
reason of at most 1024 printable characters. Concurrent or stale corrections
are rejected under lock. No original evidence is replaced.

=head2 verify

    my $checkpoint = $log->verify;
    $log->verify(checkpoint => $previously_trusted_checkpoint);

Verifies every record and returns {log_id, station, sequence, hash}. A checkpoint
must be obtained independently or preserved before a suspected alteration.
It verifies an anchored prefix while allowing subsequent legitimate appends.
The same instance also remembers its observed head to detect rollback. A fresh
instance without an external checkpoint cannot detect a wholly rewritten chain
or a cleanly removed suffix. Verification does not attest legal compliance.

=head2 import_adif

    my $entries = $log->import_adif(bytes => $bytes, id_prefix => 'import1',
        operator => 'IU0ABC', format => 'adi');

Decodes ADI/ADX and appends attributed contacts with IDs import1-1, import1-2, etc.
Returns independent envelopes. Preserves USERDEF/application types and source
header metadata. Requires the station-log field set; rejects foreign stations.
Missing OPERATOR defaults to the station callsign. The supplied operator is the
import actor, separate from original contact attribution. All input and duplicate
IDs and exact serialized sizes are checked under one lock before the first append.
One durability barrier commits the entire prepared batch before success. An
I/O failure may leave a
committed prefix of an import; inspect IDs before retrying. No all-or-nothing
batch durability is claimed. Imported data never proves actual transmission.

=head2 records

    my $history = $log->records;

Returns independent verified envelopes, including header and every correction.
Reads and appends scan the complete journal: time and memory are O(file size).
Record input is read in bounded chunks; an oversized unterminated line cannot
allocate the entire file as one string. No shared mutable snapshot cache is used.

=head2 export_adif

    my $bytes = $log->export_adif(format => 'adi');

Returns ADI (default) or ADX UTF-8 bytes for the latest version of each contact.
All original versions remain in the journal; export is not a backup of evidence.
Does not write a file or modify the journal.
Only declarations referenced by the current contact view are merged. USERDEF
numbering is deterministic; incompatible application identities or field types
fail explicitly. Original source declarations remain in the journal.

=head1 ERRORS

QSO_E_ARGUMENT for malformed input, QSO_E_DUPLICATE for reused IDs,
QSO_E_SEQUENCE for stale corrections or an unready session, QSO_E_INTEGRITY for
damaged or rolled-back journals, QSO_E_IO for file/lock/sync errors and
QSO_E_RESOURCE for bounds. A write/sync/close failure can have an uncertain
commit outcome: inspect the journal and record ID before any retry. Incomplete
records block future writes; preserve the original rather than auto-truncating.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli. Artistic License 2.0.

=cut
