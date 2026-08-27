# Phase 1 — SQL and data modelling (the core)

Raw SQL in `psql` against the seeded **gym** database; from Module 1.6, also
your own **capstone** database. No ORM. Modules 1.1–1.8 and all gates:
`CURRICULUM.md`.

**Gate out of this phase:** design a schema from scratch, answer five
non-obvious questions in raw SQL, diagnose a slow query with EXPLAIN ANALYZE
— all without help.

## Layout

- `exercises/` — tutor-written drill sets, per module (`1.1-...`, `1.2-...`).
- `queries/` — **your** SQL, one file per exercise set, with your pre-run
  predictions as comments above each query. This convention is load-bearing:
  it's how a cold restart shows you how you used to think.
- `notes/` — your crib sheet, the EXPLAIN log (`explain-log.md`), lab logs
  from the transactions module.

## Ground rules

- `\timing on` always.
- Predict rows/duration in a comment *before* running. Wrong predictions
  stay in the file — they're the most useful lines in it.
- The gym data has deliberate warts. If a number looks impossible, it might
  be — finding out is the exercise.
