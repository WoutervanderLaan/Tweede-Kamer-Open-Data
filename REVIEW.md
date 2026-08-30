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
| Foreign keys do not create indexes (Postgres) | Predicted `Index Scan` for `WHERE user_id = 4242` because `user_id` is a FK; got `Parallel Seq Scan` over 5M rows. Likely carried over from MySQL/InnoDB, which does auto-index FK columns. | 2026-08-30 | 1 | 2026-09-01 |
| Reading a plan: fast ≠ efficient | Took 84ms as "the query is fine". The plan showed 1.67M `Rows Removed by Filter` per worker × 3 — the whole table read to return 113 rows. Wall-clock hid the work done. | 2026-08-30 | 1 | 2026-09-01 |

## Retired

| Concept | Added | Retired |
|---|---|---|
