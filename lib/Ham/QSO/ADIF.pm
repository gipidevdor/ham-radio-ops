package Ham::QSO::ADIF;
use 5.020;
use strict;
use warnings;
use Encode         qw(FB_CROAK LEAVE_SRC);
use Carp           qw(croak);
use File::Basename qw(dirname);
use File::Spec;
use Ham::QSO::_Internal::ADIFData;
use Ham::QSO::_Internal::Data     qw(plain_data);
use Ham::QSO::_Internal::Validate qw(fail named_arguments options integer);
our $VERSION = '0.001';
my $registry         = Ham::QSO::_Internal::ADIFData::registry();
my $schema_directory = File::Spec->catdir(File::Spec->rel2abs(dirname(__FILE__)), '_Internal');
my %schemas;
my %indicators = (
    B => 'Boolean',
    N => 'Number',
    D => 'Date',
    T => 'Time',
    S => 'String',
    I => 'IntlString',
    M => 'MultilineString',
    G => 'IntlMultilineString',
    E => 'Enumeration',
    L => 'Location'
);
my %bounds = (
    AGE               => [ 0,  120],
    ANT_AZ            => [ 0,  360],
    ANT_EL            => [-90, 90],
    A_INDEX           => [ 0,  400],
    CQZ               => [ 1,  40],
    MY_CQ_ZONE        => [ 1,  40],
    ITUZ              => [ 1,  90],
    MY_ITU_ZONE       => [ 1,  90],
    IOTA_ISLAND_ID    => [ 1,  99999999],
    MY_IOTA_ISLAND_ID => [ 1,  99999999],
    K_INDEX           => [ 0,  9],
    SFI               => [ 0,  300],
    DISTANCE          => [0],
    MS_SHOWER         => [],
    MAX_BURSTS        => [0],
    NR_BURSTS         => [0],
    NR_PINGS          => [0],
    RX_PWR            => [0],
    TX_PWR            => [0],
    SRX               => [0],
    STX               => [0]
);

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(max_bytes max_records max_field_bytes));
    return bless {
        max_bytes =>
            integer('max_bytes', $args{max_bytes} // 64 * 1024 * 1024, 1, 256 * 1024 * 1024),
        max_records     => integer('max_records', $args{max_records} // 100_000, 1, 1_000_000),
        max_field_bytes =>
            integer('max_field_bytes', $args{max_field_bytes} // 1024 * 1024, 1, 16 * 1024 * 1024)
    }, $class;
}

sub _bad {
    my ($message) = @_;
    fail('QSO_E_ADIF', $message);
    return;
}

sub _name {
    my ($name) = @_;
    _bad('Invalid ADIF field name')
        if !defined($name)
        || ref($name)
        || !length($name)
        || length($name) > 512
        || $name =~ /[^\x20-\x7e]|[,:<>{}]|[ ]\z/x;
    return uc $name;
}

sub _type {
    my ($indicator) = @_;
    _bad('Unknown ADIF data type indicator')
        if !defined($indicator) || ref($indicator) || !exists $indicators{uc $indicator};
    return uc $indicator;
}

sub _hash {
    my ($value) = @_;
    fail('QSO_E_ARGUMENT', 'Expected a plain acyclic ADIF hash')
        unless ref($value) eq 'HASH' && plain_data($value);
    my %copy;
    for my $name (keys %{$value}) {
        my $key = _name($name);
        _bad('Duplicate case-insensitive ADIF field name') if exists $copy{$key};
        _bad("$key must contain a defined scalar")
            if !defined($value->{$name}) || ref($value->{$name});
        $copy{$key} = "$value->{$name}";
    }
    return \%copy;
}

sub _date {
    my ($value) = @_;
    return 0 unless $value =~ /\A([0-9]{4})([0-9]{2})([0-9]{2})\z/x;
    my ($year, $month, $day) = ($1, $2, $3);
    return 0 if $year < 1930 || $month < 1 || $month > 12 || $day < 1;
    my @days = (
        31, $year % 4 == 0 && ($year % 100 != 0 || $year % 400 == 0) ? 29 : 28,
        31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    );
    return $day <= $days[$month - 1] ? 1 : 0;
}

sub _grid {
    my ($value) = @_;
    return $value =~ /\A[A-R]{2}(?:[0-9]{2}(?:[A-X]{2}(?:[0-9]{2})?)?)?\z/ix ? 1 : 0;
}

sub _number {
    my ($value) = @_;
    return $value =~ /\A-?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)\z/x ? 1 : 0;
}

sub _decimal_parts {
    my ($value) = @_;
    my $sign = $value =~ s/\A-//x ? -1 : 1;
    my ($whole, $fraction) = split /\./x, $value, 2;
    $whole =~ s/\A0+//x;
    $whole = '0' unless length $whole;
    $fraction //= '';
    $fraction =~ s/0+\z//x;
    $sign = 0 if $whole eq '0' && $fraction eq '';
    return ($sign, $whole, $fraction);
}

sub _compare_decimal {
    my ($first, $operand) = @_;
    my ($first_sign,  $first_whole,  $first_fraction)  = _decimal_parts($first);
    my ($second_sign, $second_whole, $second_fraction) = _decimal_parts($operand);
    return $first_sign <=> $second_sign if $first_sign != $second_sign;
    return 0                            if $first_sign == 0;
    my $order = length($first_whole) <=> length($second_whole) || $first_whole cmp $second_whole;
    if (!$order) {
        my $places =
              length($first_fraction) > length($second_fraction)
            ? length($first_fraction)
            : length($second_fraction);
        $first_fraction  .= '0' x ($places - length $first_fraction);
        $second_fraction .= '0' x ($places - length $second_fraction);
        $order = $first_fraction cmp $second_fraction;
    }
    return $first_sign * $order;
}

sub _within_period {
    my ($period, $date) = @_;
    return 1 unless $period->{start} || $period->{end};
    return 0 unless defined $date;
    return (!$period->{start} || $date ge $period->{start})
        && (!$period->{end} || $date le $period->{end});
}

sub _enum {
    my ($enum, $value, $direction, $date, $dxcc) = @_;
    my $table = $registry->{enums}{$enum};
    return unless $table;    # Some administrative enumerations are externally maintained.
    my $item = $table->{uc $value};
    _bad("Invalid $enum enumeration value") unless $item;
    _bad("Import-only $enum value cannot be exported")
        if $direction eq 'export' && $item->{import_only};
    my @periods = grep { !exists($_->{dxcc}) || !defined($dxcc) || $_->{dxcc} eq $dxcc }
        @{$item->{periods} // [$item]};
    _bad("$enum value does not belong to the specified DXCC entity") unless @periods;
    _bad("$enum value is outside its historical date range")
        unless grep { _within_period($_, $date) } @periods;
    return;
}

sub _location {
    my ($value, $name) = @_;
    return 0 unless $value =~ /\A([EWNS])([0-9]{3})[ ]([0-5][0-9]\.[0-9]{3})\z/ix;
    my ($direction, $degrees, $minutes) = (uc $1, $2, $3);
    my $maximum = $direction =~ /[NS]/x ? 90 : 180;
    return 0 if $degrees > $maximum || ($degrees == $maximum && $minutes != 0);
    return 0 if $name =~ /LAT\z/x && $direction !~ /[NS]/x;
    return 0 if $name =~ /LON\z/x && $direction !~ /[EW]/x;
    return 1;
}

sub _grid_list {
    my ($value) = @_;
    my @items   = split /,/x, $value, -1;
    return 0 if @items != 2 && @items != 4;
    return !grep {
               !_grid($_)
            || (length($_) != 4 && length($_) != 6)
            || length($_) !=
            length($items[0])
    } @items;
}

sub _multiline {
    my ($value) = @_;
    $value =~ s/\r\n//gx;
    return $value !~ /[^\x20-\x7e]/x;
}

sub _international {
    my ($value) = @_;
    return $value !~ /[^\x09\x0a\x0d\x20-\x{d7ff}\x{e000}-\x{fffd}\x{10000}-\x{10ffff}]/x;
}

sub _secondary_alt {
    my ($value) = @_;
    my %seen;
    return !grep {
        my ($subdivision) = /\A([^:;]+):[^:;]+\z/x;
        !defined($subdivision) || $seen{uc $subdivision}++ || /[^\x20-\x7e]/x
    } split /;/x, $value, -1;
}

sub _credit_list {
    my ($value, $type, $context) = @_;
    my ($direction, $fields) = @{$context}{qw(direction fields)};
    for my $item (split /,/x, $value, -1) {
        my ($credit, $media) = split /:/x, $item, 2;
        if ($type eq 'CreditList') {
            my $enum = $direction eq 'import'
                && $registry->{enums}{AWARD}{uc $credit} ? 'AWARD' : 'CREDIT';
            _enum($enum, $credit, $direction, $fields->{QSO_DATE});
        }
        else {
            my ($sponsor) = $credit =~ /\A([^_]+)_[^ ,_]+_[^ ,]+\z/x;
            _bad('Malformed sponsored award') unless defined $sponsor;
            _enum('AWARDSPONSOR', $sponsor . '_', $direction, $fields->{QSO_DATE});
            _bad('Sponsored awards cannot specify QSL media') if defined $media;
        }
        if (defined $media) {
            _enum('QSLMEDIUM', $_, $direction, $fields->{QSO_DATE}) for split /&/x, $media, -1;
        }
    }
    return 1;
}

my %lexical_checks = (
    Date            => sub { return _date($_[0]) },
    Time            => sub { return $_[0] =~ /\A(?:[01][0-9]|2[0-3])[0-5][0-9](?:[0-5][0-9])?\z/x },
    Boolean         => sub { return $_[0] =~ /\A[YN]\z/ix },
    Number          => sub { return _number($_[0]) },
    Integer         => sub { return $_[0] =~ /\A-?[0-9]+\z/x },
    PositiveInteger => sub { return $_[0] =~ /\A[0-9]+\z/x && $_[0] =~ /[1-9]/x },
    String          => sub { return $_[0] !~ /[^\x20-\x7e]/x },
    Enumeration     => sub { return $_[0] !~ /[^\x20-\x7e]/x },
    MultilineString     => sub { return _multiline($_[0]) },
    IntlString          => sub { return _international($_[0]) && $_[0] !~ /[\r\n]/x },
    IntlMultilineString => sub { return _international($_[0]) },
    GridSquare          => sub { return _grid($_[0]) },
    GridSquareExt       => sub { return $_[0] =~ /\A[A-X]{2}(?:[0-9]{2})?\z/ix },
    GridSquareList      => sub { return _grid_list($_[0]) },
    Location            => sub { return _location($_[0], $_[1]) },
    IOTARefNo           => sub { return $_[0] =~ /\A(?:AF|AN|AS|EU|NA|OC|SA)-(?!000)[0-9]{3}\z/ix },
    SOTARef             => sub { return $_[0] =~ /\A[A-Z0-9]{1,8}\/[A-Z]{2}-(?!000)[0-9]{3}\z/ix },
    WWFFRef             => sub { return $_[0] =~ /\A[A-Z0-9]{1,4}FF-[0-9]{4}\z/ix },
    POTARefList         => sub {
        return !grep { $_ !~ /\A[A-Z0-9]{1,4}-[0-9]{4,5}(?:\@[A-Z]{2}-[A-Z0-9]{1,3})?\z/ix }
            split /,/x, $_[0], -1;
    },
    SecondarySubdivisionList => sub {
        my @items = split /:/x, $_[0], -1;
        return @items >= 2 && !grep { $_ !~ /\A[A-Z]{2},[^,:\x00-\x1f\x7f]+\z/ix } @items;
    },
    SecondaryAdministrativeSubdivisionListAlt => sub { return _secondary_alt($_[0]) }
);

sub _field_rules {
    my ($name, $value, $definition, $context) = @_;
    my ($direction, $fields) = @{$context}{qw(direction fields)};
    if ($bounds{$name} && @{$bounds{$name}} && _number($value)) {
        my ($minimum, $maximum) = @{$bounds{$name}};
        _bad("$name is outside its specified range")
            if _compare_decimal($value, $minimum) < 0
            || (defined($maximum) && _compare_decimal($value, $maximum) > 0);
    }
    _enum($definition->{enum}, $value, $direction, $fields->{QSO_DATE},
        $definition->{enum} eq 'REGION' ? $fields->{DXCC} : undef)
        if $definition->{type} eq 'Enumeration' && length($definition->{enum} // '');
    if ($name eq 'SUBMODE' && length($fields->{MODE} // '')) {
        my $submode = $registry->{enums}{SUBMODE}{uc $value};
        _bad('SUBMODE does not belong to MODE')
            if $submode && $submode->{mode} ne uc $fields->{MODE};
    }
    if ($name eq 'STATE' || $name eq 'MY_STATE') {
        my $dxcc = $fields->{$name eq 'STATE' ? 'DXCC' : 'MY_DXCC'};
        _enum('PRIMARYADMINISTRATIVESUBDIVISION' . (0 + $dxcc),
            $value, $direction, $fields->{QSO_DATE})
            if defined($dxcc) && $dxcc =~ /\A[0-9]+\z/x;
    }
    return;
}

sub _value {
    my ($self, $name, $value, $definition, $context) = @_;
    my ($direction, $format) = @{$context}{qw(direction format)};
    my $type = $definition->{type};
    my $size = eval { length Encode::encode('UTF-8', $value, FB_CROAK | LEAVE_SRC) };
    _bad("$name contains invalid Unicode") if $@;
    fail('QSO_E_RESOURCE', 'ADIF field exceeds max_field_bytes')
        if $size > $self->{max_field_bytes};
    _bad("$name is an international field unavailable in ADI")
        if $format eq 'adi' && $type =~ /\AIntl/x;
    _bad("$name is import-only") if $direction eq 'export' && $definition->{import_only};
    return if $value eq '' && ($direction eq 'import' || $type =~ /String\z/x);
    _bad("Empty value is not valid for $name") if $value eq '';

    if ($type eq 'CreditList' || $type eq 'SponsoredAwardList') {
        _credit_list($value, $type, $context);
    }
    else {
        my $check = $lexical_checks{$type};
        _bad("Unsupported ADIF type $type")   unless $check;
        _bad("Invalid $type value for $name") unless $check->($value, $name);
    }
    _field_rules($name, $value, $definition, $context);
    return;
}

sub _definitions {
    my ($header, $types) = @_;
    my %definitions;
    for my $key (keys %{$header}) {
        next unless $key =~ /\AUSERDEF[1-9][0-9]*\z/x;
        my $type = _type($types->{$key});
        my ($name, $constraint) = $header->{$key} =~ /\A([^,]+)(?:,\{(.*)\})?\z/x;
        _bad('Malformed USERDEF definition') unless defined $name;
        $name = _name($name);
        _bad('USERDEF names cannot start with a space, repeat, or replace standard fields')
            if $name =~ /\A[ ]/x
            || exists($registry->{fields}{$name})
            || exists($definitions{$name})
            || $name =~ /\A(?:APP_|USERDEF)/x;
        my %definition = (type => $indicators{$type}, enum => '', indicator => $type);
        if (defined $constraint) {
            if ($type eq 'N' && $constraint =~ /\A([^:]+):([^:]+)\z/x) {
                my ($low, $high) = ($1, $2);
                _bad('Invalid USERDEF numeric range')
                    if !_number($low) || !_number($high) || _compare_decimal($low, $high) >= 0;
                $definition{range} = [$low, $high];
            }
            else {
                _bad('Only Enumeration USERDEF fields may declare enumerated values')
                    unless $type eq 'E';
                my @values = split /,/x, $constraint, -1;
                _bad('USERDEF enumeration must contain printable, nonempty values')
                    if grep { !length($_) || /[^\x20-\x7e]|[:<>{}]/x } @values;
                $definition{values} = {map { uc($_) => 1 } @values};
            }
        }
        $definitions{$name} = \%definition;
    }
    return \%definitions;
}

sub _user_key {
    my ($name) = @_;
    return $name unless $name =~ /\AUSERDEF([0-9]+)\z/x;
    my $number = $1;
    $number =~ s/\A0+//x;
    _bad('USERDEF IDs must be positive integers') unless length $number;
    return 'USERDEF' . $number;
}

sub _declaration_hash {
    my ($value) = @_;
    my $original = _hash($value);
    my %normalized;
    for my $key (keys %{$original}) {
        my $name = _user_key($key);
        _bad('Duplicate normalized USERDEF ID') if exists $normalized{$name};
        $normalized{$name} = $original->{$key};
    }
    return \%normalized;
}

sub _same_application {
    my ($previous, $current) = @_;
    return uc($previous->{programid}) eq uc($current->{programid})
        && uc($previous->{fieldname}) eq uc($current->{fieldname});
}

sub _applications {
    my ($applications) = @_;
    fail('QSO_E_ARGUMENT', 'applications must be a plain acyclic hash')
        unless ref($applications) eq 'HASH' && plain_data($applications);
    my %copy;
    for my $key (keys %{$applications}) {
        my $name = _name($key);
        _bad('Duplicate application metadata name') if exists $copy{$name};
        my $application = $applications->{$key};
        _bad('Application metadata must contain programid and fieldname')
            unless ref($application) eq 'HASH';
        _adx_attributes($application, qw(programid fieldname));
        for my $part (qw(programid fieldname)) {
            _bad('Application identifiers must be nonempty printable strings')
                if !defined($application->{$part})
                || ref($application->{$part})
                || $application->{$part} !~ /\A[\x20-\x7e]+\z/x;
        }
        _bad('Application metadata differs from its ADI name')
            unless _name('APP_' . $application->{programid} . '_' . $application->{fieldname}) eq
            $name;
        $copy{$name} = {%{$application}};
    }
    return \%copy;
}

sub _context {
    my ($self, $args) = @_;
    my $direction = $args->{direction} // 'export';
    my $format    = $args->{format}    // 'adx';
    _bad('direction must be import or export') unless $direction =~ /\A(?:import|export)\z/x;
    _bad('format must be adi or adx')          unless $format    =~ /\A(?:adi|adx)\z/x;
    my $header = _declaration_hash($args->{header} // {});
    my $types  = _declaration_hash($args->{types}  // {});
    for my $name (keys %{$types}) {
        $types->{$name} = _type($types->{$name});
        _bad('International data type is unavailable in ADI')
            if $format eq 'adi' && $types->{$name} =~ /[IG]/x;
    }
    my $context = {
        direction    => $direction,
        format       => $format,
        header       => $header,
        types        => $types,
        applications => _applications($args->{applications} // {}),
        definitions  => _definitions($header, $types)
    };
    $self->_validate($header, {%{$context}, scope => 'header', direction => 'import'});
    return $context;
}

sub _definition {
    my ($name, $context) = @_;
    my ($scope, $direction, $types, $definitions) =
        @{$context}{qw(scope direction types definitions)};
    my $definition = $registry->{fields}{$name};
    _bad("$name is not a $scope field") if $definition && $definition->{scope} ne $scope;
    $definition //= $definitions->{$name};
    return $definition if $definition;
    _bad("Unknown export field $name requires APP_ or USERDEF declaration")
        if $direction eq 'export' && $name !~ /\AAPP_.+_.+\z/x;
    my $indicator = exists($types->{$name}) ? _type($types->{$name}) : 'M';
    return {type => $indicators{$indicator}, enum => ''};
}

sub _extension_value {
    my ($name, $value, $definition) = @_;
    return if $value eq '';
    _bad("$name is outside its USERDEF range")
        if $definition->{range}
        && (_compare_decimal($value, $definition->{range}[0]) < 0
        || _compare_decimal($value, $definition->{range}[1]) > 0);
    _bad("$name is not a declared USERDEF value")
        if $definition->{values} && !$definition->{values}{uc $value};
    return;
}

sub _created_timestamp {
    my ($value, $direction) = @_;
    return unless defined $value;
    return if $value eq '' && $direction eq 'import';
    my ($date, $time) = $value =~ /\A([0-9]{8})[ ]([0-9]{6})\z/x;
    _bad('Invalid CREATED_TIMESTAMP')
        unless defined($date)
        && _date($date)
        && $time =~ /\A(?:[01][0-9]|2[0-3])[0-5][0-9][0-5][0-9]\z/x;
    return;
}

sub _validate {
    my ($self,  $entry,     $context) = @_;
    my ($scope, $direction, $format)  = @{$context}{qw(scope direction format)};
    my $copy = _hash($entry);
    for my $name (keys %{$copy}) {
        if ($scope eq 'header' && $name =~ /\AUSERDEF[1-9][0-9]*\z/x) {
            $self->_value($name, $copy->{$name}, {type => 'String'}, $context);
            next;
        }
        my $definition = _definition($name, $context);
        if (exists($context->{types}{$name}) && exists($registry->{fields}{$name})) {
            $self->_value(
                $name, $copy->{$name},
                {type      => $indicators{$context->{types}{$name}}},
                {direction => $direction, format => $format, fields => $copy}
            );
        }
        if ($direction eq 'import') {
            $copy->{$name} =~ s/(?<!\r)\n/\r\n/gx
                if $format eq 'adx' && $definition->{type} eq 'MultilineString';
            $copy->{$name} = substr($copy->{$name}, 0, 4)
                if $definition->{type} eq 'GridSquareExt' && length($copy->{$name}) > 4;
        }
        $self->_value($name, $copy->{$name}, $definition,
            {direction => $direction, format => $format, fields => $copy});
        _extension_value($name, $copy->{$name}, $definition);
    }
    _created_timestamp($copy->{CREATED_TIMESTAMP}, $direction);
    return $copy;
}

sub validate_record {
    my ($self, $entry, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(direction format types header applications));
    return $self->_validate($entry, {%{$self->_context(\%args)}, scope => 'record'});
}

sub _put {
    my ($entry, $name, $value) = @_;
    _bad('Duplicate field within an ADIF record') if exists $entry->{$name};
    $entry->{$name} = $value;
    return;
}

sub _adi_field {
    my ($self, $bytes, $tag, $context) = @_;
    my ($position, $types,  $in_header) = @{$context}{qw(position types in_header)};
    my ($raw_name, $length, $indicator) = $tag =~ /\A([^:]+):([0-9]+)(?::([A-Za-z]))?\z/x;
    _bad('Malformed ADI data specifier') unless defined $raw_name;
    my $name = _name($raw_name);
    $name = _user_key($name) if $in_header;
    $length =~ s/\A0+(?=[0-9])//x;
    fail('QSO_E_RESOURCE', 'ADIF field exceeds max_field_bytes')
        if length($length) > 10 || $length > $self->{max_field_bytes};
    _bad('ADI data length extends beyond the input') if $length > length($bytes) - $position;
    my $value = substr($bytes, $position, $length);
    $position += $length;

    if (defined $indicator) {
        $indicator = _type($indicator);
        _bad('International data type is unavailable in ADI') if $indicator =~ /[IG]/x;
        $self->_value(
            $name, $value,
            {type      => $indicators{$indicator}},
            {direction => 'import', format => 'adi', fields => {}}
        ) if exists $registry->{fields}{$name};
    }
    if ($name =~ /\AAPP_/x) {
        my $type = $indicator // $types->{$name} // 'M';
        _bad('Application field changes its data type')
            if exists($types->{$name}) && $types->{$name} ne $type;
        $types->{$name} = $type;
    }
    elsif ($in_header && $name =~ /\AUSERDEF[1-9][0-9]*\z/x) {
        _bad('USERDEF requires a data type') unless defined $indicator;
        $types->{$name} = $indicator;
    }
    return ($name, $value, $position);
}

sub _decode_adi {
    my ($self, $bytes) = @_;
    _bad('ADI is ASCII; international data requires ADX') if $bytes =~ /[^\x00-\x7f]/x;
    my (%header, %types, @records, %current);
    my $in_header = substr($bytes, 0, 1) ne '<';
    my $position  = 0;
    while ((my $start = index($bytes, '<', $position)) >= 0) {
        my $end = index($bytes, '>', $start + 1);
        _bad('Unterminated ADI tag') if $end < 0;
        my $tag = substr($bytes, $start + 1, $end - $start - 1);
        $position = $end + 1;
        if (uc($tag) eq 'EOH') {
            _bad('Unexpected ADI end of header') unless $in_header;
            $in_header = 0;
            next;
        }
        if (uc($tag) eq 'EOR') {
            _bad('Empty ADI record or EOR inside header') if $in_header || !keys %current;
            push @records, {%current};
            %current = ();
            fail('QSO_E_RESOURCE', 'ADIF record count exceeds max_records')
                if @records > $self->{max_records};
            next;
        }
        my ($name, $value, $next) = $self->_adi_field($bytes, $tag,
            {position => $position, types => \%types, in_header => $in_header});
        $position = $next;
        _put($in_header ? \%header : \%current, $name, $value);
    }
    _bad('ADI header is missing EOH') if $in_header;
    _bad('ADI record is missing EOR') if keys %current;
    _bad('ADI requires at least one record') unless @records;
    return {header => \%header, records => \@records, types => \%types, applications => {}};
}

sub _adx_attributes {
    my ($attributes, @names) = @_;
    my %allowed = map { $_ => 1 } @names;
    _bad('Unsupported or incorrectly cased ADX attribute')
        if grep { !$allowed{$_} } keys %{$attributes};
    return;
}

sub _adx_application {
    my ($attrs, $types, $applications) = @_;
    my $name;
    _adx_attributes($attrs, qw(PROGRAMID FIELDNAME TYPE));
    _bad('ADX APP requires PROGRAMID and FIELDNAME')
        unless length($attrs->{PROGRAMID} // '') && length($attrs->{FIELDNAME} // '');
    $name = _name('APP_' . $attrs->{PROGRAMID} . '_' . $attrs->{FIELDNAME});
    my $type = exists($attrs->{TYPE}) ? _type($attrs->{TYPE}) : $types->{$name} // 'M';
    _bad('Application field changes its data type')
        if exists($types->{$name}) && $types->{$name} ne $type;
    $types->{$name} = $type;
    my $application = {programid => $attrs->{PROGRAMID}, fieldname => $attrs->{FIELDNAME}};
    _bad('Ambiguous application identifiers map to the same ADI name')
        if exists($applications->{$name})
        && !_same_application($applications->{$name}, $application);
    $applications->{$name} = $application;
    return $name;
}

sub _adx_field {
    my ($field, $header, $entry, $context) = @_;
    my ($types, $applications)             = @{$context}{qw(types applications)};
    my ($name, $attrs, $value)             = @{$field}{qw(name attrs text)};
    if ($header && $name eq 'USERDEF') {
        _adx_attributes($attrs, qw(FIELDID TYPE ENUM RANGE));
        _bad('ADX USERDEF FIELDID must be a positive integer')
            unless ($attrs->{FIELDID} // '') =~ /\A[0-9]*[1-9][0-9]*\z/x;
        _bad('ADX USERDEF cannot specify both ENUM and RANGE')
            if exists($attrs->{ENUM}) && exists($attrs->{RANGE});
        $name = _user_key('USERDEF' . $attrs->{FIELDID});
        $types->{$name} = _type($attrs->{TYPE});
        $value .= ',' . $attrs->{ENUM}  if exists $attrs->{ENUM};
        $value .= ',' . $attrs->{RANGE} if exists $attrs->{RANGE};
    }
    elsif (!$header && $name eq 'USERDEF') {
        _adx_attributes($attrs, qw(FIELDNAME TYPE));
        $name = _name($attrs->{FIELDNAME});
        my $definitions = _definitions($context->{header}, $types);
        _bad('ADX USERDEF instance is not declared in the header')
            unless exists $definitions->{$name};
    }
    elsif (!$header && $name eq 'APP') {
        $name = _adx_application($attrs, $types, $applications);
    }
    else { _bad('Standard ADX fields cannot have attributes') if keys %{$attrs} }
    _put($entry, $name, $value);
    return;
}

sub _adx_section {
    my ($state, $name) = @_;
    my $header  = $name eq 'HEADER'  && $state->{seen_header} == 0 && $state->{seen_records} == 0;
    my $records = $name eq 'RECORDS' && $state->{seen_header}      && $state->{seen_records} == 0;
    _bad('ADX requires HEADER followed by RECORDS') if !$header && !$records;
    $state->{seen_header}  = 1 if $header;
    $state->{seen_records} = 1 if $records;
    return;
}

sub _adx_start {
    my ($state, $name, $attrs) = @_;
    _bad('Nested markup is forbidden inside ADX fields') if $state->{field};
    _bad('ADX names must be uppercase')                  if $name ne uc $name;
    my $parent = @{$state->{stack}} ? $state->{stack}[-1] : '';
    if ($parent eq '') {
        _bad('ADX requires an ADX root') unless $name eq 'ADX';
    }
    _adx_section($state, $name) if $parent eq 'ADX';
    if ($parent eq 'RECORDS') {
        _bad('RECORDS may contain only RECORD') unless $name eq 'RECORD';
        $state->{current} = {};
    }
    if ($parent eq 'HEADER' || $parent eq 'RECORD') {
        $state->{field} = {name => $name, attrs => $attrs, text => ''};
    }
    my %containers = map { $_ => 1 } ('', qw(ADX HEADER RECORDS RECORD));
    _bad('Nested markup is forbidden inside ADX fields') unless $containers{$parent};
    _bad('ADX structural elements cannot have attributes') if !$state->{field} && keys %{$attrs};
    push @{$state->{stack}}, $name;
    return;
}

sub _adx_end {
    my ($self, $state, $name) = @_;
    pop @{$state->{stack}};
    if ($state->{field} && $state->{field}{name} eq $name) {
        my $is_header = $state->{stack}[-1] eq 'HEADER';
        _adx_field(
            $state->{field},
            $is_header,
            $is_header ? $state->{header} : $state->{current},
            {
                types        => $state->{types},
                applications => $state->{applications},
                header       => $state->{header}
            }
        );
        $state->{field} = undef;
    }
    elsif ($name eq 'RECORD') {
        push @{$state->{records}}, $state->{current};
        fail('QSO_E_RESOURCE', 'ADIF record count exceeds max_records')
            if @{$state->{records}} > $self->{max_records};
    }
    return;
}

sub _decode_adx {
    my ($self, $bytes) = @_;
    if ($bytes =~ /\A(?:\xef\xbb\xbf)?\s*<\?xml\b([^?]*)\?>/ix) {
        my $declaration = $1;
        if ($declaration =~ /\bencoding\s*=\s*["']([^"']+)["']/ix) {
            _bad('ADX must use UTF-8 encoding') unless uc($1) eq 'UTF-8';
        }
    }
    my $available = eval { require XML::Parser; 1 };
    fail('QSO_E_DEPENDENCY', 'ADX import requires optional XML::Parser 2.59 or later')
        if !$available || $XML::Parser::VERSION < 2.59;
    my $state = {
        header       => {},
        records      => [],
        types        => {},
        applications => {},
        stack        => [],
        current      => {},
        seen_header  => 0,
        seen_records => 0,
        field        => undef
    };
    my $parser = XML::Parser->new(
        Namespaces       => 1,
        ProtocolEncoding => 'UTF-8',
        Handlers         => {
            Doctype    => sub { _bad('DOCTYPE is forbidden in ADX') },
            ExternEnt  => sub { _bad('External entities are forbidden in ADX') },
            CdataStart => sub { _bad('CDATA is forbidden within ADX fields') if $state->{field} },
            Start      => sub {
                my ($expat, $name, %attrs) = @_;
                _adx_start($state, $name, \%attrs);
                return;
            },
            Char => sub {
                my ($expat, $text) = @_;
                if ($state->{field}) {
                    $state->{field}{text} .= $text;
                    fail('QSO_E_RESOURCE', 'ADIF field exceeds max_field_bytes')
                        if length($state->{field}{text}) > $self->{max_field_bytes};
                }
                else {
                    my $parent = @{$state->{stack}} ? $state->{stack}[-1] : '';
                    _bad('Text outside ADX fields') if $text =~ /\S/x && $parent ne 'RECORD';
                }
                return;
            },
            End => sub { my ($expat, $name) = @_; $self->_adx_end($state, $name); return }
        }
    );
    my $ok = eval { $parser->parse($bytes); 1 };
    if (!$ok) {
        my $error = $@;
        croak $error if ref $error;
        _bad('Malformed or forbidden ADX XML');
    }
    _bad('ADX requires HEADER and RECORDS') unless $state->{seen_header} && $state->{seen_records};
    return {map { $_ => $state->{$_} } qw(header records types applications)};
}

sub decode {
    my ($self, $bytes, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'format');
    fail('QSO_E_ARGUMENT', 'ADIF input must be a nonempty byte string')
        if !defined($bytes) || ref($bytes) || !length($bytes) || utf8::is_utf8($bytes);
    fail('QSO_E_RESOURCE', 'ADIF input exceeds max_bytes') if length($bytes) > $self->{max_bytes};
    my $format = $args{format} // ($bytes =~ /\A(?:\xef\xbb\xbf)?\s*<\?xml\b/x ? 'adx' : 'adi');
    _bad('format must be adi or adx') unless $format =~ /\A(?:adi|adx)\z/x;
    my $document = $format eq 'adi' ? $self->_decode_adi($bytes) : $self->_decode_adx($bytes);
    my $context  = $self->_context({%{$document}, direction => 'import', format => $format});
    @{$document}{qw(header types applications)} = @{$context}{qw(header types applications)};

    for my $entry (@{$document->{records}}) {
        $entry = $self->_validate($entry, {%{$context}, scope => 'record'});
    }
    $document->{format} = $format;
    return $document;
}

sub _xml {
    my ($text) = @_;
    $text =~ s/&/&amp;/gx;
    $text =~ s/</&lt;/gx;
    $text =~ s/>/&gt;/gx;
    $text =~ s/"/&quot;/gx;
    $text =~ s/'/&apos;/gx;
    $text =~ s/\r/&#13;/gx;
    return $text;
}

sub validate_adx {
    my ($self, $bytes, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'direction');
    my $direction = $args{direction} // 'export';
    _bad('direction must be import or export') unless $direction =~ /\A(?:import|export)\z/x;
    $self->decode($bytes, format => 'adx');
    my $available = eval { require XML::LibXML; 1 };
    fail('QSO_E_DEPENDENCY', 'Official XSD validation requires optional XML::LibXML 2.0213+')
        if !$available || $XML::LibXML::VERSION < 2.0213;
    my $path = File::Spec->catfile($schema_directory,
        $direction eq 'export' ? 'adx318.xsd' : 'adx318generic.xsd');
    my $valid = eval {
        my $parser   = XML::LibXML->new(no_network => 1, load_ext_dtd => 0, expand_entities => 0);
        my $document = $parser->load_xml(string => $bytes);
        for my $element ($document->findnodes('//*')) {
            $element->setNamespace('', '', 1);
            for my $attribute ($element->attributes) {
                $attribute->setNamespace('', '', 1) if $attribute->nodeType == 2;
            }
        }
        my $schema = $schemas{$direction} //= XML::LibXML::Schema->new(location => $path);
        $schema->validate($document);
        1;
    };
    _bad('ADX does not satisfy the official ADIF XML schema') unless $valid;
    return 1;
}

sub _encode_field {
    my ($name, $value, $context) = @_;
    my ($scope, $format, $types, $definitions, $applications) =
        @{$context}{qw(scope format types definitions applications)};
    my $indicator = $types->{$name};
    if ($format eq 'adi') {
        return
              '<'
            . $name . ':'
            . length($value)
            . (defined($indicator) ? ':' . _type($indicator) : '') . '>'
            . $value;
    }
    if ($scope eq 'header' && $name =~ /\AUSERDEF([1-9][0-9]*)\z/x) {
        my $id = $1;
        my ($field, $constraint) = $value =~ /\A([^,]+)(?:,(\{.*\}))?\z/x;
        my $tag = '<USERDEF FIELDID="' . $id . '" TYPE="' . _type($indicator) . '"';
        $tag .= ' ' . ($indicator eq 'N' ? 'RANGE' : 'ENUM') . '="' . _xml($constraint) . '"'
            if defined $constraint;
        return $tag . '>' . _xml(uc $field) . '</USERDEF>';
    }
    if (exists $definitions->{$name}) {
        return '<USERDEF FIELDNAME="' . _xml($name) . '">' . _xml($value) . '</USERDEF>';
    }
    if ($name =~ /\AAPP_([^_]+)_(.+)\z/x) {
        my ($program, $field) = ($1, $2);
        if (my $application = $applications->{$name}) {
            _bad('Application metadata must contain programid and fieldname')
                unless ref($application) eq 'HASH';
            options($application, qw(programid fieldname));
            _bad('Application metadata differs from ADI field name')
                unless _name('APP_'
                    . ($application->{programid} // '') . '_'
                    . ($application->{fieldname} // '')) eq $name;
            ($program, $field) = @{$application}{qw(programid fieldname)};
        }
        return
              '<APP PROGRAMID="'
            . _xml($program)
            . '" FIELDNAME="'
            . _xml($field)
            . '" TYPE="'
            . _type($indicator // 'M') . '">'
            . _xml($value)
            . '</APP>';
    }
    _bad('Field name cannot be represented as an ADX element')
        unless $name =~ /\A[A-Z_][A-Z0-9_.-]*\z/x;
    return '<' . $name . '>' . _xml($value) . '</' . $name . '>';
}

sub encode {    ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ($self, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(header records types applications format));
    my $context = $self->_context(
        {
            %args,
            format => $args{format} // 'adi',
            header => $args{header} // {ADIF_VER => '3.1.8'}
        }
    );
    my ($format, $header) = @{$context}{qw(format header)};
    _bad('Export ADIF_VER must be 3.1.8')
        if exists($header->{ADIF_VER}) && $header->{ADIF_VER} ne '3.1.8';
    my $records = $args{records};
    fail('QSO_E_ARGUMENT', 'records must be a plain array') unless ref($records) eq 'ARRAY';
    fail('QSO_E_RESOURCE', 'ADIF record count exceeds max_records')
        if @{$records} > $self->{max_records};
    _bad('ADI export requires at least one record') if $format eq 'adi' && !@{$records};
    $self->_validate($header, {%{$context}, scope => 'header'});
    return $self->_serialize({%{$context}, records => $records});
}

sub _append_output {
    my ($self, $output, $text) = @_;
    my $bytes = $text =~ /[^\x00-\x7f]/x ? Encode::encode('UTF-8', $text, FB_CROAK) : $text;
    utf8::downgrade($bytes);
    fail('QSO_E_RESOURCE', 'ADIF output exceeds max_bytes')
        if length(${$output}) + length($bytes) > $self->{max_bytes};
    ${$output} .= $bytes;
    return;
}

sub _serialize {
    my ($self, $context) = @_;
    my ($format, $header, $records) = @{$context}{qw(format header records)};
    my $output = '';
    $self->_append_output(\$output,
        $format eq 'adi'
        ? "Ham::QSO ADIF export\r\n"
        : "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<ADX><HEADER>\n");
    my $separator      = $format eq 'adi' ? "\r\n" : "\n";
    my $header_context = {%{$context}, scope => 'header', definitions => {}};
    for my $name (sort keys %{$header}) {
        $self->_append_output(\$output,
            _encode_field($name, $header->{$name}, $header_context) . $separator);
    }
    $self->_append_output(\$output, $format eq 'adi' ? "<EOH>\r\n" : "</HEADER><RECORDS>\n");
    my $record_context = {%{$context}, scope => 'record'};
    for my $input (@{$records}) {
        my $entry = $self->_validate($input, $record_context);
        _bad('ADI records must contain at least one field') if $format eq 'adi' && !keys %{$entry};
        $self->_append_output(\$output, '<RECORD>')         if $format eq 'adx';
        for my $name (sort keys %{$entry}) {
            $self->_append_output(\$output,
                _encode_field($name, $entry->{$name}, $record_context) . $separator);
        }
        $self->_append_output(\$output, $format eq 'adi' ? "<EOR>\r\n" : "</RECORD>\n");
    }
    $self->_append_output(\$output, "</RECORDS></ADX>\n") if $format eq 'adx';
    return $output;
}

1;

=encoding UTF-8

=head1 NAME

Ham::QSO::ADIF - original ADIF 3.1.8 ADI and ADX interchange implementation

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Ham::QSO::ADIF;
    my $adif = Ham::QSO::ADIF->new;
    my $bytes = $adif->encode(records => [{CALL => 'DL1ABC', MODE => 'CW',
        QSO_DATE => '20261107', TIME_ON => '120000', FREQ => '14.025'}]);
    my $document = $adif->decode($bytes);
    print $document->{records}[0]{CALL}, "\n";

=head1 DESCRIPTION

Implements ADI length-delimited records and ADX XML, with case-insensitive ADI
names, typed application fields and USERDEF declarations. The field registry
contains factual ADIF 3.1.8 identifiers/types and enumeration codes. The original
specification prose is not redistributed. The bundled official XML schemas by
Graham Smith retain their CC0 1.0 dedication and original notices. Reference:
L<https://adif.org.uk/318/ADIF_318.htm>. ADIF specifies interchange, not database
immutability or legal validity. No on-air observations are created by import.

Checks lexical data types, calendar dates, UTC times, numeric bounds, enumerated
codes, supported administrative context, mode/submode association and USERDEF
ranges/enumerations. Decimal range comparisons are exact, without floating-point
rounding or underflow. Historical region rows retain their own date/DXCC context.
Externally maintained awards, administrative datasets and
historical DXCC deletion dates are not independently certified. Unsupported
export values cause errors rather than being silently dropped or guessed.

=head1 METHODS

=head2 new

    my $adif = Ham::QSO::ADIF->new(max_bytes => 67108864, max_records => 100000,
        max_field_bytes => 1048576);

Configurable positive resource bounds: max_bytes 1..256 MiB (default 64 MiB),
max_records 1..1000000 (default 100000), max_field_bytes 1..16 MiB (default 1 MiB).
These are application bounds, not limits imposed by ADIF.
Field names are bounded to 512 ASCII characters. Output limits are checked in
UTF-8 bytes while building the result, including the header and terminators.

=head2 decode

    my $document = $adif->decode($bytes, format => 'adi');

Input is nonempty bytes, not a Perl character string. Format is adi or adx;
the default detects an XML declaration, otherwise ADI. Returns independent
{format, header, records, types, applications}; fields are uppercase keys with
character-string values. No minimum QSO field set is invented by this codec.
Unknown imported fields are retained. Ambiguous duplicate names are rejected.
Positive USERDEF IDs are normalized so equivalent leading-zero spellings cannot
create duplicate declarations. Explicit standard-field indicators must describe
valid values. Empty typed legacy imports remain observable; export requires
valid typed values, while String fields may be empty.
An ADI header begins with text and requires EOH; values are consumed by declared
length, so embedded tags remain data. Import permits deprecated values; export
rejects them rather than emitting invalid ADIF or silently discarding them.

ADX import requires optional XML::Parser 2.59+. DTDs, external entities, nested
field markup and CDATA inside fields are rejected. Namespace prefixes and
processing instructions are ignored; uppercase local names are required.

=head2 encode

    my $bytes = $adif->encode(header => {ADIF_VER => '3.1.8'}, records => $records,
        types => {APP_EXAMPLE_COUNT => 'N'}, format => 'adi');

Returns ASCII ADI or UTF-8 ADX bytes. Header defaults to ADIF_VER 3.1.8. Explicit
headers may omit the version; another declared export version is rejected.
types maps application/USERDEFn fields to B/N/D/T/S/I/M/G/E/L indicators.
USERDEFn header values are FIELDNAME or FIELDNAME,{values/range}; instances use
the declared field name. Unspecified application types default to M.
Optional applications maps APP names to {programid, fieldname} to preserve the
unambiguous ADX spelling when PROGRAMID itself contains underscores.
Application names that flatten to the same ADI identifier with different
program/field boundaries are rejected rather than overwritten.
All decoded document keys are accepted, so C<encode(%{$document})> is possible
when the imported fields remain exportable under this edition.

ADI cannot contain international fields; export fails rather than transliterating
or losing Unicode. Use ADX for these fields. ADI requires at least one nonempty
record; ADX permits an empty record collection. ADX export needs no XML module.
Encoding does not mutate caller data, write files or access a network.

=head2 validate_record

    my $copy = $adif->validate_record($fields, direction => 'export', format => 'adx');

Returns a validated independent hash. Defaults: export direction, adx repertoire.
Optional header, types and applications supply validated extension declarations.
Their names and indicators are normalized without changing caller data. Does not
require a callsign, date, mode or frequency; applications define their required
field set separately. Does not claim a complete or legally compliant contact.

=head2 validate_adx

    $adif->validate_adx($bytes, direction => 'export');

Runs the structural/value importer and the bundled official CC0 XML schema.
Direction is export (default, ADIF 3.1.8) or import (generic 3.0.2..3.1.8).
Returns 1 or throws. Requires optional XML::Parser 2.59+ and XML::LibXML 2.0213+.
The official schemas document limitations; passing XSD alone is not a claim of
exhaustive field semantics. No network access or external entity loading occurs.
Schemas are resolved relative to the installed module at load time and compiled
once per direction. Changing the application's working directory is safe.

=head1 ERRORS

QSO_E_ARGUMENT: invalid API shapes/options; QSO_E_ADIF: malformed or unsupported
interchange/value; QSO_E_RESOURCE: declared bound exceeded; QSO_E_DEPENDENCY:
missing optional ADX importer. Input is never executed or automatically logged.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli. Artistic License 2.0.
ADIF is maintained by the ADIF Developers Group; see NOTICE for source attribution.
XML::Parser is an optional separately installed dependency, not bundled code.

=cut
