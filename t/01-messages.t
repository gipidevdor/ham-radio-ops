use 5.020;
use strict;
use warnings FATAL => 'all';
use Test::More;
use lib 't/lib';
use QSOTest qw(throws event completed);
use Ham::QSO;
my $qso = Ham::QSO->new;

for my $case (
    ['CQ CQ CQ DE IU0ABC IU0ABC K',      'cq',       'IU0ABC', undef,    'K'],
    ['QRL? DE IU0ABC',                   'probe',    'IU0ABC', undef,    'NONE'],
    ['IU0ABC DE DL1ABC K N',             'directed', 'DL1ABC', 'IU0ABC', 'KN'],
    ['IU0ABC DE DL1ABC R RST 579 KN',    'directed', 'DL1ABC', 'IU0ABC', 'KN'],
    ['IU0ABC DE DL1ABC QRX <AR>',        'directed', 'DL1ABC', 'IU0ABC', '<AR>'],
    ['IU0ABC DE DL1ABC 73 <SK>',         'close',    'DL1ABC', 'IU0ABC', '<SK>'],
    ['IU0ABC DE DL1ABC CL',              'close',    'DL1ABC', 'IU0ABC', 'CL'],
    ['  iu0abc\nde dl1abc rst 579 kn  ', 'directed', 'DL1ABC', 'IU0ABC', 'KN'],
    )
{
    $case->[0] =~ s/\\n/\n/gx;
    my $result = $qso->parse($case->[0]);
    is($result->status, 'supported', $case->[0]);
    is_deeply(
        [@{$result->message}{qw(kind from to ending)}],
        [@{$case}[1 .. 4]],
        'independent semantic vector'
    );
    is($result->text, $case->[0], 'original input preserved');
}
for my $report (0 .. 999) {
    my $rst    = sprintf '%03d', $report;
    my $status = $qso->parse("IU0ABC DE DL1ABC RST $rst KN")->status;
    my ($readability, $strength, $tone) =
        (int($report / 100), int($report / 10) % 10, $report % 10);
    my $valid = $readability >= 1 && $readability <= 5 && $strength >= 1 && $tone >= 1;
    is($status, $valid ? 'supported' : 'violation', "independent numeric RST vector $rst");
}
for my $partial (
    'IU0? DE DL1ABC KN',
    'IU0ABC DE DL1A? KN',
    'IU0ABC DE DL1ABC RST 5?9 KN',
    'IU0ABC DE ?L1ABC KN',
    'DL? DE IU0ABC KN',
    'IU0ABC DE DL? KN',
    'CQ DE DL? K',
    'QRL? DE DL?',
    'CQ DE IU0ABC DL? K'
    )
{
    is($qso->parse($partial)->status, 'ambiguous', 'partial data is not repaired');
    ok(!defined $qso->parse($partial)->message, 'ambiguous data has no semantic proof');
}
is($qso->parse('IU0ABC DE DL1ABC RST 5?9 KN')->diagnostics->[0]{rule},
    'QSO-R004', 'uncertain report is traced to the report rule, not an identity rule');
for my $unicode ("IU0ABC DE \x{0131}U0XYZ KN", "IU0ABC DE DL1\x{00DF}A KN") {
    my $result = $qso->parse($unicode);
    is($result->status, 'unsupported', 'Unicode case folding cannot invent an ASCII identity');
    ok(!defined $result->message, 'non-ASCII identities prove nothing');
}
for my $text (
    '599',         'R', 'IU0ABC DE DL1ABC NAME MARIO KN',
    'CQ DL1ABC K', 'QSL VIA BURO',
    'IU0ABC DE DL1ABC RST 5NN KN',
    'IU0ABC DE DL1ABC RST 579 MORE KN'
    )
{
    isnt($qso->parse($text)->status, 'supported', 'unsupported input is not overinterpreted');
}
is($qso->parse('CQ DE IU0ABC IU0XYZ K')->status, 'violation', 'conflicting repeated identity');
is($qso->parse('IU0ABC DE DL1ABC 73 KN')->message->{kind}, 'directed', '73 is not contact closure');
ok(!$qso->parse('IU0ABC DE DL1ABC TU 73 KN')->message->{ack},
    'pleasantries do not acknowledge a report');
my $rtty = Ham::QSO->new(profile => 'it-rtty');
is($rtty->parse('CQ DE IU0ABC IU0ABC CQ')->status, 'supported', 'RTTY CQ suffix');
is($rtty->parse('IU0ABC DE DL1ABC 73 <SK>')->status,
    'unsupported', 'literal CW prosign rejected in RTTY');
for my $profile (qw(it-cw it-rtty iaru-cw iaru-rtty)) {
    my $q = Ham::QSO->new(profile => $profile);
    for my $fields (
        {kind => 'cq'},
        {kind => 'probe'},
        {to   => 'DL1ABC'},
        {to   => 'DL1ABC', report  => '579', ack => 1},
        {to   => 'DL1ABC', request => 'AGN'},
        {to   => 'DL1ABC', request => 'QRX'},
        {to   => 'DL1ABC', request => 'QRS'},
        {to   => 'DL1ABC', ending  => 'CL'}
        )
    {
        is($q->parse($q->compose(from => 'IU0ABC', %{$fields}))->status,
            'supported', "$profile composition");
    }
}
for my $bad (
    {from => 'IU0?'},
    {from => 'IU0ABC', to   => 'IU0ABC'},
    {from => 'IU0ABC', to   => 'DL1ABC', report => '5999'},
    {from => 'IU0ABC', kind => 'CQ'},
    {from => 'IU0ABC', kind => 'cq',     to      => 'DL1ABC'},
    {from => 'IU0ABC', kind => 'cq',     report  => '599'},
    {from => 'IU0ABC', to   => 'DL1ABC', request => 'QSY'},
    {from => 'IU0ABC', to   => 'DL1ABC', ending  => 'ZZ'},
    {from => 'IU0ABC', to   => 'DL1ABC', ack     => 2}
    )
{
    throws('QSO_E_ARGUMENT', sub { $qso->compose(%{$bad}) }, 'invalid composition');
}
throws('QSO_E_PROFILE', sub { Ham::QSO->new(profile => 'invented') }, 'unknown profile');
throws(
    'QSO_E_ARGUMENT',
    sub { Ham::QSO->new(profile => 'it-cw', profile => 'it-rtty') },
    'duplicate option'
);
throws('QSO_E_ARGUMENT', sub { $qso->parse([]) },         'reference text');
throws('QSO_E_RESOURCE', sub { $qso->parse('X' x 8193) }, 'bounded text');
done_testing;
