# Dependency review

The semantic runtime uses Perl core modules. Explicit minimum Storable 3.41 is
shared with the sibling projects; support for Perl 5.20 does not mean every
module bundled with an unpatched old interpreter satisfies these requirements.
Ham::CW and Ham::RTTY 0.001 are optional, suggested dependencies. Neither PDL nor
external audio programs are required or recommended. Adapter construction selects
backend perl; a caller-injected codec retains the caller's own configuration.

Author tools and the documentation builder are declared separately in Makefile.PL.
The documentation builder uses [Pod::Simple](https://metacpan.org/pod/Pod::Simple),
Markdown::Perl, PPI and HTML/URI tools, and requires Perl 5.26+.

The integrated station journal additionally uses core Digest::SHA 5.96+,
Time::HiRes, POSIX, Encode 3.12+ and Cwd/PathTools 3.65+. The latter minimums
exclude the affected releases documented in the upstream
[Encode security release](https://github.com/dankogai/p5-encode/commit/527e482dc70b035d0df4f8c77a00d81f8d775c74)
and [PathTools change history](https://metacpan.org/dist/PathTools/changes).
ADX import optionally loads XML::Parser 2.59+;
official XSD validation optionally loads XML::LibXML 2.0213+ and its native
dependencies. These optional libraries are separately installed and are not
bundled in the distribution. Their licensing is recorded in
[ADIF provenance](adif-sources.json); this record is not a vulnerability audit.

A successful build, style check or codec test is not a vulnerability audit.
The [dated CI and audit record](ci-results.json) identifies the actual source,
scanner, database and workflow outcomes. No inherited audit JSON is relabelled
as a current result for this repository.

## Observed dependency audit

The completed GitHub audit of revision `14ef9f7` on 2026-11-07 used
CPAN::Audit 20261105.001 and CPANSA::DB 20261101.010. It reported two installed
advisories: `CPANSA-File-Temp-2011-4116` for File::Temp 0.2312 and
`CPANSA-perl-2026-15534` for Perl 5.44.0. It reported 35 distinct advisories
across the allowed dependency ranges. The tightened Encode and PathTools minimums
remove five of those range matches; the local repeat with the same database
reports 30, all in Perl and File::Temp. These counts concern different scopes;
they are not 30 vulnerabilities demonstrated in Ham::QSO.

The File::Temp issue concerns symlinks in parent paths and remains
[open upstream](https://github.com/Perl-Toolchain-Gang/File-Temp/issues/14).
Keep output and temporary-directory parents under the deployment's control;
the module does not rely on File::Temp's `safe_level` as a security boundary.
The Perl finding concerns regex-engine cache arithmetic for very large subjects;
the [upstream correction](https://github.com/Perl/perl5/commit/54cf3d44cbbedd17d774e9a37921963e8fd5d0cb)
belongs to the interpreter. CPANSA::DB lists no fixed release range for either
installed finding in this snapshot. Library tests do not establish that a given
Perl binary includes that correction.

The security workflow continues to fail when these findings are present. No
advisory is suppressed, no scanner result is rewritten and no clean-audit claim
is made. Before release, review the exact interpreter and dependency builds,
including vendor patches, against the current advisory database. Supporting
older Perl syntax does not attest the security of old interpreter releases.
