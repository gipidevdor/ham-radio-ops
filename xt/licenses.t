use 5.020;
use strict;
use warnings;
use Test::More;
use Digest::SHA        qw(sha256_hex);
use ExtUtils::Manifest qw(maniread);
use File::Basename     qw(dirname);
use File::Copy         qw(copy);
use File::Path         qw(make_path);
use File::Spec;
use File::Temp qw(tempdir);
use IPC::Open3 qw(open3);
use JSON::PP;
use Symbol qw(gensym);

sub read_bytes {
    my ($path) = @_;
    open my $input, '<:raw', $path or die "Cannot read $path: $!";
    my $bytes = do { local $/ = undef; <$input> };
    close $input or die $!;
    return $bytes;
}

sub write_bytes {
    my ($path, $bytes) = @_;
    make_path(dirname($path));
    open my $output, '>:raw', $path or die $!;
    print {$output} $bytes or die $!;
    close $output          or die $!;
    return;
}

my $checker = File::Spec->rel2abs('maint/check-licenses.pl');

sub run_check {
    my ($directory) = @_;
    my $error       = gensym();
    my $pid         = open3(undef, my $stdout, $error, $^X, $checker, $directory);
    my $output      = do { local $/ = undef; <$stdout> };
    my $errors      = do { local $/ = undef; <$error> };
    close $stdout or die $!;
    close $error  or die $!;
    waitpid $pid, 0;
    return ($?, ($output // '') . ($errors // ''));
}

my ($status, $output) = run_check('.');
is($status, 0, 'release inventory and original/external rights records pass offline')
    or diag($output);
like($output, qr/Licensing checks passed/, 'standalone checker reports its reviewed scope');

my $temporary = tempdir(CLEANUP => 1);
my $record    = JSON::PP->new->decode(read_bytes('docs/license-provenance.json'));
my %files     = %{maniread()};
$files{$_->{path}} = 1 for @{$record->{reused_project_material}{files}};
$files{$_}         = 1 for glob '.github/workflows/*.yml';
$files{$_}         = 1 for glob '.github/workflows/*.yaml';
$files{$_}         = 1 for glob '.github/scripts/*.sh';
for my $path (sort keys %files) {
    next unless -f $path;
    make_path(dirname("$temporary/$path"));
    copy($path, "$temporary/$path") or die $!;
}
($status, $output) = run_check($temporary);
is($status, 0, 'copied source distribution passes independently') or diag($output);

sub rejected_change {
    my ($label, $path, $replacement, $diagnostic) = @_;
    my $target   = "$temporary/$path";
    my $original = -f $target ? read_bytes($target) : undef;
    write_bytes($target, $replacement);
    my ($result, $message) = run_check($temporary);
    isnt($result, 0, "$label blocks distribution");
    like($message, $diagnostic, "$label explains the rights review needed");
    if (defined $original) { write_bytes($target, $original) }
    else                   { unlink $target or die $! }
    return;
}

rejected_change(
    'modified project license',
    'LICENSE',
    read_bytes('LICENSE') . "\nmodified\n",
    qr/LICENSE checksum changed/
);
rejected_change(
    'modified shared theme',
    'maint/site.css',
    "/* replaced theme notice */\n",
    qr{maint/site.css checksum changed}
);
rejected_change(
    'modified external license text',
    'LICENSES/CC0-1.0.txt',
    "CC0 summary\n",
    qr{LICENSES/CC0-1.0.txt checksum changed}
);
rejected_change(
    'missing release notice',
    'MANIFEST',
    read_bytes('MANIFEST') =~ s/^NOTICE\n//mr,
    qr/NOTICE missing from release inventory/
);
rejected_change(
    'floating action reference',
    '.github/workflows/license-fixture.yml',
    "steps:\n  - uses: actions/checkout\@main\n",
    qr/needs a reviewed immutable reference/
);
rejected_change(
    'unreviewed pinned action',
    '.github/workflows/license-fixture.yml',
    'steps:' . "\n  - uses: example/unreviewed\@" . ('a' x 40) . "\n",
    qr/has no license record/
);
rejected_change(
    'changed scanner version',
    '.github/workflows/license-fixture.yml',
    "run: go install github.com/zricethezav/gitleaks/v8\@v0.0.0\n",
    qr/Go installer .* has no matching license record/
);
rejected_change(
    'changed Python analyzer version',
    '.github/workflows/license-fixture.yml',
    "run: pip install 'zizmor==0.0.0'\n",
    qr/Python installer .* has no matching license record/
);

rejected_change(
    'floating action in flow YAML',
    '.github/workflows/license-fixture.yaml',
    "steps: [{\"uses\": 'actions/checkout\@main'}]\n",
    qr/needs a reviewed immutable reference/
);
rejected_change(
    'missing IARU attribution link',
    'NOTICE',
    read_bytes('NOTICE') =~ s{https://creativecommons.org/licenses/by-sa/4.0/legalcode.en}{}r,
    qr/IARU licence link missing/
);
my $invalid_provenance = JSON::PP->new->decode(read_bytes('docs/license-provenance.json'));
$invalid_provenance->{reused_project_material}{reference_revision} = 'main';
rejected_change(
    'floating project source provenance',
    'docs/license-provenance.json',
    JSON::PP->new->encode($invalid_provenance),
    qr/project source reference must be an immutable revision/
);

my $schema_path = 'lib/Ham/QSO/_Internal/license-fixture.xsd';
my $schema      = "<!-- Original synthetic licence-gate fixture; CC0-1.0 -->\n<schema/>\n";
write_bytes("$temporary/$schema_path", $schema);
my $manifest = read_bytes("$temporary/MANIFEST");
write_bytes("$temporary/MANIFEST", $manifest . "$schema_path\n");
($status, $output) = run_check($temporary);
isnt($status, 0, 'unregistered bundled schema blocks distribution');
like($output, qr/needs reviewed bundled-material provenance/,
    'unregistered material is identified');

my $fixture_record = JSON::PP->new->decode(read_bytes("$temporary/docs/license-provenance.json"));
push @{$fixture_record->{bundled_material}},
    {
    path         => $schema_path,
    source       => 'https://example.invalid/synthetic-fixture.xsd',
    author       => 'Original synthetic test fixture',
    license      => 'CC0-1.0',
    license_file => 'LICENSES/CC0-1.0.txt',
    modified     => JSON::PP::false,
    sha256       => sha256_hex($schema)
    };
write_bytes("$temporary/docs/license-provenance.json", JSON::PP->new->encode($fixture_record));
($status, $output) = run_check($temporary);
is($status, 0, 'declared fixture with creator, source, exact bytes and full license passes')
    or diag($output);
rejected_change(
    'altered reviewed schema',
    $schema_path,
    "$schema<!-- altered -->\n",
    qr/checksum changed/
);
$fixture_record->{bundled_material}[-1]{license_file} = 'LICENSE';
rejected_change(
    'external material labelled with project license text', 'docs/license-provenance.json',
    JSON::PP->new->encode($fixture_record),                 qr/needs its reviewed license text/
);

done_testing;
