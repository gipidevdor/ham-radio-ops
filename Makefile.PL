use 5.020;
use strict;
use warnings;
use ExtUtils::MakeMaker 7.22;
my %provides;
for my $module (
    qw(Ham::QSO Ham::QSO::Profile Ham::QSO::Message Ham::QSO::Session
    Ham::QSO::Adapter Ham::QSO::Result Ham::QSO::Error Ham::QSO::ADIF Ham::QSO::Logbook)
    )
{
    my $file = "lib/$module.pm";
    $file =~ s{::}{/}gx;
    $provides{$module} = {file => $file, version => MM->parse_version($file)};
}
WriteMakefile(
    NAME             => 'Ham::QSO',
    VERSION_FROM     => 'lib/Ham/QSO.pm',
    ABSTRACT_FROM    => 'lib/Ham/QSO.pm',
    AUTHOR           => 'Giacomo Picchiarelli',
    LICENSE          => 'artistic_2',
    MIN_PERL_VERSION => '5.020',
    EXE_FILES        => ['bin/ham-qso'],
    PM               => {
        map { $_ => '$(INST_LIB)/' . substr($_, 4) }
            (glob('lib/Ham/*.pm'), glob('lib/Ham/QSO/*.pm'), glob('lib/Ham/QSO/_Internal/*'))
    },
    CONFIGURE_REQUIRES => {'ExtUtils::MakeMaker' => '7.22'},
    BUILD_REQUIRES     => {'ExtUtils::MakeMaker' => '7.22'},
    PREREQ_PM          => {
        Carp             => 0,
        Exporter         => 0,
        'Scalar::Util'   => 0,
        Storable         => '3.41',
        'JSON::PP'       => 0,
        'Getopt::Long'   => 0,
        'File::Basename' => 0,
        'File::Temp'     => 0,
        'File::Spec'     => 0,
        Cwd              => '3.65',
        'Digest::SHA'    => '5.96',
        'Time::HiRes'    => 0,
        POSIX            => 0,
        Encode           => '3.12',
        Fcntl            => 0,
        'IO::Handle'     => 0
    },
    TEST_REQUIRES => {
        'Test::More'       => '0.98',
        'File::Spec'       => 0,
        Cwd                => '3.65',
        'File::Temp'       => 0,
        'IPC::Open3'       => 0,
        Symbol             => 0,
        Config             => 0,
        'Text::ParseWords' => 0,
        'Time::Local'      => 0,
        'Digest::SHA'      => '5.96'
    },
    dist =>
        {TAR => '$(PERLRUN) maint/archive.pl', TARFLAGS => q{ }, COMPRESS => 'gzip -n -f --best'},
    META_MERGE => {
        provides       => \%provides,
        dynamic_config => 0,
        'meta-spec'    => {version => 2},
        keywords       => [qw(amateur-radio qso cw rtty session semantics italy)],
        resources      => {
            repository => {
                type => 'git',
                url  => 'https://github.com/gipidevdor/ham-radio-ops.git',
                web  => 'https://github.com/gipidevdor/ham-radio-ops'
            },
            bugtracker => {web => 'https://github.com/gipidevdor/ham-radio-ops/issues'},
            homepage   => 'https://github.com/gipidevdor/ham-radio-ops'
        },
        no_index => {
            directory => [qw(xt examples maint lib/Ham/QSO/_Internal)],
            namespace => ['Ham::QSO::_Internal']
        },
        prereqs => {
            runtime => {
                suggests => {
                    'Ham::CW'     => '0.001',
                    'Ham::RTTY'   => '0.001',
                    'XML::Parser' => '2.59',
                    'XML::LibXML' => '2.0213'
                }
            },
            develop => {
                requires => {
                    'Perl::Tidy'              => '20260826',
                    'Perl::Critic'            => 0,
                    'Perl::MinimumVersion'    => '1.44',
                    'CPAN::Audit'             => '20261013.002',
                    'Devel::Cover'            => 0,
                    'Test::Pod'               => '1.48',
                    'Test::CPAN::Meta'        => 0,
                    'Test::CPAN::Changes'     => 0,
                    'CPAN::Meta'              => 0,
                    'ExtUtils::Manifest'      => 0,
                    'Archive::Tar'            => '3.10',
                    'Module::CPANTS::Analyse' => '1.03',
                    'Test::Kwalitee'          => 0,
                    'Pod::Simple'             => '3.48',
                    'Markdown::Perl'          => '1.14',
                    'HTML::Tree'              => '5.07',
                    'XML::Parser'             => '2.59',
                    'XML::LibXML'             => '2.0213',
                    URI                       => '5.40',
                    PPI                       => '1.291'
                }
            }
        }
    }
);
