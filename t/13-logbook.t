use 5.020;
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempdir);
use File::Spec;
use Config;
use Time::Local qw(timegm);
use Digest::SHA qw(sha256_hex);
use JSON::PP;
use lib 't/lib';
use QSOTest qw(throws completed event);
use Ham::QSO;
my $dir  = tempdir(CLEANUP => 1);
my $path = File::Spec->catfile($dir, 'station.jsonl');
my $qso  = Ham::QSO->new;
my $log  = $qso->logbook(path => $path, station => 'IU0ABC', log_id => 'station-2026', create => 1);
isa_ok($log, 'Ham::QSO::Logbook');
my $initial = $log->verify;
is($initial->{sequence}, 1, 'station identity is the first permanent entry');
my %fields = (
    OPERATOR => 'IU0ABC',
    CALL     => 'DL1ABC',
    MODE     => 'CW',
    QSO_DATE => '20261107',
    TIME_ON  => '120000',
    FREQ     => '14.025',
    RST_SENT => '579',
    RST_RCVD => '589'
);
my $entry = $log->record(id => 'q1', operator => 'IU0ABC', fields => \%fields);
is($entry->{sequence},      2,                'first QSO sequenced after header');
is($entry->{previous_hash}, $initial->{hash}, 'chain links to previous entry');
is($entry->{data}{fields}{STATION_CALLSIGN},
    'IU0ABC', 'station callsign supplied by integrated log');
my $checkpoint = $log->verify;
$entry->{data}{fields}{FREQ} = '7.025';
is($log->records->[1]{data}{fields}{FREQ}, '14.025', 'returned data cannot modify the journal');
throws(
    'QSO_E_DUPLICATE',
    sub { $log->record(id => 'q1', operator => 'IU0ABC', fields => \%fields) },
    'duplicate ID rejected'
);
is($log->verify->{hash}, $checkpoint->{hash}, 'duplicate attempt preserves bytes/head');
throws(
    'QSO_E_IO',
    sub {
        $qso->logbook(path => $path, station => 'IU0ABC', log_id => 'replacement', create => 1);
    },
    'exclusive creation cannot replace a log'
);
throws(
    'QSO_E_INTEGRITY',
    sub { $qso->logbook(path => $path, station => 'F1ABC') },
    'station mismatch rejected'
);
throws(
    'QSO_E_INTEGRITY',
    sub {
        $qso->logbook(path => $path, station => 'IU0ABC', log_id => 'another');
    },
    'log identity mismatch rejected'
);
my $missing = File::Spec->catfile($dir, 'missing.jsonl');
throws(
    'QSO_E_IO',
    sub { $qso->logbook(path => $missing, station => 'IU0ABC') },
    'missing existing journal never silently recreated'
);
ok(!-e $missing, 'missing journal stays absent');

my $correction = $log->correct(
    id       => 'fix1',
    corrects => 'q1',
    operator => 'IU0ABC',
    reason   => 'Frequency copied incorrectly',
    fields   => {%fields, FREQ => '14.026'}
);
is($correction->{data}{corrects},          'q1',     'correction links to original entry');
is($log->records->[1]{data}{fields}{FREQ}, '14.025', 'correction preserves original contact');
my $decoded = $qso->adif->decode($log->export_adif);
is(scalar @{$decoded->{records}}, 1,        'ADIF exports current contact once');
is($decoded->{records}[0]{FREQ},  '14.026', 'ADIF exports corrected view');
throws(
    'QSO_E_SEQUENCE',
    sub {
        $log->correct(
            id       => 'fix2',
            corrects => 'q1',
            operator => 'IU0ABC',
            reason   => 'stale',
            fields   => \%fields
        );
    },
    'stale correction rejected'
);
throws(
    'QSO_E_ARGUMENT',
    sub {
        $log->correct(
            id       => 'fix2',
            corrects => 'fix1',
            operator => 'IU0ABC',
            reason   => '',
            fields   => \%fields
        );
    },
    'correction requires reason'
);
is($log->verify(checkpoint => $checkpoint)->{sequence}, 3, 'anchored prefix permits valid appends');

my $session = $qso->session(station => 'IU0ABC');
completed($session);
throws(
    'QSO_E_SEQUENCE',
    sub {
        $log->record_session(
            id             => 'q2',
            operator       => 'IU0ABC',
            session        => $session,
            time_origin_ms => 1794052800000,
            fields         => {FREQ => '7.025'}
        );
    },
    'only finished observation can be archived'
);
$session->finish;
my $snapshot = $session->snapshot->as_hash;
my $archived = $log->record_session(
    id             => 'q2',
    operator       => 'IU0ABC',
    session        => $session,
    time_origin_ms => 1794052800000,
    fields         => {FREQ => '7.025', TX_PWR => '5'}
);
is($archived->{data}{fields}{RST_SENT},     '579', 'sent report derived from evidence');
is($archived->{data}{fields}{RST_RCVD},     '589', 'received report derived from evidence');
is($archived->{data}{fields}{QSO_COMPLETE}, 'Y',   'completion uses session evidence');
is_deeply($archived->{data}{evidence}{snapshot}, $snapshot, 'original session evidence retained');
is_deeply($session->snapshot->as_hash,           $snapshot, 'logging does not mutate session');
$session->reset;
is_deeply($log->records->[-1]{data}{evidence}{snapshot},
    $snapshot, 'session reset cannot erase archived evidence');
my $partial = $qso->session(station => 'IU0ABC');
event($partial, 1, 'rx', 'IU0? DE DL1? KN', uncertain => 1);
$partial->finish;
my $uncertain = $log->record_session(
    id             => 'partial',
    operator       => 'IU0ABC',
    session        => $partial,
    time_origin_ms => 1794052800000,
    fields         => {FREQ => '7.025'}
);
is($uncertain->{data}{fields}{QSO_COMPLETE}, 'N', 'partial contact explicitly incomplete');
ok(!exists($uncertain->{data}{fields}{CALL}), 'partial identity is never invented');
throws(
    'QSO_E_ARGUMENT',
    sub {
        $log->record_session(
            id             => 'invented',
            operator       => 'IU0ABC',
            session        => $partial,
            time_origin_ms => 1794052800000,
            fields         => {FREQ => '7.025', CALL => 'DL1ABC'}
        );
    },
    'external metadata cannot invent a missing session identity'
);
my $midnight = $qso->session(station => 'IU0ABC');
completed($midnight);
$midnight->finish;
my $crossing = $log->record_session(
    id             => 'midnight',
    operator       => 'IU0ABC',
    session        => $midnight,
    time_origin_ms => 1000 * timegm(50, 59, 23, 7, 10, 2026),
    fields         => {FREQ => '14.025'}
);
is($crossing->{data}{fields}{QSO_DATE}, '20261107', 'start date uses UTC');
is($crossing->{data}{fields}{TIME_ON},  '235950',   'start time uses explicit epoch');
is($crossing->{data}{fields}{QSO_DATE_OFF},
    '20261108', 'contact crossing midnight has distinct off date');
is($crossing->{data}{fields}{TIME_OFF}, '000019', 'end time uses last observed over duration');
my $source = $qso->adif->encode(
    header  => {ADIF_VER => '3.1.8', USERDEF1        => 'TEMPERATURE,{-30:60}'},
    types   => {USERDEF1 => 'N',     APP_OTHER_COUNT => 'N'},
    records => [{%fields, TEMPERATURE => '-2.5', APP_OTHER_COUNT => '3'}]
);
my $imported = $log->import_adif(bytes => $source, id_prefix => 'import', operator => 'IU0ABC');
is($imported->[0]{data}{id}, 'import-1', 'import uses explicit reproducible IDs');
my $reexported = $qso->adif->decode($log->export_adif);
is($reexported->{types}{APP_OTHER_COUNT}, 'N', 'journal import/export preserves application types');
is($reexported->{header}{USERDEF1},
    'TEMPERATURE,{-30:60}', 'journal preserves USERDEF declarations');
my $before_bad_import = $log->verify->{hash};
my $bad_import        = $qso->adif->encode(records => [{%fields}, {CALL => 'F1ABC'}]);
throws(
    'QSO_E_ARGUMENT',
    sub {
        $log->import_adif(bytes => $bad_import, id_prefix => 'invalid', operator => 'IU0ABC');
    },
    'all imported records validated before first append'
);
is($log->verify->{hash}, $before_bad_import, 'invalid import has no committed prefix');
throws(
    'QSO_E_DUPLICATE',
    sub {
        $log->import_adif(bytes => $source, id_prefix => 'import', operator => 'IU0ABC');
    },
    'retrying import cannot duplicate records'
);
my $good_bytes;
{
    open my $fh, '<:raw', $path or die $!;
    local $/;
    $good_bytes = <$fh>;
    close $fh or die $!;
}
my $anchored = $log->verify;

sub overwrite_fixture {
    my ($bytes) = @_;
    open my $fh, '>:raw', $path or die $!;
    print {$fh} $bytes or die $!;
    close $fh          or die $!;
    return;
}
my $tampered = $good_bytes;
$tampered =~ s/14\.025/14.099/x;
overwrite_fixture($tampered);
throws('QSO_E_INTEGRITY', sub { $log->verify }, 'modified QSO breaks SHA-256 chain');
throws(
    'QSO_E_INTEGRITY',
    sub {
        $log->record(id => 'blocked', operator => 'IU0ABC', fields => \%fields);
    },
    'damaged journal blocks append'
);
overwrite_fixture($good_bytes . '{"partial":');
throws(
    'QSO_E_INTEGRITY',
    sub { $log->verify },
    'interrupted append is detected and never truncated automatically'
);
my @lines = split /\n/x, $good_bytes;
overwrite_fixture(join("\n", @lines[0 .. $#lines - 1]) . "\n");
throws('QSO_E_INTEGRITY', sub { $log->verify }, 'same instance detects clean suffix removal');
my $reopened = $qso->logbook(path => $path, station => 'IU0ABC');
throws(
    'QSO_E_INTEGRITY',
    sub { $reopened->verify(checkpoint => $anchored) },
    'external checkpoint detects rollback after reopen'
);
overwrite_fixture($good_bytes);
is($log->verify(checkpoint => $anchored)->{hash},
    $anchored->{hash}, 'restored trusted bytes verify');
my $json  = JSON::PP->new->canonical->utf8;
my $first = $json->decode($lines[0]);
my %body  = %{$first};
delete $body{hash};
is(
    $first->{hash},
    sha256_hex("ham-qso-logbook-1\0" . $json->encode(\%body)),
    'independent hash formula matches published contract'
);
SKIP: {
    my $link = File::Spec->catfile($dir, 'link.jsonl');
    symlink($path, $link) or skip 'symlinks unavailable', 1;
    throws(
        'QSO_E_IO',
        sub { $qso->logbook(path => $link, station => 'IU0ABC') },
        'symlink journal rejected'
    );
}
SKIP: {
    skip 'fork unavailable', 3 unless $Config{d_fork};
    my @children;
    for my $number (1 .. 3) {
        my $pid = fork;
        die $! unless defined $pid;
        if (!$pid) {
            my $ok = eval {
                my $writer = $qso->logbook(path => $path, station => 'IU0ABC');
                for my $index (1 .. 3) {
                    $writer->record(
                        id       => "writer_${number}_$index",
                        operator => 'IU0ABC',
                        fields   => \%fields
                    );
                }
                1;
            };
            exit($ok ? 0 : 1);
        }
        push @children, $pid;
    }
    my $failures = 0;
    for my $pid (@children) { waitpid $pid, 0; $failures++ if $? }
    is($failures, 0, 'cooperating concurrent processes all append successfully');
    is(
        $log->verify->{sequence},
        $anchored->{sequence} + 9,
        'all concurrent contacts retained without gaps'
    );
    is(
        scalar @{$log->records},
        $anchored->{sequence} + 9,
        'concurrent records form one verified chain'
    );
}
subtest 'Station-log boundaries and uncertain commit handling' => sub {
    for my $arguments (
        {path => '',    station => 'IU0ABC'},
        {path => $path, station => 'IU0?'},
        {path => File::Spec->catfile($dir, 'no-id'), station => 'IU0ABC', create => 1}
        )
    {
        throws(
            'QSO_E_ARGUMENT',
            sub { $qso->logbook(%{$arguments}) },
            'invalid log identity rejected'
        );
    }
    for my $pair ([id => 'bad id'], [operator => 'IU0?']) {
        my %arguments = (id => 'invalid-id', operator => 'IU0ABC', fields => \%fields);
        $arguments{$pair->[0]} = $pair->[1];
        throws(
            'QSO_E_ARGUMENT',
            sub {
                $log->record(%arguments);
            },
            'invalid record attribution rejected'
        );
    }
    throws(
        'QSO_E_ARGUMENT',
        sub { $log->verify(checkpoint => []) },
        'checkpoint must be structured'
    );
    throws(
        'QSO_E_ARGUMENT',
        sub { $log->verify(checkpoint => {%{$anchored}, hash => 'invalid'}) },
        'checkpoint hash syntax checked'
    );
    throws(
        'QSO_E_INTEGRITY',
        sub { $log->verify(checkpoint => {%{$anchored}, log_id => 'another'}) },
        'checkpoint cannot refer to a different log identity'
    );
    throws(
        'QSO_E_ARGUMENT',
        sub {
            $log->record(
                id       => 'foreign',
                operator => 'IU0ABC',
                fields   => {%fields, STATION_CALLSIGN => 'F1ABC'}
            );
        },
        'foreign contact cannot be filed under local station identity'
    );
    my %without_frequency = %fields;
    delete $without_frequency{FREQ};
    throws(
        'QSO_E_ARGUMENT',
        sub {
            $log->record(id => 'no-frequency', operator => 'IU0ABC', fields => \%without_frequency);
        },
        'station record needs band or frequency'
    );
    throws(
        'QSO_E_ARGUMENT',
        sub {
            $log->record(id => 'bad-context', operator => 'IU0ABC', fields => \%fields, adif => []);
        },
        'metadata cannot be an arbitrary reference'
    );
    throws(
        'QSO_E_SEQUENCE',
        sub {
            $log->correct(
                id       => 'orphan',
                corrects => 'missing',
                operator => 'IU0ABC',
                reason   => 'orphan',
                fields   => \%fields
            );
        },
        'correction cannot create an orphan'
    );
    throws(
        'QSO_E_ARGUMENT',
        sub {
            $log->record_session(
                id             => 'wrong-type',
                operator       => 'IU0ABC',
                session        => {},
                time_origin_ms => 0
            );
        },
        'only a real session can supply session evidence'
    );
    my $empty = $qso->session(station => 'IU0ABC');
    $empty->finish;
    throws(
        'QSO_E_SEQUENCE',
        sub {
            $log->record_session(
                id             => 'empty',
                operator       => 'IU0ABC',
                session        => $empty,
                time_origin_ms => 0
            );
        },
        'an empty session cannot produce a phantom QSO'
    );
    my $foreign = $qso->session(station => 'F1ABC');
    $foreign->receive('F1ABC DE DL1ABC RST 579 KN', id => 'rx1', at_ms => 0, duration_ms => 1);
    $foreign->finish;
    throws(
        'QSO_E_ARGUMENT',
        sub {
            $log->record_session(
                id             => 'foreign-session',
                operator       => 'IU0ABC',
                session        => $foreign,
                time_origin_ms => 0
            );
        },
        'session station must match journal identity'
    );
    my $operator_session = $qso->session(station => 'IU0ABC');
    completed($operator_session);
    $operator_session->select_peer(callsign => 'DL1ABC', evidence_id => 'e2');
    $operator_session->finish;
    my $operator_entry = $log->record_session(
        id             => 'operator-record',
        operator       => 'IU0ABC',
        session        => $operator_session,
        time_origin_ms => 1794052800000,
        fields         => {BAND => '20m'}
    );
    ok(grep({ $_->{operator} } @{$operator_entry->{data}{evidence}{snapshot}{history}}),
        'operator actions are retained alongside observed events');
    my $before_sync = $log->verify;
    {
        no warnings 'redefine';
        local *IO::Handle::sync = sub { return 0 };
        throws(
            'QSO_E_IO',
            sub {
                $log->record(id => 'sync-uncertain', operator => 'IU0ABC', fields => \%fields);
            },
            'sync failure reports an uncertain commit instead of success'
        );
    }
    is(
        $log->verify->{sequence},
        $before_sync->{sequence} + 1,
        'verification discovers a complete record after an uncertain sync'
    );
    throws(
        'QSO_E_DUPLICATE',
        sub {
            $log->record(id => 'sync-uncertain', operator => 'IU0ABC', fields => \%fields);
        },
        'blind retry cannot duplicate an uncertain committed record'
    );
    done_testing;
};

subtest 'Extension conflicts and independently anchored history' => sub {
    my $conflict = $qso->logbook(
        path    => File::Spec->catfile($dir, 'conflict.jsonl'),
        station => 'IU0ABC',
        log_id  => 'conflicts',
        create  => 1
    );
    for my $type ('N', 'S') {
        $conflict->record(
            id       => "type-$type",
            operator => 'IU0ABC',
            fields   => {%fields, APP_OTHER_VALUE => '3'},
            adif     => {types                    => {APP_OTHER_VALUE => $type}}
        );
    }
    throws(
        'QSO_E_ADIF',
        sub { $conflict->export_adif },
        'conflicting application types never silently collapse'
    );
    my $declarations = $qso->logbook(
        path    => File::Spec->catfile($dir, 'declarations.jsonl'),
        station => 'IU0ABC',
        log_id  => 'declarations',
        create  => 1
    );
    for my $type ('N', 'S') {
        $declarations->record(
            id       => "type-$type",
            operator => 'IU0ABC',
            fields   => {%fields, CUSTOM => '3'},
            adif     => {header => {USERDEF1 => 'CUSTOM'}, types => {USERDEF1 => $type}}
        );
    }
    throws(
        'QSO_E_ADIF',
        sub { $declarations->export_adif },
        'conflicting USERDEF declarations remain explicit'
    );
    my $rewrite_path = File::Spec->catfile($dir, 'rewrite.jsonl');
    my $original =
        $qso->logbook(path => $rewrite_path, station => 'IU0ABC', log_id => 'rewrite', create => 1);
    $original->record(id => 'q1', operator => 'IU0ABC', fields => \%fields);
    my $trusted   = $original->verify;
    my $rewritten = $original->records;
    $rewritten->[1]{data}{fields}{FREQ} = '14.099';
    my $previous = '0' x 64;
    my $bytes    = '';

    for my $entry (@{$rewritten}) {
        delete $entry->{hash};
        $entry->{previous_hash} = $previous;
        $entry->{hash}          = sha256_hex("ham-qso-logbook-1\0" . $json->encode($entry));
        $previous               = $entry->{hash};
        $bytes .= $json->encode($entry) . "\n";
    }
    open my $rewrite, '>:raw', $rewrite_path or die $!;
    print {$rewrite} $bytes or die $!;
    close $rewrite          or die $!;
    my $new_reader = $qso->logbook(path => $rewrite_path, station => 'IU0ABC');
    ok($new_reader->verify,
        'a complete rehash is self-consistent: hashes alone do not authenticate');
    throws(
        'QSO_E_INTEGRITY',
        sub { $new_reader->verify(checkpoint => $trusted) },
        'independently saved checkpoint detects complete malicious rewrite'
    );
    for my $invalid ('', "{}\n", "{ \"sequence\": 1 }\n", "[]\n") {
        my $invalid_path = File::Spec->catfile($dir, 'invalid-journal.jsonl');
        open my $fh, '>:raw', $invalid_path or die $!;
        print {$fh} $invalid or die $!;
        close $fh            or die $!;
        throws(
            'QSO_E_INTEGRITY',
            sub { $qso->logbook(path => $invalid_path, station => 'IU0ABC') },
            'invalid or noncanonical journal is rejected'
        );
    }
    done_testing;
};

done_testing;
