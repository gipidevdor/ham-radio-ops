# Verification record

[Overview](../README.md) · [Standards](standards.md) · [Raw evidence](current-results.json)

Local development verification on **2026-11-07**: macOS ARM64, Perl 5.44.0,
Perl::Tidy 20260826. Results apply to the declared implementation and source
editions; they do not certify all Italian or international radio-law obligations.

| Check | Observed result |
| --- | --- |
| Ordinary suite with both real codecs | PASS: 11 files, 1373 top-level assertions |
| Actual CW/RTTY integration | PASS: symbols, mode-specific endings, WAV generation/reception, native Result uncertainty and CLI |
| Production statement coverage | 99.57% (95% minimum) |
| Production branch coverage | 97.35% (90% minimum) |
| Author gates | PASS: critic, pinned formatter, POD, executable documentation, metadata, CPANTS and website |
| Release archive | PASS: distribution tests and archive metadata/quality checks |
| Isolated installation | PASS: installed library, CLI launcher and independent core examples |
| Workflow configuration | PASS: actionlint syntax/expression/shell checks |
| Shared visual/configuration assets | Exact copies of siblings' formatter/critic settings and documentation CSS |

Coverage includes every production module, facade, CLI and adapter; external
codec implementations are excluded. Raw counts, module hashes and actual codec
source-tree hashes are preserved in the linked JSON. Optional codec skips during
isolated core installation are explicit; integration was verified separately
with both actual sibling source trees on the same Perl.

The suite uses exhaustive independent numeric RST vectors, Italian timing
boundaries, lifecycle and failure atomicity, corrected reports and peer identity,
ambiguity preservation, explicit preparation/transmission separation and codec
warning propagation. Identification claims inconsistent with transcript counts
are diagnosed. Audio round trips establish integration, not general reception
accuracy. [Benchmarks](benchmarks.md) use separately measured sequential workloads.

Linux, Windows, FreeBSD, Solaris, Cygwin and other supported Perl releases are
configured in CI but have not run in this local task. GitHub Pages deployment,
CPAN publication and a full current dependency/security audit have not been run.
Codec reception limits and unassessed licensing/RF obligations remain explicit.
