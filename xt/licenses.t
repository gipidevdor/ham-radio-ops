use 5.020;
use strict;
use warnings;
use Test::More;
use Digest::SHA        qw(sha256_hex);
use ExtUtils::Manifest qw(maniread);
use JSON::PP;

sub read_bytes {
    my ($path) = @_;
    open my $input, '<:raw', $path or die "Cannot read $path: $!";
    my $bytes = do { local $/; <$input> };
    close $input or die $!;
    return $bytes;
}

my $manifest     = maniread();
my $record       = JSON::PP->new->decode(read_bytes('docs/license-provenance.json'));
my $license_hash = 'bae466ac8d7100c304fe76632ccc627203a3897d3f7166f3cce00fb9df8c2074';
is(sha256_hex(read_bytes('LICENSE')),
    $license_hash, 'complete Artistic 2.0 text remains the reviewed verbatim upstream copy');
is($record->{license_file}{sha256}, $license_hash, 'provenance names that exact license text');
is($record->{project_license},
    'Artistic-2.0', 'project license remains separate from external terms');
for my $path (qw(LICENSE NOTICE docs/licensing.md docs/license-provenance.json xt/licenses.t)) {
    ok(exists($manifest->{$path}) && -s $path, "$path is included in the release inventory");
}

my $upstream = $record->{reused_project_material};
like($upstream->{reference_revision}, qr/\A[0-9a-f]{40}\z/x, 'source reference is immutable');
is($upstream->{license}, 'Artistic-2.0', 'reused project material keeps its upstream license');
my %seen;
for my $file (@{$upstream->{files}}) {
    my $path = $file->{path};
    ok(!$seen{$path}++, "$path has one provenance record");
    like($file->{reference_sha256}, qr/\A[0-9a-f]{64}\z/x, "$path has a reference-content hash");
    if (!-f $path) {
        ok(!exists $manifest->{$path},
            "$path is repository-only material omitted from this archive");
        next;
    }
    if ($file->{reuse} eq 'verbatim') {
        is(
            sha256_hex(read_bytes($path)),
            $file->{reference_sha256},
            "$path preserves the recorded upstream bytes and notices"
        );
    }
}

my @media = grep { /\.(?:pdf|wav|mp3|ogg|flac|png|jpe?g|gif|svg|ttf|otf|woff2?|mp4|webm)\z/ix }
    keys %{$manifest};
is_deeply(\@media, [],
    'current distribution policy excludes standards documents, received audio, images and fonts');
for my $file (@{$record->{original_fixture_files}}) {
    ok(exists($manifest->{$file}) && -s $file,
        "$file has a declared original synthetic provenance");
}
for my $publication (@{$record->{referenced_publications}}) {
    ok(!$publication->{bundled}, "$publication->{title} is referenced, not bundled or relicensed");
    like($publication->{source}, qr{\Ahttps://}x, 'publication source is retained');
}
like(
    read_bytes('NOTICE'),
    qr{https://creativecommons\.org/licenses/by-sa/4\.0/legalcode\.en}x,
    'IARU attribution includes the governing CC BY-SA terms'
);
like(
    read_bytes('maint/site.css'),
    qr/Original[ ]Ham::CW[ ]documentation[ ]theme/x,
    'shared stylesheet retains its original project notice'
);

my %tools;
for my $tool (@{$record->{externally_invoked_tools}}) {
    $tools{"$tool->{repository}\@$tool->{ref}"} = $tool;
    ok(!$tool->{bundled}, "$tool->{repository} is not relicensed as bundled project code");
    like(
        $tool->{license_url},
        qr{\Ahttps://github\.com/\Q$tool->{repository}\E/blob/\Q$tool->{ref}\E/}x,
        "$tool->{repository} has a license link at the recorded revision"
    );
}
for my $workflow (sort glob '.github/workflows/*.yml') {
    my $text = read_bytes($workflow);
    while ($text =~ /uses:\s+([A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+)\@([0-9a-f]{40})/gx) {
        ok(exists $tools{"$1\@$2"}, "$workflow action pin has a reviewed license record");
    }
}
if (-f '.github/scripts/portability.sh') {
    my $script = read_bytes('.github/scripts/portability.sh');
    my ($revision) = $script =~ m{miyagawa/cpanminus/([0-9a-f]{40})/cpanm}x;
    ok(
        defined($revision) && exists $tools{"miyagawa/cpanminus\@$revision"},
        'external cpanminus bootstrap has its own recorded license'
    );
}
done_testing;
