# REVIEW.md — spaced-repetition queue

Concepts that wobbled, scheduled to come back until they don't.

**How it runs (tutor maintains this):**

- When a concept is missed or shaky in a session, add a row: stage 1,
  next review ≈ 2 days out (or the next session, whichever is later).
- At session start, ask the **due** items — at most 3 — as concrete
  prediction questions ("what does this return", "how many queries fire"),
  never as definition recital.
- Answered well → advance a stage: **2d → 7d → 21d → 60d → retired.**
- Missed → back to stage 1, and re-teach briefly before new material.
- Keep rows short. The context column exists so a cold future session knows
  *why* this item is here.

## Active queue

| Concept | Context (what went wrong) | Added | Stage | Next review |
|---|---|---|---|---|
| Foreign keys do not create indexes (Postgres) | Predicted `Index Scan` for `WHERE user_id = 4242` because `user_id` is a FK; got `Parallel Seq Scan` over 5M rows. Likely carried over from MySQL/InnoDB, which does auto-index FK columns. **2026-09-01: passed unaided** on `tracks.album_id`. | 2026-08-30 | 2 | 2026-09-08 |
| Reading a plan: per-loop numbers × `loops` | Took 84ms as "the query is fine"; the plan had read all 5M rows. **Missed again 2026-09-01:** given `rows=1200 loops=3` / `Rows Removed by Filter: 98800`, answered 100,000 instead of (1200+98800)×3 = 300,000. `rows` and `Rows Removed` are per-loop averages; multiply by `loops`. | 2026-08-30 | 1 (reset) | 2026-09-04 |
| Where "logged in" lives | Answered the state table with "Client (Cookie), survives server restart: Yes". A cookie usually holds only an identifier; the record giving it meaning lives server-side, and survival depends on whether that's process memory (no), Redis/DB (yes), or a signed token with no server half at all. Also: session cookie vs `Max-Age`. | 2026-09-01 | 1 | 2026-09-04 |

## Retired

| Concept | Added | Retired |
|---|---|---|
