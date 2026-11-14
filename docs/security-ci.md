# CI and security

The Tests workflow checks the supported minimum and recent Perl, macOS and Windows,
then runs separate actual-codec integration and author/distribution gates.
Documentation builds on pull requests with read-only access; only the main branch
can deploy through the github-pages environment. External Actions use pinned SHAs.
A configured workflow is not evidence of a completed platform run.

No workflow publishes to CPAN. No credentials, radio endpoints or station licences
are required. Input bounds, argument atomicity, explicit output replacement and
uncertainty propagation are covered by local tests. See [security reports](../SECURITY.md)
and the [verification record](verification.md) for the exact evidence available.
