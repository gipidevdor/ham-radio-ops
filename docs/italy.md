# Operating from Italy

[Overview](../README.md) · [Sources](standards.md) · [Profile API](../lib/Ham/QSO/Profile.pm)

Profiles `it-cw` and `it-rtty` select Italy explicitly; `it-cw` is the default.
The station identity is the actual full callsign authorised for that operation.
An Italian profile selects the transmitting station's jurisdiction, not its
nationality or the counterpart's jurisdiction. Callsign prefixes are never used
to infer a licence class or operating permission.

## Identification evidence

Allegato 26, article 12(6), requires identification at the beginning/end of
transmissions and during their course at ten-minute intervals. The implementation
uses milliseconds and a maximum completion-to-completion interval of 600000.
It conservatively treats every supplied TX over as needing opening and closing
identification phrases. This is an explicit engineering interpretation of the
boundaries, not a claim that legislation defines their exact audio duration.

Each span `{start_ms, end_ms}` is the application's attestation of a complete
identification phrase of the configured station, relative to the over. Include
introductory/closing address text within those phrases. The first span starts at
zero and the last ends at duration_ms. Spans must have positive lengths, be
ordered, disjoint, and remain inside the observed over. For the initial deadline,
time starts at zero; later intervals use successive completion times. Generating
audio does not produce these attestations automatically.

Missing spans give indeterminate; an explicit empty schedule or a failed deadline
gives violated. The event is retained even if it records a violation. The check
does not recognise a callsign from a waveform or verify the caller's claim.
Canonical directed composition repeats identification at opening and closing;
a caller must still supply truthful actual timing. Claims of more identification
spans than complete station-identity occurrences in the transcript are diagnosed
as contradictory evidence.

## Additional obligations

Article 12 also concerns permitted station use/correspondents, clear language,
recognised codes and other duties. This version does not decide these from text.
It does not assign/approve special callsigns, authorise /P or /M suffixes, infer
CEPT visitor privileges, validate class N permissions, or certify a station's
frequency/power/technical compliance. This applies equally to Italian residents
and visiting operators. These remain explicit unassessed obligations in Results.

The 2026 class N / selected callsign decree and MIMIT's transitional notices were
reviewed; administrative changes are not converted into guessed callsign patterns.
No blanket permission for unattended transmission is implied. See the primary
sources linked in the [source inventory](standards.md).
