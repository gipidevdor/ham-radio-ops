# Diagnostics and recovery

[Overview](../README.md) · [Result API](../lib/Ham/QSO/Result.pm)

Diagnostic codes are stable; explanatory prose may change. Each diagnostic names
its rule and, for observations, its event ID. `W` marks uncertainty within the
checked scope. `V` marks a detected violation of a declared profile or evidence
contract; it does not by itself establish an offence under radio law.

| Code | Meaning / next action |
| --- | --- |
| QSO_W_CHARACTER | Empty text or characters outside the supported grammar; keep the original input. |
| QSO_W_PARTIAL | Partial identity or uncertain numeric data; request a repeat, never complete it by guess. |
| QSO_W_HEADER | Missing full, supported addressing; obtain complete identity. |
| QSO_W_ENDING | Broadcast ending outside the supported forms; review the original text. |
| QSO_W_PROSIGN | Mode-specific signal notation is unsupported; distinguish a CW waveform token from RTTY letters. |
| QSO_W_BODY | Body not interpreted; no semantic proof was extracted. |
| QSO_W_GRAMMAR | Whole message outside the declared subset; this is not a claim of illegality. |
| QSO_W_REPORT | Abbreviated or uncertain report; supply an unambiguous numeric report. |
| QSO_V_REPORT | An explicit numeric RST report is outside the supported R/S/T ranges. |
| QSO_V_IDENTITY | Repeated station identities in a single supported CQ disagree. |
| QSO_W_UNCERTAIN | Caller or codec marks reception/transmission uncertain; no facts were accepted. |
| QSO_W_ACK_CONTEXT | R/RR has no unambiguous preceding opposite over; no report reception is inferred. |
| QSO_W_OTHER_STATION | Observation addresses another station or names another peer; no current-contact facts changed. |
| QSO_W_IDENTIFICATION | Italian identification timing absent; compliance remains indeterminate. |
| QSO_V_IDENTIFICATION | Supplied Italian identification schedule fails opening/closing or interval checks. |
| QSO_V_IDENTIFICATION_EVIDENCE | Claimed identification count contradicts complete identities in the transcript. |
| QSO_V_SOURCE | TX/RX direction contradicts the source identity; no exchange facts were accepted. |
| QSO_V_ENDED | New semantic evidence arrived after termination/abort; start a new Session for a new contact. |
| QSO_V_CLOSED_PARTY | A station already closed this contact and cannot add new exchange proof. |

Malformed API calls instead throw structured Error objects without partial state
changes. See [facade error codes](../lib/Ham/QSO.pm) for programmatic handling.
Actual observed violations remain in history. A corrected report requires a new
acknowledgement; earlier evidence is never silently relabelled.
