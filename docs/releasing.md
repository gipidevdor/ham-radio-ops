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
9. Review installed and declared dependency audit reports with the current
   advisory database. Unresolved findings prevent a clean-security release claim;
   preserve failures and exact dependency/interpreter build provenance.
10. Only after those gates, prepare the reviewed release/tag and publish explicitly.

## Publish the documentation

The existing `Documentation` workflow builds pull requests and publishes the
`main` branch to [GitHub Pages](https://gipidevdor.github.io/ham-radio-ops/).

1. Update guides, POD, examples and MANIFEST together. Keep dated verification
   records tied to the source hashes actually measured.
2. Run executable documentation and licensing checks, then build the site in an
   empty output directory with `perl maint/build-site.pl --output _site`.
3. Review the proposed changes and verify the pull request's documentation build.
4. Merge the reviewed branch into `main`. The workflow uploads the verified site
   and deploys it through the `github-pages` environment.
5. Wait for the deployment to finish. Check the live homepage, the updated guides
   and API references, downloadable evidence and `site-manifest.json`. Its revision
   must match the published commit.

Pull-request builds have read-only permissions. Deployment permissions are scoped
to the main-branch deployment job. Local packaging produces distribution artifacts;
the workflow above publishes the documentation of this development version.
