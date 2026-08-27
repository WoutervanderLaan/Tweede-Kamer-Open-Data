# Phase 2 — Python, then Django's ORM as a leaky abstraction

Locked until the Phase 1 gate is passed. If you're reading this early because
Django feels more productive than SQL drills: that feeling is the exact trap
this course's ordering exists to beat. Back to `phases/phase-1-sql/`.

Modules (details in `CURRICULUM.md`):
- **2.1** Python for a TypeScript engineer — differences, not basics.
  Builds the capstone importer (`capstone/importer/`).
- **2.2** Django's ORM with eyes open — laziness, N+1, `select_related` vs
  `prefetch_related`, hand-written migrations, `transaction.atomic`,
  `select_for_update`. Builds `capstone/api/` over *your* schema.

## Layout

- `exercises/` — tutor-written.
- `notes/` — yours: the TS↔Python phrasebook you'll build in 2.1, predicted
  SQL vs actual for every queryset in 2.2.

Python code for the capstone lives in `capstone/`, not here — this directory
is for exercises and notes only.
