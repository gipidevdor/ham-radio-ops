use 5.020;
use strict;
use warnings;
use utf8;
use Test::More;
use Encode qw(encode);
use lib 't/lib';
use QSOTest qw(throws);
use Ham::QSO;
use Ham::QSO::ADIF;
my $adif = Ham::QSO->new->adif;
isa_ok($adif, 'Ham::QSO::ADIF');

my $wire = '<qso_date:8:d>20261107<time_on:4>1200<call:6>DL1ABC<mode:2>CW'
    . '<freq:6>14.025<comment:12>A<EOR>B<EOH><eor>';
my $parsed = $adif->decode($wire);
is($parsed->{records}[0]{COMMENT}, 'A<EOR>B<EOH>', 'tags inside a length-delimited value are data');
is($parsed->{records}[0]{TIME_ON}, '1200',         'four-digit UTC time remains exact');
is($parsed->{records}[0]{CALL},    'DL1ABC',       'names and indicators are case-insensitive');
my $out = $adif->encode(%{$parsed});
like($out, qr/\AHam::QSO.*<EOH>/sx, 'ADI header begins with text and terminates explicitly');
like($out, qr/<CALL:6>DL1ABC/x,     'export uses exact ASCII length');
is_deeply($adif->decode($out)->{records},            $parsed->{records}, 'ADI retains values');
is_deeply($adif->decode('<NAME:0><EOR>')->{records}, [{NAME => ''}], 'zero-length field retained');
is($adif->decode('<NAME:03>Ann<EOR>')->{records}[0]{NAME},
    'Ann', 'import accepts leading length zeros');

for my $bad (
    '<CALL:999>DL1ABC<EOR>',     '<CALL:6>DL1ABC',
    '<CALL:6>DL1ABC<EOH>',       '<CALL:6>DL1ABC<call:6>DL2ABC<EOR>',
    'header<CALL:6>DL1ABC<EOR>', '<TIME_ON:4>2460<EOR>',
    '<QSO_DATE:8>20260229<EOR>', '<QSO_DATE:8>19291231<EOR>',
    '<QSO_DATE:8>21000229<EOR>', '<FREQ:3>NaN<EOR>',
    '<TX_PWR:2>-1<EOR>',         '<MODE:3>XYZ<EOR>',
    '<BAND:3>21m<EOR>',          '<SWL:4>true<EOR>',
    '<EOH>',                     '<APP_EXAMPLE_COUNT:1:N>1<eor><APP_EXAMPLE_COUNT:1:S>1<eor>',
    '<NAME_INTL:1:I>A<EOR>'
    )
{
    throws('QSO_E_ADIF', sub { $adif->decode($bad) }, "reject malformed ADI: $bad");
}
for my $date (qw(19300101 20000229 20240229 99991231)) {
    is($adif->validate_record({QSO_DATE => $date})->{QSO_DATE}, $date, "valid date $date");
}
for my $fields (
    {CQZ        => '41'},
    {ITUZ       => '0'},
    {ANT_AZ     => '361'},
    {K_INDEX    => '1.5'},
    {IOTA       => 'EU-000'},
    {LAT        => 'N091 00.000'},
    {LON        => 'E180 00.001'},
    {GRIDSQUARE => 'ZZ00'},
    {SOTA_REF   => 'I/AB-000'},
    {POTA_REF   => 'IT-1234@XX'},
    {MODE       => 'CW', SUBMODE => 'PSK31'},
    {VUCC_GRIDS => 'JN61'},
    {NOTES      => "line1\nline2"},
    {FISTS      => '0'},
    {AGE        => '121'},
    {SWL        => '2'}
    )
{
    throws('QSO_E_ADIF', sub { $adif->validate_record($fields) }, 'reject invalid typed field');
}
my $legacy = $adif->decode('<GUEST_OP:6>IU0ABC<MODE:5>PSK31<eor>');
is($legacy->{records}[0]{GUEST_OP}, 'IU0ABC', 'deprecated field accepted on import');
throws('QSO_E_ADIF', sub { $adif->encode(%{$legacy}) }, 'deprecated fields cannot leak to export');
is($adif->decode('<GRIDSQUARE_EXT:8>AB12CD34<EOR>')->{records}[0]{GRIDSQUARE_EXT},
    'AB12', 'locator extension import ignores characters after four, as specified');
my $unknown = $adif->decode('<FUTURE_FIELD:3>abc<EOR>');
is($unknown->{records}[0]{FUTURE_FIELD}, 'abc', 'unknown import field retained');
throws(
    'QSO_E_ADIF',
    sub { $adif->encode(%{$unknown}) },
    'unknown export needs an extension declaration'
);

my %header =
    (ADIF_VER => '3.1.8', USERDEF1 => 'TEMPERATURE,{-40:60}', USERDEF2 => 'COLOUR,{RED,BLUE}');
my %types = (USERDEF1 => 'N', USERDEF2 => 'E', APP_OURLOGGER_COUNTER => 'N');
my @records =
    ({CALL => 'DL1ABC', TEMPERATURE => '-3.5', COLOUR => 'BLUE', APP_OURLOGGER_COUNTER => '7'});
my $custom = $adif->encode(header => \%header, types => \%types, records => \@records);
is($adif->decode($custom)->{records}[0]{TEMPERATURE}, '-3.5',   'USERDEF numeric range supported');
is($adif->decode($custom)->{types}{APP_OURLOGGER_COUNTER}, 'N', 'application type preserved');

for my $value ('-41', '61') {
    throws(
        'QSO_E_ADIF',
        sub {
            $adif->encode(
                header  => \%header,
                types   => \%types,
                records => [{TEMPERATURE => $value}]
            );
        },
        'USERDEF range enforced'
    );
}
throws(
    'QSO_E_ADIF',
    sub {
        $adif->encode(header => \%header, types => \%types, records => [{COLOUR => 'GREEN'}]);
    },
    'USERDEF enum enforced'
);
throws(
    'QSO_E_ADIF',
    sub {
        $adif->encode(
            header  => {USERDEF1 => 'CALL'},
            types   => {USERDEF1 => 'S'},
            records => [{CALL => 'DL1ABC'}]
        );
    },
    'USERDEF cannot shadow a standard field'
);
throws(
    'QSO_E_ADIF',
    sub {
        $adif->encode(records => [{NAME_INTL => 'José'}]);
    },
    'ADI export refuses lossy international conversion'
);
my $before = {CALL => 'DL1ABC', FREQ => '14.025'};
$adif->encode(records => [$before]);
is_deeply($before, {CALL => 'DL1ABC', FREQ => '14.025'},
    'encoding does not consume caller scalars');
throws('QSO_E_RESOURCE', sub { Ham::QSO::ADIF->new(max_bytes => 8)->decode($wire) }, 'input bound');
throws(
    'QSO_E_RESOURCE',
    sub {
        Ham::QSO::ADIF->new(max_records => 1)->decode('<CALL:1>A<EOR><CALL:1>B<EOR>');
    },
    'record count bound'
);
throws(
    'QSO_E_RESOURCE',
    sub {
        Ham::QSO::ADIF->new(max_field_bytes => 2)->decode('<CALL:3>ABC<EOR>');
    },
    'field bound'
);

SKIP: {
    eval { require XML::Parser; XML::Parser->VERSION('2.59'); 1 }
        or skip 'optional XML::Parser unavailable', 15;
    my $adx =
        $adif->encode(format => 'adx', header => \%header, types => \%types, records => \@records);
    is_deeply($adif->decode($adx)->{records}, \@records, 'ADX preserves typed custom fields');
    my $international = $adif->encode(
        format  => 'adx',
        records => [
            {
                NAME_INTL  => 'José & 李',
                NOTES_INTL => "First\nsecond",
                NOTES      => "A\r\nB",
                COMMENT    => '<EOR> & "quoted"'
            }
        ]
    );
    my $decoded = $adif->decode($international);
    is($decoded->{records}[0]{NAME_INTL}, 'José & 李', 'international ADX is UTF-8');
    is($decoded->{records}[0]{NOTES},
        "A\r\nB", 'XML line ending handling preserves ADIF multiline text');
    is(
        $decoded->{records}[0]{COMMENT},
        '<EOR> & "quoted"',
        'XML escapes preserve literal delimiters'
    );
    my $namespaced = '<?xml version="1.0"?><p:ADX xmlns:p="urn:example"><p:HEADER/>'
        . '<p:RECORDS><p:RECORD><p:CALL>DL1ABC</p:CALL></p:RECORD></p:RECORDS></p:ADX>';
    is($adif->decode($namespaced)->{records}[0]{CALL}, 'DL1ABC', 'namespace prefixes ignored');
    my @bad_xml = (
        '<?xml version="1.0"?><!DOCTYPE ADX [<!ENTITY secret SYSTEM "file:///etc/passwd">]>'
            . '<ADX><HEADER/><RECORDS><RECORD><NOTES>&secret;</NOTES></RECORD></RECORDS></ADX>',
'<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD><CALL><![CDATA[DL1ABC]]></CALL></RECORD></RECORDS></ADX>',
        '<?xml version="1.0"?><adx><HEADER/><RECORDS/></adx>',
'<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD><CALL>A</CALL><CALL>B</CALL></RECORD></RECORDS></ADX>',
'<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD><CALL><B>A</B></CALL></RECORD></RECORDS></ADX>',
        '<?xml version="1.0"?><ADX><RECORDS/><HEADER/></ADX>',
'<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD><APP PROGRAMID="X" FIELDNAME="N" TYPE="N">bad</APP></RECORD></RECORDS></ADX>',
'<?xml version="1.0"?><ADX><HEADER><USERDEF FIELDID="1" TYPE="N" ENUM="{A}" RANGE="{1:2}">X</USERDEF></HEADER><RECORDS/></ADX>'
    );
    throws('QSO_E_ADIF', sub { $adif->decode($_) }, 'reject forbidden or malformed ADX')
        for @bad_xml;
    is_deeply($adif->decode($adif->encode(format => 'adx', records => []))->{records},
        [], 'empty ADX collection valid');
    my $xml_declared = $adif->decode($adif->encode(format => 'adx', records => [{MODE => 'RTTY'}]));
    is($xml_declared->{format}, 'adx', 'format detected from XML declaration');
}
SKIP: {
    eval {
        require XML::Parser;
        XML::Parser->VERSION('2.59');
        require XML::LibXML;
        XML::LibXML->VERSION('2.0213');
        1;
    }
        or skip 'optional XML validators unavailable', 3;
    my $adx =
        $adif->encode(format => 'adx', header => \%header, types => \%types, records => \@records);
    ok($adif->validate_adx($adx), 'typed ADX export passes official 3.1.8 XSD independently');
    my $international =
        $adif->encode(format => 'adx', records => [{NAME_INTL => 'José & 李', FREQ => '14.025'}]);
    ok($adif->validate_adx($international), 'Unicode export passes official XSD');
    throws(
        'QSO_E_ADIF',
        sub {
            $adif->validate_adx(
                      '<?xml version="1.0"?><ADX><HEADER><ADIF_VER>3.1.8</ADIF_VER></HEADER>'
                    . '<RECORDS><RECORD><GUEST_OP>IU0ABC</GUEST_OP></RECORD></RECORDS></ADX>');
        },
        'official export schema rejects a deprecated field accepted for import'
    );
}
subtest 'ADIF data types and compatibility policies' => sub {
    my @valid = (
        [LAT            => 'N041 54.000'],
        [LON            => 'E012 30.000'],
        [MY_LAT         => 'S090 00.000'],
        [GRIDSQUARE     => 'JN61'],
        [GRIDSQUARE     => 'JN61FV12'],
        [GRIDSQUARE_EXT => 'AB12'],
        [VUCC_GRIDS     => 'JN61,JN62'],
        [POTA_REF       => 'IT-1234,US-12345@US-CA'],
        [SOTA_REF       => 'ABCDEFGH/AB-123'],
        [WWFF_REF       => 'I0FF-1234'],
        [IOTA           => 'EU-001'],
        [SWL            => 'y'],
        [K_INDEX        => '9'],
        [TX_PWR         => '.5'],
        [AWARD_GRANTED  => 'ADIF_CENTURY_BASIC,ARRL_DXCC_MIXED'],
        [CREDIT_GRANTED => 'DXCC:CARD&LOTW,IOTA'],
        [USACA_COUNTIES => 'MA,Franklin:MA,Hampshire'],
        [CNTY_ALT       => 'NZ_Regions:Hawkes Bay/Wairoa'],
        [CONTEST_ID     => 'OUR-NEW-CONTEST'],
        [SUBMODE        => 'OUR-NEW-SUBMODE'],
        [DARC_DOK       => 'A01']
    );
    for my $pair (@valid) {
        is($adif->validate_record({$pair->[0] => $pair->[1]})->{$pair->[0]},
            $pair->[1], "accept specified $pair->[0] value");
    }
    my @invalid = (
        [LAT            => 'E041 54.000'],
        [LON            => 'N012 30.000'],
        [LAT            => 'bad'],
        [QSO_DATE       => '20260001'],
        [QSO_DATE       => '20261301'],
        [QSO_DATE       => '20260100'],
        [QSO_DATE       => '2026'],
        [VUCC_GRIDS     => 'JN61,JN62AB'],
        [AWARD_GRANTED  => 'INVALID'],
        [AWARD_GRANTED  => 'NONE_FOO_BAR'],
        [AWARD_GRANTED  => 'ADIF_CENTURY_BASIC:CARD'],
        [CREDIT_GRANTED => 'DXCC:INVALID'],
        [USACA_COUNTIES => 'MA,Franklin'],
        [CNTY_ALT       => 'NZ_Regions:A;NZ_Regions:B']
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->validate_record({$_->[0] => $_->[1]}) },
        "reject invalid $_->[0]"
    ) for @invalid;
    is($adif->validate_record({MODE => 'PSK', SUBMODE => 'PSK31'})->{SUBMODE},
        'PSK31', 'known mode/submode relationship accepted');
    is($adif->validate_record({STATE => 'RM', DXCC => '248'})->{STATE},
        'RM', 'primary subdivision checked in Italian DXCC context');
    is($adif->validate_record({MY_STATE => 'CA', MY_DXCC => '291'})->{MY_STATE},
        'CA', 'own primary subdivision uses own DXCC');
    throws(
        'QSO_E_ADIF',
        sub { $adif->validate_record({STATE => 'ZZ', DXCC => '248'}) },
        'wrong contextual primary subdivision rejected'
    );
    is($adif->validate_record({STATE => 'RM'})->{STATE},
        'RM', 'missing context does not invent a country');
    my $advisory = $adif->encode(
        records => [{SUBMODE => 'A-FUTURE-SUBMODE', CONTEST_ID => 'A-FUTURE-CONTEST'}]);
    ok(length($advisory), 'String enumerations remain advisory, as specified');
    my $historic = $adif->decode('<QSL_RCVD:1>V<EOR>');
    is($historic->{records}[0]{QSL_RCVD}, 'V', 'deprecated enumeration accepted for import');
    throws(
        'QSO_E_ADIF',
        sub { $adif->encode(%{$historic}) },
        'deprecated enumeration refused for export'
    );
    done_testing;
};

subtest 'ADX default types and import compatibility' => sub {
    plan skip_all => 'optional XML parsers unavailable'
        unless eval {
        require XML::Parser;
        XML::Parser->VERSION('2.59');
        require XML::LibXML;
        XML::LibXML->VERSION('2.0213');
        1;
        };
    my $xml = '<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD>'
        . '<APP PROGRAMID="EXAMPLE" FIELDNAME="TEXT">plain</APP></RECORD></RECORDS></ADX>';
    is($adif->decode($xml)->{types}{APP_EXAMPLE_TEXT},
        'M', 'omitted APP type defaults to multiline text');
    ok(
        $adif->validate_adx($xml, direction => 'import'),
        'official generic schema accepts omitted APP type'
    );
    my $typed = '<APP_EXAMPLE_COUNT:1:N>1<EOR><APP_EXAMPLE_COUNT:1>2<EOR>';
    is($adif->decode($typed)->{types}{APP_EXAMPLE_COUNT},
        'N', 'first APP type retained when a later indicator is omitted');
    my $namespaced = '<?xml version="1.0"?><p:ADX xmlns:p="urn:example"><p:HEADER/>'
        . '<p:RECORDS><p:RECORD>ignored record text<p:CALL>DL1ABC</p:CALL></p:RECORD></p:RECORDS></p:ADX>';
    ok($adif->validate_adx($namespaced),
        'namespaces ignored consistently by import and schema validation');

    for my $bad (
        '<?xml version="1.0" encoding="ISO-8859-1"?><ADX><HEADER/><RECORDS/></ADX>',
"<?xml version=\"1.0\"?><ADX><HEADER/><RECORDS><RECORD><NAME_INTL>\xff</NAME_INTL></RECORD></RECORDS></ADX>",
'<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD><USERDEF FIELDNAME="MISSING">x</USERDEF></RECORD></RECORDS></ADX>',
'<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD><APP PROGRAMID="X" FIELDNAME="F" type="S">x</APP></RECORD></RECORDS></ADX>'
        )
    {
        throws(
            'QSO_E_ADIF',
            sub { $adif->decode($bad) },
            'malformed XML encoding or extension declaration rejected'
        );
    }
    done_testing;
};

subtest 'ADIF malformed public inputs and bounded output' => sub {
    for my $fields ([], {call => 'A', CALL => 'B'}, {CALL => []}, {CALL => undef}) {
        my $code = ref($fields) eq 'ARRAY' ? 'QSO_E_ARGUMENT' : 'QSO_E_ADIF';
        throws(
            $code,
            sub { $adif->validate_record($fields) },
            'reject malformed record shape/value'
        );
    }
    for my $name ('', 'BAD:FIELD', 'TRAILING ', 'X' x 513) {
        throws(
            'QSO_E_ADIF',
            sub { $adif->validate_record({$name => 'x'}) },
            'reject invalid field name'
        );
    }
    for my $bytes (undef, '', [], encode('UTF-8', 'Jos\x{e9}')) {
        my $code =
            ref($bytes) || !defined($bytes) || $bytes eq '' ? 'QSO_E_ARGUMENT' : 'QSO_E_ADIF';
        throws($code, sub { $adif->decode($bytes) }, 'reject unusable input');
    }
    throws('QSO_E_ADIF', sub { $adif->decode('<CALL:6 DL1ABC') },   'unterminated tag');
    throws('QSO_E_ADIF', sub { $adif->decode('<CALL:x>A<EOR>') },   'nonnumeric field length');
    throws('QSO_E_ADIF', sub { $adif->decode('header') },           'header without terminator');
    throws('QSO_E_ADIF', sub { $adif->decode('header<EOH>') },      'ADI requires a record');
    throws('QSO_E_ADIF', sub { $adif->decode('<CALL:1:Z>A<EOR>') }, 'unknown indicator');
    throws(
        'QSO_E_ADIF',
        sub { $adif->decode('header<USERDEF1:1>X<EOH><X:1>a<EOR>') },
        'USERDEF needs a declared type'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->encode(format => 'other', records => []) },
        'unknown export format'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->decode('<CALL:1>A<EOR>', format => 'other') },
        'unknown import format'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->validate_record({}, direction => 'other') },
        'unknown direction'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->validate_record({}, format => 'other') },
        'unknown record format'
    );
    throws('QSO_E_ARGUMENT', sub { $adif->encode(records => {}) }, 'record array required');
    throws(
        'QSO_E_ARGUMENT',
        sub { $adif->encode(records => [{CALL => 'A'}], applications => []) },
        'application metadata hash required'
    );
    throws('QSO_E_ADIF', sub { $adif->encode(records => []) }, 'empty ADI cannot be emitted');
    throws(
        'QSO_E_ADIF',
        sub { $adif->encode(records => [{}]) },
        'empty ADI record cannot be emitted'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->encode(header => {ADIF_VER => '3.0.0'}, records => [{CALL => 'A'}]) },
        'export cannot mislabel its edition'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->encode(header => {CALL => 'A'}, records => [{CALL => 'B'}]) },
        'record field cannot appear as a standard header field'
    );
    throws(
        'QSO_E_RESOURCE',
        sub {
            Ham::QSO::ADIF->new(max_records => 1)
                ->encode(records => [{CALL => 'A'}, {CALL => 'B'}]);
        },
        'output record count bound'
    );
    throws(
        'QSO_E_RESOURCE',
        sub {
            Ham::QSO::ADIF->new(max_bytes => 10)->encode(records => [{CALL => 'A'}]);
        },
        'output byte bound'
    );
    throws(
        'QSO_E_RESOURCE',
        sub {
            Ham::QSO::ADIF->new(max_field_bytes => 2)->validate_record({CALL => 'ABC'});
        },
        'API field size bound'
    );
    my $headers = {ADIF_VER => '3.1.8', CREATED_TIMESTAMP => '20261107 123456'};
    ok(length($adif->encode(header => $headers, records => [{CALL => 'A'}])),
        'creation timestamp valid');
    throws(
        'QSO_E_ADIF',
        sub {
            $adif->encode(
                header  => {CREATED_TIMESTAMP => '20260230 250000'},
                records => [{CALL => 'A'}]
            );
        },
        'creation timestamp checked as calendar UTC'
    );
    for my $definition ('X,{-1:-2}', 'X,{a:2}', 'X,{A,B}', 'X,{,A}', ',{A,B}') {
        throws(
            'QSO_E_ADIF',
            sub {
                $adif->encode(
                    header  => {USERDEF1 => $definition},
                    types   => {USERDEF1 => 'N'},
                    records => [{X => '1'}]
                );
            },
            'malformed extension definition rejected'
        );
    }
    my $custom = $adif->encode(
        header  => {USERDEF1 => 'FREE'},
        types   => {USERDEF1 => 'S'},
        records => [{FREE => 'text'}]
    );
    is($adif->decode($custom)->{records}[0]{FREE}, 'text', 'USERDEF without constraints supported');
    done_testing;
};

done_testing;
