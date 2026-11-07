use strict;
use warnings;
use Test::More;
use Test::Kwalitee qw(kwalitee_ok);
use Ham::QSO       ();
if (!-f 'META.yml') {
    chdir "Ham-QSO-$Ham::QSO::VERSION" or die "Run make distmeta before author checks: $!";
}
kwalitee_ok();
done_testing;
