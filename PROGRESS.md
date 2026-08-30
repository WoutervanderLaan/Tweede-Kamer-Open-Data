# PROGRESS.md — read first, every session

> **Tutor:** read this file and `REVIEW.md` before saying anything else, then
> open with the three-line status. The student assumes they remember nothing.

## Position

- **Phase:** 0 — Orientation
- **Module:** 0.1 — A server is a process (**not started**; smoke test done)
- **Next gate:** Phase 0 — trace a request end to end, naming every layer

## Cadence

- Budget: 4–6 h/week, irregular blocks; zero weeks happen and are fine.
- Anchor session: **Wednesday or Friday evening**, not guaranteed (student's
  own framing, 2026-08-30). Treat as a target, not a commitment — if two
  weeks pass with neither, revisit whether the anchor idea is working at all.
- Week of 2026-08-25: 4–6 h available.

## Last session

- 2026-08-30 (30 min) — first real session. Environment up, gym seeded and
  answering queries. Exercise 00 (smoke test) done, predictions and results
  written to `phases/phase-0-orientation/notes/NOTES.md`. Met `EXPLAIN
  ANALYZE` for the first time; found out the hard way that a foreign key does
  not create an index in Postgres.

## Next session — first thing to do

1. `phases/phase-0-orientation/exercises/01-a-server-is-a-process.md` — start
   Module 0.1. Nothing to re-run first; the environment is up (`make up`).
2. Expect the two due `REVIEW.md` items to be quizzed before new material.

## Needs revisiting

- **2026-08-30 — foreign keys and indexes.** Believed a FK column is
  automatically indexed in Postgres. It is not (MySQL/InnoDB does; that's the
  likely source). Cleared by predicting `Seq Scan` vs `Index Scan` correctly,
  unaided, on a query the tutor picks. → `REVIEW.md`.
- **2026-08-30 — "fast" vs "efficient".** Read 84ms as evidence the query was
  fine; it had just scanned 5M rows across 3 workers. Cleared by reasoning
  about work done, not wall-clock, on a plan they haven't seen before.
- **Not a gap, a signpost:** the student flagged `playlists` /
  `playlist_tracks` as unintuitive. That's a junction table for a
  many-to-many relationship — untaught material, due properly in Phase 1
  (1.2 joins, 1.6 schema design). Do not answer it early; use it as the
  motivating example when 1.2 arrives.

## Claim ledger

Résumé-grade claims, added **only** when a phase gate is passed, each backed
by an artifact in this repo. Empty is the honest starting state.

| Claim | Evidence | Earned |
|---|---|---|

## Session log

*(Tutor appends one row per session, including short ones. "Next first step"
is the cold-start hook for the following session.)*

| Date | Hours | What happened | Next first step |
|---|---|---|---|
| 2026-08-27 | — | Course scaffolded by tutor. Decisions: capstone = Tweede Kamer vote tracker (official OData API); Postgres via Docker; anchor = weekday evening (day TBD); 4–6 h available this week. | Run `00-smoke-test.md` |
| 2026-08-30 | 0.5 | Exercise 00 done. `make up` clean, gym seeded (5M `plays`). Predictions: row count right (5M), both timings wrong. `EXPLAIN ANALYZE` introduced; predicted `Index Scan`, got `Parallel Seq Scan`, 1.67M rows discarded per worker. Corrected: FKs don't create indexes in Postgres. Baseline receipt for Module 1.7: **84ms** for `count(*) FROM plays WHERE user_id = 4242`. Anchor weekday: Wed or Fri, unguaranteed. | Start `01-a-server-is-a-process.md` |
