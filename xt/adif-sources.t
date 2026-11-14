use 5.020;
use strict;
use warnings;
use Test::More;
use Digest::SHA qw(sha256_hex);
use JSON::PP;
use ExtUtils::Manifest qw(maniread);

sub read_bytes {
    my ($path) = @_;
    open my $fh, '<:raw', $path or die $!;
    my $bytes = do { local $/ = undef; <$fh> };
    close $fh or die $!;
    return $bytes;
}

my $sources  = JSON::PP->new->decode(read_bytes('docs/adif-sources.json'));
my $manifest = maniread();
for my $schema (@{$sources->{bundled_schemas}}) {
    my $bytes = read_bytes($schema->{path});
    ok(exists $manifest->{$schema->{path}}, 'official schema included in package');
    is(sha256_hex($bytes), $schema->{sha256}, 'official schema bytes match reviewed source');
    is($schema->{license}, 'CC0-1.0',
        'bundled external schema has an explicit redistribution grant');
    like(
        $bytes,
        qr/This[ ]schema[ ]by[ ]Graham[ ]Smith[ ]is[ ]marked[ ]CC0[ ]1\.0[ ]Universal/x,
        'embedded creator and CC0 dedication retained'
    );
    ok(!$schema->{modified}, 'schema identified as unmodified external material');
}
ok(!$sources->{specification}{bundled}, 'ADIF specification prose is not bundled or relicensed');
like(
    read_bytes('NOTICE'),
    qr/ADIF[ ]interchange[ ]and[ ]ADX[ ]schemas/x,
    'package notices distinguish schema terms'
);
done_testing;
