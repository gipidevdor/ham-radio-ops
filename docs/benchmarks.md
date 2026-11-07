# Benchmarks

[Overview](../README.md) · [Verification](verification.md) · [Raw measurements](benchmark-results.json)

Run `perl maint/benchmark.pl --iterations 1000 --json`. Each operation runs
sequentially, with the same configured profile and independently allocated Results.
The wall timer excludes interpreter startup and input preparation; it includes
the operation and its returned snapshot. Iteration count, Perl, architecture,
profile revision and exact input hash accompany the raw results.

The fixed workload measures message parsing, canonical composition, and a fresh
session plus one explicit RX event. It does not establish unlimited-stream
performance, field reception accuracy or timing guarantees. Retained-history
snapshot costs grow with history. RSS is explicitly unmeasured; no numerical
backend or PDL comparison is applicable. Run without concurrent tests/coverage.
