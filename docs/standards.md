# Standards and provenance

[Overview](../README.md) · [Italy](italy.md) · [Verification](verification.md)

## Source inventory

Sources reviewed on **2026-11-07**, with editions deliberately fixed:

| Source | Edition / section | Authority and scope |
| --- | --- | --- |
| [IARU EOP](https://www.iaru-r1.org/on-the-air/eop/) | Fourth edition, v4.2.0, June 2026 | Radioamateur operating recommendations and guidance |
| [ITU-R M.1677-1](https://www.itu.int/rec/R-REC-M.1677/en) | October 2009 | Morse symbols, delegated to Ham::CW; not a complete QSO protocol |
| [Italian Allegato 26](https://www.gazzettaufficiale.it/eli/id/2021/03/22/21A01607/sg) | D.M. 1 March 2021, article 12 | National exercise requirements; implemented check is paragraph 6 |
| [MIMIT radioamateur notices](https://ispettorati.mise.gov.it/index.php/servizi/radioamatori/) | Reviewed 2026-11-07 | Current administrative context and limitations of callsign assumptions |
| [D.M. 26 January 2026](https://www.gazzettaufficiale.it/eli/id/2026/03/03/26A00956/SG) | Class N / selected callsigns | Does not justify hard-coded assignment heuristics or authorisation claims |

M.1172 is scoped to the maritime mobile service and is not adopted wholesale as
amateur-radio session law. KN is an amateur convention described by IARU, not a
regulator-standardised prosign; profile acceptance does not make that claim.
This project adds no Morse alphabet or ITA2 table. Ham::CW/Ham::RTTY own those
encoding contracts. Angle-bracket CW tokens are not passed as literal RTTY prosigns.

## Source to rule to verification

The executable rule inventory is `Ham::QSO::Profile->rules`. The identifiers below
are an engineering index, not official section numbers. Requirement descriptions
are original implementation summaries, not reproduced standards text.

| Rule | Source / section | Verification |
| --- | --- | --- |
| QSO-R001 | EOP 12.1 | t/03-session.t, t/04-evidence.t, t/11-acknowledgement-context.t: identities, reports and context-bound acknowledgements |
| QSO-R002 | EOP 12.2, 12.6.1 | t/01-messages.t, t/04-evidence.t: full addressed identities; no partial repair |
| QSO-R003 | EOP 13.3, 13.6, 13.7 | t/03-session.t: K/KN, AR, SK/CL and 73 have distinct effects |
| QSO-R004 | EOP 13.4, 14.1 | t/01-messages.t: exhaustive independent 000..999 report vectors |
| IT-R001 | Allegato 26, 12(6) | t/02-italy-standards.t: opening/closing and 600000 ms boundary vectors |
| ENG-R001 | Architecture, Evidence boundary | t/03-session.t, t/05-validation.t, t/07-codec-integration.t, t/09-failure-boundaries.t |
| ENG-R002 | Architecture, Evidence boundary | t/04-evidence.t: corrected reports and peer identity invalidate dependent proof |

## Exact conformity boundary

The library checks only its supported semantic forms, evidence relationships and
supplied identification schedule. This is neither a full encoding certification
nor proof of all Italian/ITU requirements. It exposes satisfied, indeterminate or
violated for that scope, and always reports overall legal status as not_assessed.
Absence of evidence is not treated as compliance. Unsupported input is not treated
as proof of illegality. Scope never expands because a test suite passed.

The parser is deliberately conservative. Example transcripts in EOP sections
13.8 and 14.3 explicitly do not define a single obligatory QSO template. This
implementation's grammar is therefore documented as an implementation subset.
Other valid conversational forms can be unsupported. Contest-specific exchanges,
awards, multiparty nets, emergency signals and unattended operation are not covered.

Authorisations, callsign assignment and prefixes/suffixes, RF frequency and occupied
bandwidth, power, interference, permitted correspondents and truthful observation
metadata require independent evidence. Input of a syntactically plausible callsign
never asserts its legal assignment. Review source updates before operational release.
