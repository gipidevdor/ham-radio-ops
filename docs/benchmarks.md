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

## Station log and ADIF

Run `perl maint/benchmark-logbook.pl --contacts 1024 --iterations 3`. The
[quality measurements](quality-results.json) compare the previously verified
archive with the corrected implementation using the identical benchmark script
and input hashes. Runs were sequential with no concurrent tests or coverage.
Each median includes repeated calls; the first ADX schema compilation is retained
in the samples. Batch import includes exclusive file creation and a durable commit.

| Workload (1024 synthetic contacts) | Before | After | Ratio |
| --- | ---: | ---: | ---: |
| ADI encoding | 93.215 ms | 92.695 ms | 1.01x |
| ADI decoding | 114.531 ms | 116.090 ms | 0.99x |
| Repeated ADX validation (one contact) | 3.689 ms | 0.458 ms | 8.05x |
| Durable batch import | 908.242 ms | 463.714 ms | 1.96x |
| Fully verified export | 719.618 ms | 711.996 ms | 1.01x |

The raw record also contains the smaller 128-contact workload, every sample,
interpreter/platform details, archive/source hashes and verification scope.
ADI encode/decode and verified export remain approximately stable; speed claims
apply to the measured repeated validation and batch-import paths. Full journal
verification is retained. RSS and other platforms are unmeasured.
