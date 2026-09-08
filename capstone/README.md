# Capstone — Tweede Kamer voting tracker

One project, carried through every phase: a backend that imports, stores, and
serves the voting record of the Dutch House of Representatives — who voted for
what, which motions passed by how much, and which parties actually vote
together.

**Real schema:** parties, MPs, seat history, motions, decisions, votes — full
of time-varying relationships (MPs change parties; parties split) and messy
official data.
**Real external data:** the official parliamentary open-data API (below).
**Real user:** you, at minimum. The Phase 3 API is designed so a React Native
client could sit on it — your home turf, their backend. Er, _your_ backend.

## The data source

The Tweede Kamer publishes its information model as an OData v4 API. No API
key, public data.

- Portal / documentation: <https://opendata.tweedekamer.nl>
- OData v4 base URL: `https://gegevensmagazijn.tweedekamer.nl/OData/v4/2.0/`

> **Verified 2026-09-03** by `curl`-ing the service document from the
> student's machine (Phase 0, exercise 02). The base URL above is correct and
> returns 39 entity sets. Re-check if imports start 404-ing — the Dutch
> government does reorganise URLs.

Entities this project cares about (names copied from the live service
document — the API's own Dutch spelling):

| Entity                                             | What it is                                                                   |
| -------------------------------------------------- | ---------------------------------------------------------------------------- |
| `Fractie`                                          | A parliamentary party/group                                                  |
| `FractieZetel`                                     | A seat belonging to a party                                                  |
| `FractieZetelPersoon`                              | Who held a party seat, and between which dates                               |
| `FractieZetelVacature`                             | A party seat standing empty — the gap in the occupancy timeline              |
| `Persoon`                                          | A person — MPs among them                                                    |
| `Zaak`                                             | A "case" — motions (soort _Motie_), bills, amendments                        |
| `ZaakActor`                                        | A person/party's role on a case — submitter, co-signer                       |
| `Besluit`                                          | A decision taken on a case                                                   |
| `Stemming`                                         | A vote cast on a decision — usually per party, sometimes per MP (hoofdelijk) |
| `Agendapunt`                                       | The agenda item linking an activity to the cases and decisions on it         |
| `Document`, `DocumentActor`, `DocumentVersie`      | The paperwork behind a case, its authors, and its revisions                  |
| `Activiteit`, `ActiviteitActor`, `Vergadering`     | Debates and sittings, and who took part, if we go there                      |

The service document lists 39 sets in all. The rest are out of scope for the
voting tracker, but worth knowing exist:

- **People, in detail:** `PersoonContactinformatie`, `PersoonGeschenk`,
  `PersoonLoopbaan`, `PersoonNevenfunctie`, `PersoonNevenfunctieInkomsten`,
  `PersoonOnderwijs`, `PersoonReis` — gifts, side jobs and their income,
  education, trips. Public register material.
- **Committees:** `Commissie`, `CommissieContactinformatie`,
  `CommissieZetel`, and four occupancy sets that mirror the `FractieZetel`
  pattern — `CommissieZetelVastPersoon`, `CommissieZetelVastVacature`,
  `CommissieZetelVervangerPersoon`, `CommissieZetelVervangerVacature`
  (permanent vs. substitute members).
- **Publication and reporting:** `DocumentPublicatie`,
  `DocumentPublicatieMetadata`, `Kamerstukdossier`, `Verslag`.
- **Logistics:** `Zaal`, `Reservering` — rooms and their bookings.
- **Commitments:** `Toezegging`, `ToegezegdAan` — ministerial promises and
  who they were made to.

Note the shape that repeats: an entity, its seats, and separate sets for
_person-held_ and _vacant_ seats. Both `Fractie` and `Commissie` model
membership that way. That is the API telling you how it thinks about
time-varying relationships — and it is a decision you will have to make
yourself in Module 1.6.

Useful properties of this dataset, discovered the hard way by everyone who
touches it: votes are usually recorded _per party_ with seat counts, not per
MP; people move between parties; parties appear and disappear; text fields
are inconsistently filled. All of that is modelling material, not noise.

## What gets built here, when

| Phase | Artifact in this directory                                                                                      |
| ----- | --------------------------------------------------------------------------------------------------------------- |
| 1.6   | `schema/` — your DDL, designed from scratch; `QUESTIONS.md` — five non-obvious questions the schema must answer |
| 2.1   | `importer/` — Python, `httpx` + `psycopg`, re-runnable upserts                                                  |
| 2.2   | `api/` — Django project adopting your schema                                                                    |
| 3.x   | the API contract (written first), then DRF implementation + auth                                                |
| 4.x   | Dockerfile, live deploy, `OPERATIONS.md`, nightly Celery import                                                 |
| 5.x   | the test suite that guards all of it                                                                            |

Nothing in this directory is scaffolded for you. That's the point.
