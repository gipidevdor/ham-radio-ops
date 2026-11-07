use 5.020;
use strict;
use warnings;
use utf8;
use Test::More;
use Cwd        qw(getcwd);
use File::Temp qw(tempdir);
use File::Spec;
use lib 't/lib';
use QSOTest qw(throws);
use Ham::QSO;
use Ham::QSO::ADIF;
use IPC::Open3;
use Symbol qw(gensym);
my $adif      = Ham::QSO::ADIF->new;
my $directory = tempdir(CLEANUP => 1);
my %fields    = (
    CALL     => 'DL1ABC',
    OPERATOR => 'IU0ABC',
    MODE     => 'CW',
    QSO_DATE => '20261107',
    TIME_ON  => '120000',
    FREQ     => '14.025'
);

subtest 'Export enforces typed values and byte bounds' => sub {
    throws(
        'QSO_E_ADIF',
        sub { $adif->decode('<NAME:3:N>ABC<EOR>') },
        'a standard field cannot carry invalid data for its explicit type indicator'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->encode(types => {NAME => 'N'}, records => [{NAME => 'ABC'}]) },
        'export checks explicit standard-field indicators too'
    );
    is($adif->decode('<NAME:' . ('0' x 32) . '3>Ann<EOR>')->{records}[0]{NAME},
        'Ann', 'leading length zeroes do not inflate the declared payload size');
    for my $name (qw(QSO_DATE TIME_ON MODE TX_PWR SWL GRIDSQUARE)) {
        throws(
            'QSO_E_ADIF',
            sub { $adif->encode(format => 'adx', records => [{$name => ''}]) },
            "$name cannot produce an invalid empty typed XML field"
        );
    }
    my $empty = $adif->encode(format => 'adx', records => [{NAME => '', NOTES => ''}]);
    like($empty, qr/<NAME><\/NAME>/x, 'empty strings remain representable');
    throws(
        'QSO_E_RESOURCE',
        sub {
            Ham::QSO::ADIF->new(max_bytes => 250)
                ->encode(format => 'adx', records => [{NAME_INTL => '李' x 100}]);
        },
        'Unicode output bound counts bytes'
    );
    throws(
        'QSO_E_ADIF',
        sub {
            $adif->encode(types => {APP_EXAMPLE_UNUSED => 'Z'}, records => [{CALL => 'DL1ABC'}]);
        },
        'unused malformed type declarations are rejected'
    );
    throws(
        'QSO_E_RESOURCE',
        sub {
            Ham::QSO::ADIF->new(max_field_bytes => 4)->encode(
                header  => {USERDEF1 => 'LONGFIELD'},
                types   => {USERDEF1 => 'S'},
                records => [{LONGFIELD => 'x'}]
            );
        },
        'USERDEF header values obey the field byte bound'
    );
    done_testing;
};

subtest 'Header declarations survive normalization' => sub {
    my $wire    = 'source<USERDEF01:5:S>EXTRA<EOH><EXTRA:1>x<EOR>';
    my $decoded = eval { $adif->decode($wire) };
    ok($decoded, 'positive USERDEF IDs with leading zeroes can be imported') or diag($@);
    if ($decoded) {
        my $bytes = eval { $adif->encode(%{$decoded}) };
        ok($bytes, 'imported definitions remain exportable') or diag($@);
        like($bytes // '', qr/<USERDEF1:5:S>EXTRA/x, 'export canonicalizes the declaration ID');
    }
    done_testing;
};

subtest 'Journal binds its path and normalizes interchange context' => sub {
    my $original = getcwd();
    chdir $directory or die $!;
    my $log = Ham::QSO->new->logbook(
        path    => 'relative.jsonl',
        station => 'IU0ABC',
        create  => 1,
        log_id  => 'relative'
    );
    my $elsewhere = tempdir(CLEANUP => 1);
    chdir $elsewhere or die $!;
    my $entry = eval { $log->record(id => 'one', operator => 'IU0ABC', fields => \%fields) };
    my $error = $@;
    chdir $original                                                         or die $!;
    ok($entry, 'changing cwd does not redirect or break an opened logbook') or diag($error);
    my $normalized = Ham::QSO->new->logbook(
        path    => "$directory/context.jsonl",
        station => 'IU0ABC',
        create  => 1,
        log_id  => 'context'
    );
    $normalized->record(
        id       => 'custom',
        operator => 'IU0ABC',
        fields   => {%fields, EXTRA => 'x', APP_EXAMPLE_COUNT => '7'},
        adif     =>
            {header => {userdef1 => 'EXTRA'}, types => {userdef1 => 's', app_example_count => 'n'}}
    );
    my $bytes = eval { $normalized->export_adif };
    ok($bytes, 'case-insensitive declarations remain usable through the journal') or diag($@);

    if ($bytes) {
        my $read = $adif->decode($bytes);
        is($read->{records}[0]{EXTRA}, 'x', 'USERDEF data retained');
        is($read->{types}{APP_EXAMPLE_COUNT}, 'N',
            'application type retains its canonical meaning');
    }
    my $before = $normalized->verify;
    throws(
        'QSO_E_ADIF',
        sub {
            $normalized->record(
                id       => 'malformed',
                operator => 'IU0ABC',
                fields   => \%fields,
                adif     => {
                    applications =>
                        {APP_EXAMPLE_COUNT => {programid => 'WRONG', fieldname => 'COUNT'}}
                }
            );
        },
        'malformed application metadata is rejected before persistence'
    );
    is_deeply($normalized->verify, $before, 'rejected metadata leaves the journal unchanged');
    done_testing;
};

subtest 'ADX structure and resource location' => sub {
    plan skip_all => 'optional XML validators unavailable'
        unless eval { require XML::Parser; require XML::LibXML; 1 };
    for my $name (qw(ADX HEADER RECORDS RECORD)) {
        my $bytes =
              '<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD><'
            . $name
            . '><ADIF_VER>3.1.8</ADIF_VER></'
            . $name
            . '><CALL>DL1ABC</CALL></RECORD></RECORDS></ADX>';
        throws(
            'QSO_E_ADIF',
            sub { $adif->decode($bytes) },
            "nested $name cannot masquerade as a container"
        );
    }
    my $collision =
          '<?xml version="1.0"?><ADX><HEADER/><RECORDS><RECORD>'
        . '<APP PROGRAMID="A_B" FIELDNAME="C">one</APP></RECORD><RECORD>'
        . '<APP PROGRAMID="A" FIELDNAME="B_C">two</APP></RECORD></RECORDS></ADX>';
    throws(
        'QSO_E_ADIF',
        sub { $adif->decode($collision) },
        'ambiguous application names cannot overwrite their provenance'
    );
    my $code =
          'use Ham::QSO::ADIF; use File::Temp qw(tempdir);'
        . 'my $a=Ham::QSO::ADIF->new;chdir tempdir(CLEANUP=>1) or die $!;'
        . '$a->validate_adx(q{<?xml version="1.0"?><ADX><HEADER/><RECORDS/></ADX>});';
    is(system($^X, '-Ilib', '-e', $code),
        0, 'relative library paths remain bound to their schemas after cwd changes');
    my $namespaced =
          '<?xml version="1.0"?><p:ADX xmlns:p="urn:test"><p:HEADER/><p:RECORDS><p:RECORD>'
        . '<p:APP p:PROGRAMID="EXAMPLE" p:FIELDNAME="COUNT" p:TYPE="N">7</p:APP>'
        . '</p:RECORD></p:RECORDS></p:ADX>';
    ok(eval { $adif->validate_adx($namespaced) },
        'namespaces are ignored for attributes as well as elements')
        or diag($@);
    done_testing;
};
subtest 'Exact numeric contracts do not round invalid data into validity' => sub {
    my $low    = '1.00000000000000000001';
    my $high   = '1.00000000000000000002';
    my %header = (USERDEF1 => "EXACT,{$low:$high}");
    my %types  = (USERDEF1 => 'N');
    my $bytes =
        eval { $adif->encode(header => \%header, types => \%types, records => [{EXACT => $low}]) };
    ok($bytes, 'a valid decimal range smaller than floating-point resolution is representable')
        or diag($@);
    throws(
        'QSO_E_ADIF',
        sub {
            $adif->encode(
                header  => \%header,
                types   => \%types,
                records => [{EXACT => '1.00000000000000000003'}]
            );
        },
        'a nearby value outside that exact range is rejected'
    );
    my $tiny = '0.' . ('0' x 399);
    ok(
        eval {
            $adif->encode(
                header  => {USERDEF1 => 'TINY,{' . $tiny . '1:' . $tiny . '2}'},
                types   => \%types,
                records => [{TINY => $tiny . '1'}]
            );
        },
        'underflow does not collapse valid nonzero bounds'
    ) or diag($@);
    for my $value ('1e-400', '4503599627370495.9', '900719925474099.99') {
        my $session = Ham::QSO->new->session(station => 'IU0ABC');
        throws(
            'QSO_E_ARGUMENT',
            sub {
                $session->receive(
                    'IU0ABC DE DL1ABC RST 579 KN',
                    id          => 'fraction',
                    at_ms       => $value,
                    duration_ms => 1
                );
            },
            'fractional clocks cannot become integer clocks through floating-point rounding'
        );
        is($session->snapshot->revision, 0, 'invalid clock leaves session unchanged');
    }
    for my $value ('100e-2', '1.5e1', ' 1.50e1 ', '0e-9999') {
        my $session = Ham::QSO->new->session(station => 'IU0ABC');
        ok(
            eval {
                $session->receive(
                    'IU0ABC DE DL1ABC RST 579 KN',
                    id          => 'exact',
                    at_ms       => $value,
                    duration_ms => 1
                );
            },
            'mathematically integral notation remains valid'
        ) or diag($@);
    }
    done_testing;
};

subtest 'Historical region periods retain every ADIF row' => sub {
    for my $pair ([296 => '20120911'], [0 => '20120912'], [0 => '20180120'], [522 => '20180121']) {
        ok(
            eval {
                $adif->validate_record(
                    {REGION => 'KO', DXCC => "$pair->[0]", QSO_DATE => $pair->[1]});
            },
            "historical KO period $pair->[0]/$pair->[1] remains valid"
        ) or diag($@);
    }
    throws(
        'QSO_E_ADIF',
        sub {
            $adif->validate_record({REGION => 'KO', DXCC => '296', QSO_DATE => '20130901'});
        },
        'the old entity does not leak into a later region period'
    );
    throws(
        'QSO_E_ADIF',
        sub { $adif->validate_record({REGION => 'AI', DXCC => '291'}) },
        'an explicitly wrong DXCC context is rejected'
    );
    done_testing;
};

subtest 'Durable batches and original data remain independent' => sub {
    my $log = Ham::QSO->new->logbook(
        path    => "$directory/batch.jsonl",
        station => 'IU0ABC',
        create  => 1,
        log_id  => 'batch'
    );
    my $wire    = $adif->encode(records => [{%fields}, {%fields}, {%fields}]);
    my $entries = $log->import_adif(bytes => $wire, id_prefix => 'batch', operator => 'IU0ABC');
    is(scalar @{$entries}, 3, 'one import retains every contact');
    $entries->[0]{data}{adif}{header}{PROGRAMID} = 'changed';
    ok(
        !exists $entries->[1]{data}{adif}{header}{PROGRAMID},
        'returned envelopes do not share mutable context'
    );
    my $view = $log->records;
    $view->[1]{data}{fields}{CALL} = 'F1ABC';
    is($log->records->[1]{data}{fields}{CALL},
        'DL1ABC', 'avoiding an extra clone does not expose mutable journal state');
    my $large = 'boundary text ' x 6000;
    $log->record(id => 'long-line', operator => 'IU0ABC', fields => {%fields, NOTES => $large});
    is($log->records->[-1]{data}{fields}{NOTES},
        $large, 'records spanning read chunks retain every byte');
    my $before = $log->verify;
    throws(
        'QSO_E_ARGUMENT',
        sub {
            $log->correct(
                id       => 'surrogate',
                corrects => 'batch-1',
                operator => 'IU0ABC',
                reason   => chr(0xd800),
                fields   => \%fields
            );
        },
        'an invalid Unicode scalar cannot enter the canonical UTF-8 journal'
    );
    is_deeply($log->verify, $before, 'rejected invalid Unicode never reaches disk');
    {
        no warnings 'redefine';
        local *IO::Handle::sync = sub { return 0 };
        throws(
            'QSO_E_IO',
            sub {
                $log->import_adif(bytes => $wire, id_prefix => 'uncertain', operator => 'IU0ABC');
            },
            'a failed batch durability barrier never reports success'
        );
    }
    my $after = $log->verify;
    ok($after->{sequence} > $before->{sequence} && $after->{sequence} <= $before->{sequence} + 3,
        'uncertain commit can be inspected as a complete verified prefix');
    done_testing;
};

subtest 'Interchange views are deterministic and preserve application identity' => sub {
    my $program =
          'use Ham::QSO;use File::Temp qw(tempdir);my $d=tempdir(CLEANUP=>1);'
        . 'my $l=Ham::QSO->new->logbook(path=>"$d/log",station=>"IU0ABC",create=>1,log_id=>"seed");'
        . '$l->record(id=>"q1",operator=>"IU0ABC",fields=>{OPERATOR=>"IU0ABC",MODE=>"CW",'
        . 'QSO_DATE=>"20261107",TIME_ON=>"120000",FREQ=>"14.025",ALPHA=>"a",BETA=>"b"},'
        . 'adif=>{header=>{USERDEF1=>"BETA",USERDEF2=>"ALPHA"},types=>{USERDEF1=>"S",USERDEF2=>"S"}});'
        . 'print $l->export_adif;';
    my @outputs;
    for my $seed (1, 42) {
        local $ENV{PERL_HASH_SEED}    = $seed;
        local $ENV{PERL_PERTURB_KEYS} = 2;
        my $error = gensym;
        my $pid   = open3(my $input, my $output, $error, $^X, '-Ilib', '-e', $program);
        close $input or die $!;
        push @outputs, do { local $/ = undef; <$output> };
        my $diagnostics = do { local $/ = undef; <$error> };
        waitpid $pid, 0;
        is($?, 0, 'independent exporter process succeeds') or diag($diagnostics);
        close $output                                      or die $!;
        close $error                                       or die $!;
    }
    is($outputs[0], $outputs[1], 'hash randomization cannot change USERDEF numbering');
    my $log = Ham::QSO->new->logbook(
        path    => "$directory/application-collision.jsonl",
        station => 'IU0ABC',
        log_id  => 'application-collision',
        create  => 1
    );
    for my $pair (['A_B', 'C'], ['A', 'B_C']) {
        $log->record(
            id       => "record-$pair->[0]",
            operator => 'IU0ABC',
            fields   => {%fields, APP_A_B_C => 'value'},
            adif     =>
                {applications => {APP_A_B_C => {programid => $pair->[0], fieldname => $pair->[1]}}}
        );
    }
    throws(
        'QSO_E_ADIF',
        sub { $log->export_adif(format => 'adx') },
        'separate sources cannot silently redefine an application identity during export'
    );
    done_testing;
};

done_testing;
