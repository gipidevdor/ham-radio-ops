# Contributing

[Overview](README.md) · [Task guide](docs/usage.md) · [Release procedure](docs/releasing.md)

## Working principles

Show a working example before advanced options. Keep installed API contracts in
POD, diagnostics on stderr and file replacement explicit. Support Perl 5.20+ with
core semantic dependencies. Ham::CW and Ham::RTTY integrations remain optional.
Do not introduce PDL: this workload needs no numerical backend.

Use exactly the checked-in `.perltidyrc` (100 columns, four spaces) and
`.perlcriticrc` (severity 3), shared with ham-cw and ham-rtty. Pin Perl::Tidy
20260826. Suppressions must be narrow and justified; never disable a policy to
hide a correctness defect.

## Set up a source checkout

```sh
perl Makefile.PL
make
make test
```

For author checks, install the development prerequisites declared in Makefile.PL:

```sh
cpanm --notest Perl::Tidy@20260826
cpanm --installdeps --with-develop .
make distmeta
prove -lr t xt
```

Run `t/07-codec-integration.t` with both actual sibling libraries on PERL5LIB.
A skipped optional-codec test is not evidence that integration passed.

## Changing behaviour

Map each operating requirement to a source, edition, section, rule ID and
independent test vector. Separate regulatory obligations, IARU recommendations
and engineering policies. Do not turn example transcripts into mandatory rules.
Do not claim complete statutory conformity based on a semantic transcript.

For every behaviour fix, add a regression distinguishing the old result from
the required one. Include damaged, ambiguous and adversarial sequences, malformed
inputs, stale proposals, wrong recipients, corrections, replay, lifecycle and
resource ceilings. Round trips alone do not establish semantic correctness.

## Documenting the public API

Every public method needs a POD `=head2`, signature, input/return types, defaults,
units, ranges, error codes and lifecycle effects. Every SYNOPSIS and guide Perl
block is an independent runnable program. Reference details live in POD; guides
link there. Documentation checks execute snippets in temporary directories.

## Documentation website

The site builder and visual style are shared with ham-cw/ham-rtty. It builds
MANIFEST-listed POD, Markdown, examples, notices and raw verification data.
The site builder requires Perl 5.26+, while the library supports 5.20.

```sh
perl maint/build-site.pl --output _site
perl maint/build-site.pl --check _site
```

PRs build the documentation with read-only permissions. Only the main-branch
Pages job receives deployment permissions. Keep Actions pinned to full SHAs.

## Coverage and release checks

Targets match the sibling projects: 95% statements and 90% branches across all
production modules, including adapters and CLI. Collect with both codecs present;
exclude their implementation from this distribution's coverage inventory.

```sh
HARNESS_PERL_SWITCHES='-MDevel::Cover=-db,cover_db,-blib,0,-coverage,statement,branch,condition,-select,lib/Ham/QSO,-ignore,^t/' prove -lr t
perl maint/coverage.pl cover_db
```

Coverage is additional evidence, not proof of standards or field correctness.
Update Changes, MANIFEST, prerequisites, source matrix and dated verification
together. Keep unmeasured platforms explicit. Build, test and install the archive
in isolation before release. Submit changes through reviewed pull requests.
