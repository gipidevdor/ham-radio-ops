use strict;
use warnings;
use Test::More;
use File::Temp qw(tempdir);
use File::Spec;
use Cwd qw(getcwd);
my $root = File::Spec->rel2abs('.');
my @files =
    ('README.md', sort(glob('docs/*.md')), 'lib/Ham/QSO.pm', sort(glob('lib/Ham/QSO/*.pm')));
my $temporary = tempdir(CLEANUP => 1);
my $number    = 0;

for my $file (@files) {
    open my $input, '<', $file or die $!;
    my $text = do { local $/; <$input> };
    close $input or die $!;
    if ($file =~ /\.pm\z/x) {
        while ($text =~ /^sub\s+([a-z][a-z0-9_]*)/gmx) {
            my $method = $1;
            like($text, qr/^=head2\s+\Q$method\E\s*$/mx, "$file documents $method");
        }
    }
    my @snippets = $text =~ /```perl\s*\n(.*?)```/gsx;
    if ($file =~ /\.pm\z/x && $text =~ /^=head1\s+SYNOPSIS\s*\n(.*?)(?=^=head1)/msx) {
        my $synopsis = $1;
        $synopsis =~ s/^    //gmx;
        push @snippets, $synopsis;
    }
    for my $snippet (@snippets) {
        if ($file =~ /Adapter\.pm\z/x) {
            my $available = eval { require Ham::CW; 1 };
            if (!$available) { note('Adapter synopsis requires optional Ham::CW'); next }
        }
        my $path = File::Spec->catfile($temporary, 'snippet-' . ++$number . '.pl');
        open my $out, '>', $path or die $!;
        print {$out} $snippet or die $!;
        close $out            or die $!;
        my $cwd = getcwd();
        chdir $temporary or die $!;
        system $^X, "-I$root/lib", '-Mwarnings=FATAL,all', $path;
        my $status = $?;
        chdir $cwd or die $!;
        is($status, 0, "$file standalone Perl example");
    }
}
done_testing;
