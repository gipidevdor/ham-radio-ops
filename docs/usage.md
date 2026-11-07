# Task guide

[Overview](../README.md) · [API](../lib/Ham/QSO.pm) · [Examples](../examples/README.md)

## Prepare and observe separately

```perl
use strict;
use warnings;
use Ham::QSO;
my $qso = Ham::QSO->new(profile => 'it-cw');
my $session = $qso->session(station => 'IU0ABC');
my $proposal = $session->prepare(kind => 'cq');
print $proposal->{text}, "\n";
# After the application has observed a real over, with actual timing:
my $result = $session->transmitted($proposal, id => 'tx1', at_ms => 0,
    duration_ms => 10000, identifications => [
        {start_ms => 0, end_ms => 2000}, {start_ms => 8000, end_ms => 10000}]);
print $result->state, "\n";
```

The numbers above are illustrative caller evidence, not inferred timings.
Use the actual station callsign supplied by its authorisation. Lexical syntax
validation never proves an assignment. Each Session represents one contact.

## Analyse damaged input

```perl
use strict;
use warnings;
use Ham::QSO;
my $qso = Ham::QSO->new;
my $analysis = $qso->parse('IU0ABC DE DL1? RST 5?9 KN');
print $analysis->status, "\n";
for my $diagnostic (@{$analysis->diagnostics}) {
    print "$diagnostic->{code}: $diagnostic->{message}\n";
}
```

Pass `uncertain => 1` when recording unreliable RX/TX. The raw text is retained
but no semantic fact is proved. Text accepts ASCII with tab, CR and LF whitespace;
non-ASCII characters are preserved as unsupported input, never transliterated
into a plausible callsign. Unsupported grammar is not a legal verdict.
Explicit R/RR acknowledges the immediately preceding unambiguous opposite over.
Report reception is confirmed only when that over carried the report; generic
message acknowledgements are tracked separately. An intervening uncertain or
uninterpreted over blocks report association until an explicit repeat. A later
corrected report invalidates the acknowledgement of the previous value.

## Connect CW or RTTY

Use `$qso->adapter(options => {...})` to construct the matching real codec, or
`$qso->adapter(codec => $existing_codec)` to reuse a configured object.
`encode`, `wav_bytes` and `write_wav` accept supported text or a proposal with
the identical profile. They never record TX. Symbolic `decode` returns a semantic
analysis without touching a session. `read_wav` preserves the native codec Result.

Call `receive_result($session, $codec_result, id => ..., at_ms => ...,
duration_ms => ...)` explicitly to record decoded audio. Any warning or unfinished
preview forces uncertainty. The caller still controls when and what to transmit.
See the executable [codec example](../examples/codecs.pl) and
[Adapter contract](../lib/Ham/QSO/Adapter.pm).

## Replay observations

`ham-qso replay --station IU0ABC --input events.jsonl --strict` accepts one
Session feed object per line, or operator select_peer/abort records. Event IDs
are idempotent only when the complete normalised event matches. Different evidence
with the same ID is rejected. Times are caller-selected integer milliseconds
from one epoch, monotonic and nonoverlapping. EOF only finishes observation.

## Archive a contact in the station log

Finish the Session observation stream, then use `record_session` on the integrated
logbook with the operator, a unique record ID, an explicit UTC origin for the
event clock, and frequency/band metadata. The archived snapshot includes original
events, diagnostics and uncertainty. Completion and contact closure remain
separate facts; incomplete contacts are retained as incomplete.

The [station-log guide](logbook.md#archive-an-observed-session) contains a complete
independent example. Create the persistent file once; reopen it for subsequent
contacts. `correct` appends a full replacement field set with a predecessor ID
and reason. `export_adif` produces the current contact view; `records` retains the
full original history. Preserve the journal and trusted checkpoints separately.

## Interpret the outcome

`complete` concerns current identification/report/ack evidence. `terminated`
concerns both closing signals or operator abort. `lifecycle` concerns the
observation stream. `conformance.status` concerns the explicitly named checked
scope; `legal_status` remains not_assessed. Review the unassessed obligations.
