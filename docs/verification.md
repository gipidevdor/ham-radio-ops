# Verification record

[Overview](../README.md) · [Standards](standards.md) · [Current checks](quality-results.json) · [Earlier logbook record](logbook-results.json) · [Earlier core record](current-results.json)

The [CI and dependency-audit snapshot](ci-results.json) records the remote baseline
and subsequent repair checks separately from the local measurements below.
Workflow links at the end of this page show subsequent runs. The Windows matrix uses
Strawberry Perl with a matching native toolchain and verifies native dependency
loading before running tests. Unresolved upstream dependency advisories remain
visible in the [dependency review](dependency-audit.md#observed-dependency-audit).

Local development verification on **2026-11-07**: macOS ARM64, Perl 5.44.0,
Perl::Tidy 20260826. Results apply to the declared implementation and source
editions; they do not certify all Italian or international radio-law obligations.

| Check | Observed result |
| --- | --- |
| Ordinary suite with both real codecs | PASS: 14 files, 1528 top-level assertions |
| Actual CW/RTTY integration | PASS: symbols, mode-specific endings, WAV generation/reception, native Result uncertainty and CLI |
| Production statement coverage | 99.39% (95% minimum) |
| Production branch coverage | 91.31% (90% minimum) |
| Ordinary and author gates | PASS: 23 files, 2001 top-level assertions; critic, pinned formatter, POD, executable documentation, metadata, CPANTS, licensing and website |
| Release archive | PASS: distribution tests and archive metadata/quality checks |
| Isolated installation | PASS: installed library, CLI, station-log example and official ADX schema validation |
| Workflow configuration | PASS: actionlint syntax/expression/shell checks |
| Shared visual/configuration assets | Exact copies of siblings' formatter/critic settings and documentation CSS |

Coverage includes every production module, including the station log, ADIF,
facade, CLI and adapter; external implementations are excluded. Current counts,
module hashes and measured comparisons are in the current-checks JSON. XML
dependency versions and the initial station-log measurements remain in the
earlier logbook record. The
earlier core record retains its original measurement and codec-source provenance;
its previous coverage numbers do not describe the added logbook/ADIF modules.
Optional codec skips during
isolated core installation are explicit; integration was verified separately
with both actual sibling source trees on the same Perl.

The suite uses exhaustive independent numeric RST vectors, Italian timing
boundaries, lifecycle and failure atomicity, corrected reports and peer identity,
ambiguity preservation, explicit preparation/transmission separation and codec
warning propagation. Identification claims inconsistent with transcript counts
are diagnosed. Audio round trips establish integration, not general reception
accuracy. [Benchmarks](benchmarks.md) use separately measured sequential workloads.
The latest refinement also checks repeated peer selection after operator records,
unchanged history after rejected selection, and nested event replay after caller
mutation or equivalent numeric inputs.

Station-log verification includes immutable original versions, attributed
corrections, cooperating concurrent writers, damaged/incomplete writes, UTC date
transitions and externally anchored rollback detection. ADIF checks include
length-delimited embedded tags, Unicode ADX, typed extensions, compatibility
policies, conflicting declarations and independent official XSD validation.
Official schema bytes, source URLs and embedded CC0 notices are checked offline.
The quality pass adds exact decimal/string clock tests, malformed nested XML,
extension metadata conflicts, bounded chunk reads, invalid Unicode, working-directory
changes and deterministic exports across randomized Perl hash seeds. All three
historical Kosovo region periods are retained instead of overwriting older rows.
The portability follow-up also checks older optional XML versions, child programs
without shell quoting, and clean process shutdown with both official schema directions.

The table above records local checks; it does not stand in for the configured
Linux, Windows, FreeBSD, Solaris, Cygwin or other Perl-version jobs. See the
[test runs](https://github.com/gipidevdor/ham-radio-ops/actions/workflows/test.yml),
[security runs](https://github.com/gipidevdor/ham-radio-ops/actions/workflows/security.yml)
and [documentation deployments](https://github.com/gipidevdor/ham-radio-ops/actions/workflows/pages.yml)
for their actual revisions and outcomes. The live site's `site-manifest.json`
identifies its deployed revision; [publication checks](releasing.md#publish-the-documentation)
keep it aligned with the source. CPAN publication and a full current local
dependency/security audit are not part of this measurement. Codec reception
limits and unassessed licensing/RF obligations remain explicit.
