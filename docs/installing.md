# Installation

[Overview](../README.md) · [Task guide](usage.md)

Requires Perl 5.20+ and ExtUtils::MakeMaker 7.22+. Install from source with
`perl Makefile.PL`, your make program, `make test`, then `make install`.
Install the declared dependencies first with `cpanm --installdeps .`; an older
Perl's bundled modules may need upgrades. Runtime minimums include Storable 3.41,
Digest::SHA 5.96, Encode 3.12 and Cwd/PathTools 3.65. Language compatibility with
Perl 5.20 is not a recommendation to deploy an unpatched interpreter.
For a user-owned prefix: `perl Makefile.PL INSTALL_BASE="$HOME/perl5"` and add
its `bin` to PATH and `lib/perl5` to PERL5LIB. Use your platform's path separator.

The default engine never loads PDL or either codec. To use symbolic or audio
conversion, install Ham::CW and/or Ham::RTTY from their checked-out distributions
using the same Perl. Their dependencies and reception limits remain their own.

From adjacent checkouts on POSIX, integration can be exercised with:

```sh
PERL5LIB="lib:../ham-cw/lib:../ham-rtty/lib" prove -lv t/07-codec-integration.t
```

No absolute developer-machine paths are embedded in the repository. Windows uses
`;` to separate PERL5LIB entries. Native codecs are loaded lazily. An unavailable
selected codec raises QSO_E_DEPENDENCY; it never selects a different mode.

The [station log and ADIF codec](logbook.md) use core Perl modules for the journal,
ADI and ADX export. ADX import optionally requires XML::Parser 2.59+; validating
against the bundled official schemas additionally requires XML::LibXML 2.0213+.
These are separately installed dependencies, not bundled native libraries.
The official CC0 schema files are installed with the library and need no network.

Windows CI uses Strawberry Perl 5.40 with a matching native toolchain. This avoids
the [reported XS incompatibility in the alternative upstream Windows build](https://github.com/shogo82148/actions-setup-perl/issues/2310).
Build tools and native modules must belong to the same Perl installation.
See the [dependency review](dependency-audit.md) for current audit findings.
