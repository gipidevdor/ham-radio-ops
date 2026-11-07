#!/usr/bin/env perl
use 5.020;
use strict;
use warnings;
use Digest::SHA        qw(sha256_hex);
use ExtUtils::Manifest qw(maniread);
use JSON::PP;

sub checked {
    my ($condition, $message) = @_;
    die "Invalid licence check arguments\n"   unless @_ == 2;
    die "License review required: $message\n" unless $condition;
    return;
}

sub bytes {
    my ($path) = @_;
    open my $input, '<:raw', $path or die "Cannot read $path: $!\n";
    my $data = do { local $/ = undef; <$input> };
    close $input or die "Cannot close $path: $!\n";
    return $data;
}

sub json {
    my ($path) = @_;
    return JSON::PP->new->decode(bytes($path));
}

sub digest_matches {
    my ($path, $digest) = @_;
    checked(scalar(defined($digest) && $digest =~ /\A[0-9a-f]{64}\z/x),
        "$path needs a reviewed SHA-256");
    checked(sha256_hex(bytes($path)) eq $digest, "$path checksum changed");
    return;
}

sub audit_project {
    my ($provenance, $manifest) = @_;
    checked(($provenance->{schema_version} // 0) == 1, 'unsupported provenance schema version');
    for my $field (qw(license_texts bundled_material external_material_inventories)) {
        checked(ref($provenance->{$field}) eq 'ARRAY', "$field must be an explicit inventory");
    }
    for my $path (keys %{$manifest}) {
        checked(scalar($path !~ m{\A/|\\|(?:\A|/)\.\.(?:/|\z)}x), "unsafe release path $path");
        checked(-f $path && !-l $path, "$path is missing or is a symbolic link");
    }
    for my $path (
        qw(LICENSE NOTICE docs/licensing.md docs/license-provenance.json maint/check-licenses.pl xt/licenses.t)
        )
    {
        checked(exists $manifest->{$path} && -s $path, "$path missing from release inventory");
    }
    my $artistic = 'bae466ac8d7100c304fe76632ccc627203a3897d3f7166f3cce00fb9df8c2074';
    digest_matches('LICENSE', $artistic);
    checked($provenance->{license_file}{sha256} eq $artistic, 'project license reference changed');
    checked($provenance->{project_license} eq 'Artistic-2.0', 'project license identity changed');
    my $upstream = $provenance->{reused_project_material};
    checked(
        scalar($upstream->{reference_revision} =~ /\A[0-9a-f]{40}\z/x),
        'project source reference must be an immutable revision'
    );
    checked($upstream->{license} eq 'Artistic-2.0', 'reused project license changed');
    my %reused;

    for my $file (@{$upstream->{files}}) {
        my $path = $file->{path};
        checked(!$reused{$path}++, "$path has duplicate provenance");
        checked(scalar($file->{reuse} =~ /\A(?:verbatim|adapted)\z/x),
            "$path needs a reuse classification");
        checked(scalar($file->{reference_sha256} =~ /\A[0-9a-f]{64}\z/x),
            "$path needs a reference-content hash");
        next                                             if !-f $path && !exists $manifest->{$path};
        digest_matches($path, $file->{reference_sha256}) if $file->{reuse} eq 'verbatim';
    }
    for my $path (@{$provenance->{original_fixture_files}}) {
        checked(exists $manifest->{$path} && -s $path,
            "$path original fixture missing from inventory");
    }
    for my $publication (@{$provenance->{referenced_publications}}) {
        checked(!$publication->{bundled},
            "$publication->{title} requires separate redistribution review");
        checked(scalar($publication->{source} =~ m{\Ahttps://}x), 'publication needs a source URL');
    }
    my $iaru_terms = 'https://creativecommons.org/licenses/by-sa/4.0/legalcode.en';
    checked(index(bytes('NOTICE'), $iaru_terms) >= 0, 'IARU licence link missing from NOTICE');
    checked(scalar(bytes('maint/site.css') =~ /Original[ ]Ham::CW[ ]documentation[ ]theme/x),
        'original theme attribution missing');

    return;
}

sub audit_material {
    my ($provenance, $manifest) = @_;
    my %licenses;
    for my $license (@{$provenance->{license_texts}}) {
        my $path = $license->{path};
        checked(!exists $licenses{$license->{license}}, 'duplicate external license text');
        checked(exists $manifest->{$path}, "$path license text missing from release inventory");
        checked(
            scalar($license->{source} =~ m{\Ahttps://}x),
            "$path license text needs a source URL"
        );
        digest_matches($path, $license->{sha256});
        $licenses{$license->{license}} = $path;
    }
    my @material = @{$provenance->{bundled_material}};
    for my $inventory (@{$provenance->{external_material_inventories}}) {
        my $path = $inventory->{path};
        checked(exists $manifest->{$path},
            "$path external inventory missing from release inventory");
        my $data = json($path);
        checked(
            ref($data->{$inventory->{collection}}) eq 'ARRAY',
            "$path external inventory is malformed"
        );
        push @material, @{$data->{$inventory->{collection}}};
    }
    my %external;
    for my $file (@material) {
        my $path = $file->{path};
        checked(!$external{$path}++, "$path has duplicate external provenance");
        checked(exists $manifest->{$path},
            "$path external material missing from release inventory");
        checked($file->{source} =~ m{\Ahttps://}x && length($file->{author} // ''),
            "$path needs its source and creator");
        checked(
            exists $licenses{$file->{license}}
                && ($file->{license_file} // '') eq $licenses{$file->{license}},
            "$path needs its reviewed license text"
        );
        checked(exists($file->{modified}) && !$file->{modified},
            "$path modified external material requires a new rights review");
        digest_matches($path, $file->{sha256});
    }
    my $documents = qr/(?:pdf|xsd|xml|html?|docx?|zip)/ix;
    my $media     = qr/(?:wav|mp3|ogg|flac|png|jpe?g|gif|svg|mp4|webm)/ix;
    my $fonts     = qr/(?:ttf|otf|woff2?)/ix;
    for my $path (sort keys %{$manifest}) {
        next unless $path =~ /\.(?:$documents|$media|$fonts)\z/ix;
        checked(exists $external{$path}, "$path needs reviewed bundled-material provenance");
    }

    return scalar @material;
}

sub audit_tools {
    my ($provenance) = @_;
    my (%tools, %go, %python);
    for my $tool (@{$provenance->{externally_invoked_tools}}) {
        my ($repo, $ref) = @{$tool}{qw(repository ref)};
        checked(!exists $tools{"$repo\@$ref"}, "$repo has duplicate tool provenance");
        checked(!$tool->{bundled}, "$repo bundled tool requires separate redistribution review");
        my $revision = $tool->{license_revision} // $ref;
        checked(
            scalar(
                       $revision =~ /\A[0-9a-f]{40}\z/x
                    && $tool->{license_url} =~
                    m{\Ahttps://github\.com/\Q$repo\E/blob/\Q$revision\E/}x
            ),
            "$repo needs an immutable upstream license link"
        );
        $tools{"$repo\@$ref"}           = $tool;
        $go{"$tool->{go_module}\@$ref"} = 1 if exists $tool->{go_module};
        $python{"$tool->{python_distribution}==" . ($ref =~ s/\Av//rx)} = 1
            if exists $tool->{python_distribution};
    }
    my @workflow_files = (glob('.github/workflows/*.yml'), glob('.github/workflows/*.yaml'));
    for my $path (sort @workflow_files, sort glob('.github/scripts/*.sh')) {
        my $text = bytes($path);
        $text =~ s/^\h*\#.*$//gmx;
        while ($text =~ /(?:\A|[\s{,])["']?uses["']?:\h*["']?([^\s"'\#,}]+)/gx) {
            my $action = $1;
            checked(
                scalar($action =~ /\A[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+\@[0-9a-f]{40}\z/x),
                "$path action $action needs a reviewed immutable reference"
            );
            checked(exists $tools{$action}, "$path action $action has no license record");
        }
        while ($text =~ /\bgo\h+install\h+([^\s"']+)/gx) {
            checked(exists $go{$1}, "$path Go installer $1 has no matching license record");
        }
        while ($text =~ /\b([A-Za-z][A-Za-z0-9_.-]*==[0-9][A-Za-z0-9_.+-]*)/gx) {
            checked(exists $python{$1}, "$path Python installer $1 has no matching license record");
        }
        while ($text =~ m{miyagawa/cpanminus/([^/\s]+)/cpanm}gx) {
            checked(exists $tools{"miyagawa/cpanminus\@$1"},
                "$path cpanminus bootstrap has no matching license record");
        }
    }
    return;
}

die "Usage: perl maint/check-licenses.pl [SOURCE_DIRECTORY]\n" if @ARGV > 1;
my $root = shift @ARGV // '.';
chdir $root or die "Cannot inspect $root: $!\n";
my $provenance = json('docs/license-provenance.json');
my $manifest   = maniread();
audit_project($provenance, $manifest);
my $external_count = audit_material($provenance, $manifest);
audit_tools($provenance);
print 'Licensing checks passed: '
    . scalar(keys %{$manifest})
    . " release files, $external_count reviewed external files.\n";
