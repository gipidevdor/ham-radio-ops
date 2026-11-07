# Installation

[Overview](../README.md) · [Task guide](usage.md)

Requires Perl 5.20+ and ExtUtils::MakeMaker 7.22+. Install from source with
`perl Makefile.PL`, your make program, `make test`, then `make install`.
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
