# Executable examples

[Overview](../README.md) · [Task guide](../docs/usage.md)

| Example | Purpose | Optional dependency |
| --- | --- | --- |
| [messages.pl](messages.pl) | Compose and analyse supported/partial messages | None |
| [session.pl](session.pl) | Replay an original synthetic complete Italian-profile exchange | None |
| [codecs.pl](codecs.pl) | Use actual codec encoding and WAV generation without recording TX | Ham::CW or Ham::RTTY |
| [complete-it-cw.jsonl](complete-it-cw.jsonl) | Explicit event fixture for `ham-qso replay` | None |

Run from a checkout: `perl -Ilib examples/messages.pl`, or run the full catalog
with `perl -Ilib examples/run-all.pl`. Scripts are independent; the test runner
executes them from an empty temporary directory. The codec example accepts cw or
rtty and creates only temporary audio. Its example timings/transmissions are
synthetic and never operate a radio. Missing optional codecs are reported as skips.
