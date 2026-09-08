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
  _why_ this item is here.

## Active queue

| Concept                                       | Context (what went wrong)                                                                                                                                                                                                                                                                                                              | Added      | Stage     | Next review |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | --------- | ----------- |
| Foreign keys do not create indexes (Postgres) | Predicted `Index Scan` for `WHERE user_id = 4242` because `user_id` is a FK; got `Parallel Seq Scan` over 5M rows. Likely carried over from MySQL/InnoDB, which does auto-index FK columns. **2026-09-01: passed unaided** on `tracks.album_id`. **2026-09-09: partial — reset.** Knew a FK column goes unindexed but named `users.id` as the unindexed one; it's the *referencing* side, `plays.user_id`, that lacks the index (`users.id` is the PK and indexed automatically). Direction is the substance of this item. Re-ask as: "in `plays.user_id REFERENCES users(id)`, which of the two columns has an index, and why that one?" | 2026-08-30 | 1 (reset) | 2026-09-11 |
| Reading a plan: per-loop numbers × `loops`    | Took 84ms as "the query is fine"; the plan had read all 5M rows. **Missed again 2026-09-01:** given `rows=1200 loops=3` / `Rows Removed by Filter: 98800`, answered 100,000 instead of (1200+98800)×3 = 300,000. `rows` and `Rows Removed` are per-loop averages; multiply by `loops`. **2026-09-09: passed unaided** — read own smoke-test plan cold and gave "3 loops, avg 38 rows each, 114 total", naming 2 workers + leader as the source of the 3. | 2026-08-30 | 2 | 2026-09-16 |
| Where "logged in" lives                       | Answered the state table with "Client (Cookie), survives server restart: Yes". A cookie usually holds only an identifier; the record giving it meaning lives server-side, and survival depends on whether that's process memory (no), Redis/DB (yes), or a signed token with no server half at all. Also: session cookie vs `Max-Age`. **Overdue since 2026-09-04; deferred twice (2026-09-08, 2026-09-09) for gate work — ask this first next session.** | 2026-09-01 | 1         | 2026-09-11 |
| Planner vs. executor vs. storage | At the Phase 0 gate (2026-09-08) replaced Postgres' internals with an invented "task queue" and a mislabelled "storage/cache task execution". Planner chooses the access path, executor runs it, storage serves pages from `shared_buffers`/disk. Directly blocks Phase 1, which is largely reading planner output. **Repaired 2026-09-09** — split cost/actual on the smoke-test plan correctly and unaided. | 2026-09-09 | 2 | 2026-09-16 |
| What the HTTP/app server does | At the gate, given the proxy's job ("decrypts request"); parsing raw bytes into a routed request went missing from the stack entirely. Decryption happens once, at the proxy. | 2026-09-09 | 1 | 2026-09-11 |
| Postgres connections fork a process | Explained the pool well (2026-09-09) but located the cost in TCP/TLS setup. The dominant cost is the postmaster forking a backend process with its own memory — the reason `max_connections` is ~100, not 10,000. Also: reused connections carry state (open transactions, `SET`, temp tables), which is a bug source, not only a speedup. | 2026-09-09 | 1 | 2026-09-11 |

## Retired

| Concept | Added | Retired |
| ------- | ----- | ------- |
