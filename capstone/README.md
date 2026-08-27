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
client could sit on it — your home turf, their backend. Er, *your* backend.

## The data source

The Tweede Kamer publishes its information model as an OData v4 API. No API
key, public data.

- Portal / documentation: <https://opendata.tweedekamer.nl>
- OData v4 base URL: `https://gegevensmagazijn.tweedekamer.nl/OData/v4/2.0/`

> **Verify before trusting:** this brief was written without live access to
> the API (the setup environment blocked the host). Exercise 02 in Phase 0
> has you `curl` the service document from your own machine — confirming the
> base URL and entity list is literally your first API task. If something
> moved, fix it here.

Entities this project cares about (Dutch names are the API's own):

| Entity | What it is |
|---|---|
| `Fractie` | A parliamentary party/group (seats, dates) |
| `Persoon` | A person — MPs among them |
| `FractieZetel` + occupancy | A seat within a party, and who held it when |
| `Zaak` | A "case" — motions (soort *Motie*), bills, amendments |
| `Besluit` | A decision taken on a case |
| `Stemming` | A vote cast on a decision — usually per party, sometimes per MP (hoofdelijk) |
| `Document` | The paperwork behind a case |
| `Activiteit` / `Vergadering` | Debates and sittings, if we go there |

Useful properties of this dataset, discovered the hard way by everyone who
touches it: votes are usually recorded *per party* with seat counts, not per
MP; people move between parties; parties appear and disappear; text fields
are inconsistently filled. All of that is modelling material, not noise.

## What gets built here, when

| Phase | Artifact in this directory |
|---|---|
| 1.6 | `schema/` — your DDL, designed from scratch; `QUESTIONS.md` — five non-obvious questions the schema must answer |
| 2.1 | `importer/` — Python, `httpx` + `psycopg`, re-runnable upserts |
| 2.2 | `api/` — Django project adopting your schema |
| 3.x | the API contract (written first), then DRF implementation + auth |
| 4.x | Dockerfile, live deploy, `OPERATIONS.md`, nightly Celery import |
| 5.x | the test suite that guards all of it |

Nothing in this directory is scaffolded for you. That's the point.
