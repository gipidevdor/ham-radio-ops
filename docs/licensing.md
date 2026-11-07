# Licensing and copyright

[Overview](../README.md) · [Full project license](../LICENSE) · [Notices](../NOTICE) · [Provenance record](license-provenance.json)

## Project material

Copyright (c) 2026 Giacomo Picchiarelli. Project code, original documentation
and original synthetic fixtures use **Artistic License 2.0**, matching the
sibling distributions. The complete license is distributed unchanged in LICENSE.
Its Perl Foundation copyright concerns the license document, not authorship
of Ham::QSO. The license's permissions and disclaimers remain intact.

The rights review is dated **2026-11-07**. The machine-readable record identifies
reused project files, source revision/paths/hashes, original fixtures, external
publications and directly invoked tools. It records the reviewed contents;
it is not a blanket permission to import external material.

## Reused project code and theme

Utility code, distribution/author checks, documentation rendering and CSS,
formatter/critic settings and CI configuration are reused or adapted from
[Ham::CW at the recorded reference revision](https://github.com/gipidevdor/ham-cw/tree/89a575951778181512c082e74e42939a24878d0b),
by the same author, under its [Artistic License 2.0](https://github.com/gipidevdor/ham-cw/blob/89a575951778181512c082e74e42939a24878d0b/LICENSE).
The reference is a pinned source comparison, not a claim that adapted files
remain byte-identical. NOTICE describes namespace, behaviour and packaging
adaptations. Original notices are retained, including the Ham::CW CSS header.
Ham::RTTY is a style/API reference and an optional separately installed codec.
Neither optional codec implementation is copied into this distribution.

## Publications cited by the implementation

[IARU EOP, fourth edition v4.2.0](https://www.iaru-r1.org/on-the-air/eop/) is
copyright IARU Region 1, 2026, under
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode.en).
The repository contains original rule descriptions and implementation code,
with source sections recorded in the profiles. It does not include publication
prose, translations, figures, tables or copied example transcripts. The root
project license does not apply to the linked publication. If protected material
is reproduced or adapted later, retain appropriate attribution, source/license
links and modification notices, and meet applicable ShareAlike terms.

[ITU-R M.1677-1](https://www.itu.int/rec/R-REC-M.1677/en) and other ITU sources
retain their [own copyright and publication conditions](https://www.itu.int/en/Pages/copyright.aspx).
Free access is not treated as an unrestricted redistribution licence. This
package links those sources; it does not bundle their documents or reproduce
their character tables. Italian official acts are cited through the official
links in [standards and provenance](standards.md). Their source documents are
not incorporated into the package.

Publication names are descriptive references. No endorsement, certification
or right to use an organisation's logo or other branding is implied.

## Fixtures, media and generated pages

The corpus JSON and full-session fixture are original synthetic examples under
the project license. Runtime test WAVs are freshly generated in temporary
locations; no received-radio recording from a sibling corpus is copied here.
There are no bundled third-party photographs, audio clips, logos or fonts.
The site uses the shared original theme and system fonts. Generated pages
retain a visible project-license link and a link to this rights/credits page.

## Dependencies and CI tools

These are separate installations or invocations, not code relicensed or
redistributed by this package. Their exact upstream notices control:

| Component | Reviewed upstream licence | Use here |
| --- | --- | --- |
| Ham::CW / Ham::RTTY | Artistic License 2.0 | Optional installed codecs |
| Official `actions/*` used by the workflows | MIT | Checkout, artifacts and Pages deployment |
| `shogo82148/actions-setup-perl` | MIT | CI Perl setup |
| `vmactions/freebsd-vm`, `vmactions/solaris-vm` | MIT | Supplementary VM checks |
| `cygwin/cygwin-install-action` | GNU GPL version 3; see upstream notice | External Cygwin setup action |
| cpanminus | Perl 5 terms: Artistic License or GNU GPL version 1 or later | Pinned external installer |
| Gitleaks, actionlint, zizmor | MIT | Separately installed checks |

The [provenance record](license-provenance.json) links each pinned tool revision
and its own licence. Other CPAN packages, runtime dependencies, VM images and
OS packages retain the notices shipped in their respective distributions.
This inventory is not a transitive dependency SBOM. It grants no right to
repackage those components or their dependencies under the root licence.

## Before adding external material

Record the creator/rightsholder, exact source and revision, applicable licence
or permission, and modifications before inclusion. Preserve required notices
and include licence text when redistribution requires it. Attribute any adapted
work and honour applicable copyleft/ShareAlike terms for that material. Keep
materials with different terms clearly identified. Do not import an unlicensed
recording, document, image, font or code fragment on the assumption that being
publicly downloadable makes it reusable.

The offline author checks protect the verbatim project licence, the recorded
verbatim imports, inclusion of notices/provenance in MANIFEST, and review records
for pinned CI actions. New bundled media or standards documents require a changed
rights policy and explicit review. These checks support that review; they cannot
prove authorship, permission or legal compliance for arbitrary future additions.
