# Architecture

[Overview](../README.md) · [Standards](standards.md) · [API](../lib/Ham/QSO.pm)

- Reception: native codec Result → Message analysis → explicit Session RX event.
- Preparation: fields → Message composition → proposal → native codec text/audio.
- Transmission: application observation → explicit Session TX event.
- Observation: ordered events → evidence facts → independent cumulative Result.

Ham::QSO is the facade. Profile holds named source editions and checks. Message
owns the supported grammar. Session owns evidence and lifecycle. Adapter owns
optional codec construction/delegation. Result and Error copy public data.
The implementation uses pure Perl; there is no numerical backend.

## Evidence boundary

Preparing, rendering, encoding, saving a file and decoding are not on-air events.
Only an explicit observation can advance semantic facts. A proposal records its
session token and revision. Successful observations, peer changes, abort and reset
invalidate prior proposals. Tokens are in-process correlation, not authentication.

Message ambiguity, unsupported forms and uncertain codec results remain observable
in history without contributing inferred identity, reports or acknowledgements.
Actual observed violations are retained; malformed API calls are rejected atomically.
A TX with mismatched source cannot prove local identification. A message directed
to another station cannot prove this contact's report. Peer correction requires
an observed full identity and clears all dependent exchange proof.

The current report in each direction has a value and evidence event ID. R/RR
acknowledges the immediately preceding relevant opposite over. It confirms a
report only when that over contained the report. A generic acknowledgement of
a later repeat/wait message cannot confirm an older report. Unknown or uncertain
intervening overs block this association; unrelated known stations do not. A changed report value
invalidates the acknowledgement referring to the old report. Repetition of an
identical report preserves it. Successful identification, completion, both parties'
closing, local station closure and observation EOF are distinct.

## State and time

READY → CALLING/CONTACT → EXCHANGING → COMPLETE describes observed progress.
Either closing gives CLOSING; both give TERMINATED. Abort gives ABORTED, while
preserving whether the exchange was already complete. The engine does not impose
one fixed conversational script or a mandatory three-over exchange.

Clock values are caller-supplied integer milliseconds, from one epoch, bounded by
2**52, with positive durations. Ordered complete overs cannot overlap in this
version. IDs are bounded to 128 characters; input text to 8192 characters; sessions
to max_events (default 5000, configurable 1..100000). Identification spans are
bounded to 10000 per over. Snapshots retain the bounded complete history; replace
the previous snapshot rather than append it. Snapshot production copies history
and therefore costs O(retained evidence); it is not an unlimited-duration stream.

feed/receive/transmitted validate all argument types, ranges, event ID conflicts,
time ordering and bounds before mutation. Identical event replay is idempotent.
The event ID index refers to retained observations directly; duplicate comparison
serializes only replayed events, and peer selection uses the same index.
finish is idempotent, does not close the QSO, and rejects further mutating work.
reset retains configuration, clears observations and invalidates proposals.

## Files and native codecs

The integrated [station log](logbook.md) persists explicit contact records and
finished session evidence separately from working snapshots. Its append-only
journal uses an attributed correction chain, SHA-256 linkage and externally
preserved checkpoints. ADIF 3.1.8 ADI/ADX import/export is an interchange boundary;
import never creates an observed TX/RX event. Storage retention, authenticated
identity, qualified timestamps and legal conservation remain deployment concerns.

Exclusive-create and explicit atomic-replacement helpers share the siblings'
implementation. Caller-owned handles remain open. Overwrite preserves regular
permission bits, not ownership/ACLs/other hard links. Symlink destinations are
rejected. Use output directories protected against concurrent writers.
Native codec Results and errors retain their contracts. No native audio decoder
is claimed infallible merely because it returned final text without warnings.
