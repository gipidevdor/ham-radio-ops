# Ham::QSO

Ham::QSO interprets supported CW and RTTY messages, tracks QSO evidence and
checks declared operating rules. Use it through the Perl API or `ham-qso`.

Requires Perl 5.20 or later. The semantic engine uses core modules only.
Ham::CW and Ham::RTTY are optional adapters. PDL is neither required nor recommended.
The default operating profile is **Italy / CW**.

[Guides](docs/README.md) · [Examples](examples/README.md) · [API reference](lib/Ham/QSO.pm) · [Contributing](CONTRIBUTING.md)

## Start here

Run from a checkout without installing:

```sh
perl -Ilib bin/ham-qso compose --station IU0ABC --kind cq
perl -Ilib bin/ham-qso parse --json 'IU0ABC DE DL1ABC R RST 579 KN'
perl -Ilib bin/ham-qso replay --station IU0ABC --input examples/complete-it-cw.jsonl --strict
```

To install from a checkout or extracted distribution:

```sh
perl Makefile.PL
make
make test
make install
```

Builds require ExtUtils::MakeMaker 7.22 or later and your Perl's make program.
See [installation](docs/installing.md) for optional codecs and local installation.

| You want to… | Command |
| --- | --- |
| Prepare an ordinary CW call | `ham-qso compose --station IU0ABC --kind cq` |
| Inspect received semantics | `ham-qso parse --json 'IU0ABC DE DL1ABC RST 579 KN'` |
| Choose RTTY for Italy | `ham-qso profiles --profile it-rtty` |
| Inspect sources and rules | `ham-qso profiles` |
| Encode through the actual codec | `ham-qso encode 'CQ DE IU0ABC K'` |
| Generate practice audio | `ham-qso wav --output practice.wav 'CQ DE IU0ABC K'` |
| Check a bounded event transcript | `ham-qso replay --station IU0ABC --input events.jsonl --strict` |

Text commands accept `--input FILE` or stdin. `--output FILE` uses exclusive
creation; replacement requires `--overwrite`. `--output -` selects stdout.
WAV generation requires an explicit output. Diagnostics go to stderr.

## Use it in Perl

```perl
use 5.020;
use strict;
use warnings;
use Ham::QSO;

my $qso = Ham::QSO->new(profile => 'it-cw');
my $session = $qso->session(station => 'IU0ABC');
my $proposal = $session->prepare(kind => 'cq');
print $proposal->{text}, "\n";
print $session->snapshot->state, "\n"; # READY: still no transmission
```

The application explicitly records actual TX/RX events. Preparing text, encoding
symbols or creating a WAV never advances a QSO. See [the task guide](docs/usage.md).

## Know what to expect

A complete QSO requires observed mutual identification, reports and explicit
acknowledgements of each current report. Completion, contact closure, observation
EOF and station closure are separate facts. Partial identities and uncertain
reception are retained without guesses. Corrected reports invalidate old acknowledgements.

Supported profiles: `it-cw`, `it-rtty`, `iaru-cw`, `iaru-rtty`. They are based on
a declared subset of IARU EOP 4.2.0, with Italian identification checks from
Allegato 26, article 12(6). Every implemented rule has a source or is explicitly
marked as an engineering contract. See [standards and provenance](docs/standards.md)
and [Italy](docs/italy.md).

The parser deliberately recognises a bounded grammar, documented in
[Message POD](lib/Ham/QSO/Message.pm). Other valid on-air forms can return
`unsupported`; this never means illegal. Free conversation, contests, emergency
traffic and award-specific validation are outside version 0.001.

**A satisfied checked scope is not a declaration of complete legal conformity.**
Assignments, authorisations, actual on-air identity and RF constraints need
independent evidence. The library always exposes these unassessed obligations.
No radio, audio playback, microphone or unattended operation is controlled.

Version 0.001 is under development. [Verification](docs/verification.md) separates
measured local results from configured CI and remaining release work.

## Explore the project

[Architecture](docs/architecture.md) · [Release procedure](docs/releasing.md) ·
[Security reports](SECURITY.md) · [Dependency review](docs/dependency-audit.md)

Copyright © 2026 Giacomo Picchiarelli. Code and original material use
[Artistic License 2.0](LICENSE). External standards retain their own terms;
see [NOTICE](NOTICE) and [licensing and copyright](docs/licensing.md).
No standards text or third-party recordings are bundled.
