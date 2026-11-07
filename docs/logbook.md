# Station log and ADIF

[Overview](../README.md) · [Logbook API](../lib/Ham/QSO/Logbook.pm) · [ADIF API](../lib/Ham/QSO/ADIF.pm) · [Licensing](licensing.md)

The station log is an integrated module, `Ham::QSO::Logbook`. It persists contacts,
original session evidence and attributed corrections. Session snapshots remain
bounded working state; resetting a session cannot remove an archived record.

```perl
use strict;
use warnings;
use File::Temp qw(tempdir);
use Ham::QSO;
my $directory = tempdir(CLEANUP => 1);
my $qso = Ham::QSO->new;
my $log = $qso->logbook(path => "$directory/station.jsonl",
    station => 'IU0ABC', log_id => 'IU0ABC-2026', create => 1);
my %fields = (CALL => 'DL1ABC', OPERATOR => 'IU0ABC', MODE => 'CW',
    QSO_DATE => '20261107', TIME_ON => '120000', QSO_DATE_OFF => '20261107',
    TIME_OFF => '120100', FREQ => '14.025', TX_PWR => '5',
    RST_SENT => '579', RST_RCVD => '589', QSO_COMPLETE => '?');
$log->record(id => 'qso1', operator => 'IU0ABC', fields => \%fields);
$log->correct(id => 'fix1', corrects => 'qso1', operator => 'IU0ABC',
    reason => 'Corrected frequency from operator notes',
    fields => {%fields, FREQ => '14.026'});
my $checkpoint = $log->verify;
print $log->export_adif;
```

Use a persistent protected directory in operation. Creation is explicit and
exclusive; reopening does not recreate a missing log. Successful appends are
locked and synced. IDs are unique and corrections must reference a current
predecessor. Earlier values, actors, reasons, record times and original evidence
remain available through `records`. ADIF export contains each contact's latest
version, so it is an interchange view rather than a backup of the full journal.

`record_session` archives a finished observation stream. Supply an explicit UTC
Unix origin in milliseconds for its event clock and external RF metadata, such
as FREQ in MHz or BAND. The module derives on/off dates and times from actual
observed events, including UTC midnight transitions. It retains incomplete,
uncertain and violated observations without inventing a peer or missing reports.
QSO_COMPLETE describes evidence of completion; it does not imply contact closure,
QSL confirmation, a permitted operating frequency or regulatory conformity.

## Archive an observed session

This independent example records a synthetic received over and archives an
incomplete contact. In operational software, supply observations and timestamps
from the actual station. The example's temporary directory is cleaned on exit;
use a protected persistent directory for the operational register.

```perl
use strict;
use warnings;
use File::Temp qw(tempdir);
use Time::Local qw(timegm);
use Ham::QSO;

my $directory = tempdir(CLEANUP => 1);
my $qso = Ham::QSO->new;
my $session = $qso->session(station => 'IU0ABC');
$session->receive('IU0ABC DE DL1ABC RST 579 KN',
    id => 'rx1', at_ms => 0, duration_ms => 1000);
$session->finish;

my $log = $qso->logbook(path => "$directory/station.jsonl",
    station => 'IU0ABC', log_id => 'session-example-2026', create => 1);
$log->record_session(id => 'contact1', operator => 'IU0ABC',
    session => $session,
    time_origin_ms => 1000 * timegm(0, 0, 12, 7, 10, 2026),
    fields => {FREQ => '14.025'});

my $document = $qso->adif->decode($log->export_adif);
print $document->{records}[0]{QSO_DATE}, " UTC\n";
print $document->{records}[0]{QSO_COMPLETE}, "\n"; # N: only RX was observed
```

The UTC origin above is 2026-11-07 at 12:00:00. Set the origin to zero only when
the Session's event times already contain Unix milliseconds. Finishing observation
does not create a closing transmission or invent a missing report.

## Choose the operation

| Task | API and required evidence |
| --- | --- |
| Create a new register | `$qso->logbook(path => $path, station => $call, log_id => $id, create => 1)`; exclusive creation |
| Reopen an existing register | `$qso->logbook(path => $path, station => $call)`; all existing records are verified |
| Archive a Session | `record_session`; finished observation, operator, UTC origin and RF metadata |
| Add a manually attested contact | `record`; unique ID, operator and ADIF field set |
| Rectify a contact | `correct`; current predecessor ID, reason and complete revised fields |
| Import contacts | `import_adif`; ADI/ADX bytes, import actor and unique ID prefix |
| Export current contacts | `export_adif(format => 'adi' or 'adx')`; original versions stay in the journal |
| Check retained history | `verify(checkpoint => $trusted)` and `records`; keep the checkpoint independently |

Full signatures, bounds and error codes are in the [Logbook API](../lib/Ham/QSO/Logbook.pm)
and [ADIF API](../lib/Ham/QSO/ADIF.pm). Importing an external log does not create
on-air Session events. An ADIF export is the current interchange view of contacts;
the journal preserves the evidence and correction history.

## Interchange contract

The implementation follows [ADIF 3.1.8](https://adif.org.uk/318/ADIF_318.htm),
released 2026-10-12. It reads and writes ADI and ADX, recognises the edition's 185
standard field identifiers, validates types and relevant enumeration/context
constraints, and handles USERDEF and typed APP fields. Unknown imported fields
are retained. Invalid or unsupported export data fails explicitly. Deprecated
fields/values are accepted on import and rejected on export rather than being
silently omitted. ADI lengths delimit data exactly, even when a value contains
text resembling another tag. ADX preserves international strings as UTF-8; ADI
refuses international fields rather than transliterating or dropping them.

`import_adif` adds explicit imported records to the station log, preserving the
source header and extension declarations. The application requires date, time,
mode and frequency/band for its station record; these requirements are a product
contract, not invented mandatory fields of the ADIF standard. Imports do not
establish that a transmission occurred. Batch input is validated before writing;
an I/O failure may leave a committed prefix, which must be checked before retry.

The complete import is validated and sized exactly before its first write. A
single durability barrier completes the batch before success is returned. Every
later read still rechecks the full content and hash chain. Input lines and UTF-8
output are bounded during processing. Changing working directory cannot redirect
an opened journal or break its installed schema references.

Extension names/types are normalized before persistence. Export numbers USERDEF
declarations deterministically and merges only those used by current contacts.
Incompatible application identities fail explicitly. Decimal ranges use exact
comparison, historical region entries retain every date/DXCC period, and malformed
nested XML cannot be interpreted as a second container or an extra contact.

ADX import uses optional XML::Parser 2.59+. Official schema validation additionally
uses XML::LibXML 2.0213+. Both are separately installed; the semantic engine and
journal do not need a native XML dependency. DTDs/external entities, nested field
markup and CDATA inside ADX fields are rejected. `validate_adx` applies the bundled
official export or generic import schema, together with application checks for
dates, duplicate fields and typed extensions. The official schemas' own documented
limitations remain relevant, including external datasets and historical details;
this is not a claim that every award, contact or legal circumstance is certified.

## Integrity and legal boundary

Journal format `ham-qso-logbook-1` uses canonical UTF-8 JSON, one envelope per LF
line. Sequence starts at one; the header fixes station identity and log ID.
Each envelope's hash is SHA-256 of the UTF-8 bytes of the format identifier,
a NUL byte and the canonical envelope without its hash field. The first
previous_hash is 64 zeroes; later entries name the preceding entry's hash.
Canonical encoding is Perl JSON::PP with canonical ordering and UTF-8 enabled.
This is a versioned application encoding, not a claim of RFC 8785 canonical JSON.

Every read and append checks the chain and record relationships. Incomplete,
altered or reordered records stop further appends. No recovery path silently
truncates a damaged record. A checkpoint `{log_id, station, sequence, hash}`
saved independently detects rollback of the anchored prefix after reopening.
The current object also remembers its last observed head.

An append-only API and hash chain alone cannot stop an administrator rewriting
the whole file or removing a clean suffix. Preserve checkpoints outside the
writer's control and deploy retention-locked/WORM storage, independent backups
and an appropriate identity/time-attestation process when those guarantees are
required. No WORM service, qualified signing, qualified timestamping or statutory
conservation service is configured by this module. Local OS time and a supplied
callsign do not authenticate an actor or establish a legally certified date.
Storage power-loss behaviour and parent-directory durability remain deployment
responsibilities. Whole-journal verification is bounded to 256 MiB and each
record to 16 MiB; larger installations need explicit archival policy.

ADIF is an interchange standard, not an Italian legal-conservation scheme.
The [Italian exercise rules](https://www.gazzettaufficiale.it/atto/serie_generale/caricaArticolo?art.codiceRedazionale=21A01607&art.dataPubblicazioneGazzetta=2021-03-22&art.flagTipoArticolo=1&art.idArticolo=12&art.idGruppo=2&art.idSottoArticolo=1&art.idSottoArticolo1=10&art.progressivo=0&art.versione=1)
remain distinct from this engineering integrity contract. No universal retention
period, qualified service requirement or complete legal certification is inferred
from the existence of an ADIF file or a successful integrity check.

## Source and licence record

Current [quality results](quality-results.json) record the ordinary, author,
coverage and installation checks, source hashes and measured improvements.
The [initial logbook verification](logbook-results.json) remains a separate,
dated source snapshot.

Implementation, synthetic fixtures and original guides use Artistic License 2.0.
The two official ADX schemas by Graham Smith retain their embedded **CC0 1.0**
dedication and unmodified bytes. [Source provenance](adif-sources.json) records
versions, URLs and SHA-256 hashes. The specification prose and official test-QSO
files are not redistributed. Separately installed XML libraries retain their own
Perl licensing terms and native dependency notices; they are not bundled here.
