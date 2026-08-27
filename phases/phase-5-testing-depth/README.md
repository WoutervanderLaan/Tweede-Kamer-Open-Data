# Phase 5 — Testing and depth (ongoing)

Starts alongside late Phase 4; never really ends.

- **5.1** pytest + pytest-django, the DRF test client, model-bakery,
  tests that exercise the real database, `assertNumQueries` as an N+1
  tripwire, CI. The suite lives in `capstone/`.
- **5.2** Systems reading, spaced: DDIA (ch. 1–3, 5, 7) mapped to things you
  built; use-the-index-luke.com; the Postgres MVCC docs; one incident
  post-mortem per month, retold in your own words.

## Layout

- `exercises/` — tutor-written (bug-hunt branches, "write the missing test").
- `notes/` — yours: reading notes, one page per DDIA chapter, each ending
  with "where this bit me in my own project".
