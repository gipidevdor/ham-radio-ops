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
Time::HiRes, POSIX and Encode. ADX import optionally loads XML::Parser 2.59+;
official XSD validation optionally loads XML::LibXML 2.0213+ and its native
dependencies. These optional libraries are separately installed and are not
bundled in the distribution. Their licensing is recorded in
[ADIF provenance](adif-sources.json); this record is not a vulnerability audit.

A successful build, style check or codec test is not a vulnerability audit. No
clean security-audit claim is made here. The source family has identified
Perl/File::Temp and dependency advisories; use a maintained, patched Perl and
review actual installed versions before release. No inherited audit JSON is
relabelled as a current result for this repository.
