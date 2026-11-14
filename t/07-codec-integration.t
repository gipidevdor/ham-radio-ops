use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use File::Temp qw(tempdir);
use File::Spec;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO;
my $directory = tempdir(CLEANUP => 1);

for my $mode (qw(CW RTTY)) {
    subtest "real Ham::$mode integration" => sub {
        my $available = eval { $mode eq 'CW' ? require Ham::CW : require Ham::RTTY; 1 };
        plan skip_all => "Optional Ham::$mode is not installed" unless $available;
        my $qso = Ham::QSO->new(profile => $mode eq 'CW' ? 'it-cw' : 'it-rtty');
        my %settings =
            $mode eq 'CW'
            ? (wpm => 40, frequency => 700)
            : (baud => 100, mark => 2125, shift => 170);
        my $adapter  = $qso->adapter(options => {%settings, sample_rate => 8000});
        my $session  = $qso->session(station => 'IU0ABC');
        my $proposal = $session->prepare(kind => 'cq');
        my $before   = $session->snapshot->as_hash;
        my $symbols  = $adapter->encode($proposal);
        my $analysis = $adapter->decode($symbols);
        is($analysis->status,          'supported', 'native symbolic round trip');
        is($analysis->message->{from}, 'IU0ABC',    'identity retained');
        my $closing = $qso->compose(
            from   => 'IU0ABC',
            to     => 'DL1ABC',
            ending => $mode eq 'CW' ? '<SK>' : 'SK'
        );
        my $closed = $adapter->decode($adapter->encode($closing));
        is($closed->message->{kind}, 'close',
            'actual codec preserves mode-specific contact ending');

        if ($mode eq 'CW') {
            my $wait =
                $qso->compose(from => 'IU0ABC', to => 'DL1ABC', request => 'QRX', ending => '<AR>');
            is($adapter->decode($adapter->encode($wait))->message->{ending},
                '<AR>', 'actual CW prosign survives symbolic decoding');
        }
        my $wav = $adapter->wav_bytes($proposal);
        is(substr($wav, 0, 4), 'RIFF', 'real WAV bytes');
        my $path = File::Spec->catfile($directory, "$mode.wav");
        $adapter->write_wav($proposal, $path);
        my $reception = $adapter->read_wav($path, %settings);
        is($reception->text, $proposal->{text}, 'actual WAV detector/decoder text');
        is_deeply($session->snapshot->as_hash,
            $before, 'encoding and audio generation never record TX');
        my $class = "Ham::${mode}::Result";
        my $clean = $class->new(text => 'IU0ABC DE DL1ABC RST 579 KN', complete => 1);
        $adapter->receive_result($session, $clean, id => 'rx1', at_ms => 0, duration_ms => 1000);
        is($session->snapshot->facts->{received_report}{value},
            '579', 'explicit real Result ingestion');
        my $warned = $class->new(
            text     => 'IU0ABC DE DL1ABC RST 599 KN',
            complete => 1,
            warnings => [{code => 'TEST_UNCERTAIN', message => 'Known damaged input'}]
        );
        $adapter->receive_result(
            $session, $warned,
            id          => 'rx2',
            at_ms       => 1000,
            duration_ms => 1000
        );
        is($session->snapshot->facts->{received_report}{value},
            '579', 'codec warning prevents new proof');
        my $preview = $class->new(text => 'IU0ABC DE DL1ABC RST 559 KN');
        $adapter->receive_result(
            $session, $preview,
            id          => 'rx3',
            at_ms       => 2000,
            duration_ms => 1000
        );
        is($session->snapshot->facts->{received_report}{value},
            '579', 'provisional decode proves nothing');
        my $module   = "Ham::$mode";
        my $existing = $qso->adapter(codec => $module->new(%settings));
        ok($existing->encode('CQ DE IU0ABC K'), 'existing real codec object accepted');
        throws(
            'QSO_E_ARGUMENT',
            sub { $qso->adapter(codec => {}, options => {}) },
            'exclusive adapter configuration'
        );
        throws('QSO_E_ARGUMENT', sub { $qso->adapter(codec => {}) }, 'codec class checked');
        throws(
            'QSO_E_ARGUMENT',
            sub { $qso->adapter(options => {backend => 'pdl'}) },
            'no PDL selection'
        );
        throws('QSO_E_ARGUMENT', sub { $qso->adapter(options => []) }, 'options shape checked');
        throws(
            'QSO_E_ARGUMENT',
            sub { $adapter->encode('unknown') },
            'no encoding unsupported semantics'
        );
        throws(
            'QSO_E_PROFILE',
            sub { $adapter->encode({profile => 'wrong', text => 'CQ DE IU0ABC K'}) },
            'profile mismatch'
        );
        throws(
            'QSO_E_ARGUMENT',
            sub { $adapter->receive_result({}, $clean) },
            'session class checked'
        );
        my $wrong = Ham::QSO->new(profile => 'iaru-cw')->session(station => 'IU0ABC');
        throws(
            'QSO_E_PROFILE',
            sub { $adapter->receive_result($wrong, $clean) },
            'session profile checked'
        );
    };
}
ok(!grep(m{\APDL(?:/|\.pm)}x, keys %INC), 'PDL never loaded');
done_testing;
