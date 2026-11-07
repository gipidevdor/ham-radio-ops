# Release procedure

[Overview](../README.md) · [Contributing](../CONTRIBUTING.md)

1. Review primary sources and dated profile scope, including Italian changes.
2. Run the ordinary suite with both real optional codecs and fatal warnings.
3. Run pinned style, POD, documentation/example and metadata author checks.
4. Measure production coverage; require 95% statements and 90% branches.
5. Build and check the documentation site from MANIFEST.
6. Run `make distcheck`, `make disttest`, `make dist`, then
   `perl maint/check-dist.pl Ham-QSO-0.001.tar.gz` and
   `perl maint/check-install.pl Ham-QSO-0.001.tar.gz`.
7. Inspect completed Linux/macOS/Windows CI and preserve their actual environment
   and source revision. Update verification data; do not infer unrun platform passes.
8. Review Changes, public versions, API inventory, licensing and unassessed rules.
9. Only after those gates, prepare the reviewed release/tag and publish explicitly.

This checkout is an initial development version. No GitHub repository, remote
branch, Pages deployment or CPAN upload is created by local packaging checks.
