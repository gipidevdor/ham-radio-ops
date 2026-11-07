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
The record identifies the measured source snapshot independently from the later
Windows lifetime correction and portability checks.

| Workload (1024 synthetic contacts) | Before | After | Ratio |
| --- | ---: | ---: | ---: |
| ADI encoding | 238.324 ms | 140.864 ms | 1.69x |
| ADI decoding | 261.284 ms | 179.283 ms | 1.46x |
| Repeated ADX validation (one contact) | 6.716 ms | 0.684 ms | 9.82x |
| Durable batch import | 8769.345 ms | 761.630 ms | 11.51x |
| Fully verified export | 1122.519 ms | 1074.894 ms | 1.04x |

The raw record also contains the smaller 128-contact workload, every sample,
interpreter/platform details, archive/source hashes and verification scope.
Each ratio describes these local medians. Batch-import comparisons include
filesystem sync cost, which varies with the storage environment. Full journal
verification is retained. RSS and other platforms are unmeasured.
