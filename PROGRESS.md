# PROGRESS.md — read first, every session

> **Tutor:** read this file and `REVIEW.md` before saying anything else, then
> open with the three-line status. The student assumes they remember nothing.

## Position

- **Phase:** 1 — SQL and data modelling (**opened 2026-09-16**)
- **Module:** 1.1 — Reading a table honestly (not started; no exercise
  written yet)
- **Next gate:** Module 1.1 — predict row count and NULL behaviour of six
  tutor-written queries before running; ≥5 correct, misses explained back.
- **Phase 0 gate:** failed 2026-09-08, **PASSED on cold retake 2026-09-16.**

## Cadence

- Budget: 4–6 h/week, irregular blocks; zero weeks happen and are fine.
- Anchor session: **Wednesday or Friday evening**, not guaranteed (student's
  own framing, 2026-08-30). Treat as a target, not a commitment — if two
  weeks pass with neither, revisit whether the anchor idea is working at all.
- Week of 2026-08-25: 4–6 h available.

## Gate 0 — result (retake, 2026-09-16)

**PASSED.** Section C recited cold as a table: every layer present, in order,
correct ownership, nothing invented. All four layers that failed on
2026-09-08 (pool, planner/executor, app server parsing, kernel socket before
proxy) were correct without prompting. Three follow-ups administered for the
first time:

1. *nginx dies, app still on 127.0.0.1:8000* — outcome right (network error,
   not a 502), but said the request "stops at the nginx layer". It stops at
   the **kernel**: nothing bound to 443 → RST → connection refused; TLS and
   HTTP never happen. → `REVIEW.md`.
2. *Postgres killed; one previously-requested URL, one fresh* — strongest
   answer: explicitly refused to assume an earlier request implies a cache.
   Didn't name *which* layer could hold the cache (proxy cache vs app cache).
3. *`kill -9` the app mid-query* — nginx → 502; pool dies with the process
   *if in-process* (noted PgBouncer-style external pools as the exception,
   unprompted). Correct.

Flaws that didn't fail the gate: return-path kernel socket described as
"terminates open connection" (wrong — keep-alive; a process decides to
close, the kernel executes it) → `REVIEW.md`. Planner and executor collapsed
into one line — fine for Phase 0, will be pulled apart in 1.7.

## Last session

- 2026-09-16 (~1 h) — **Phase 0 gate passed on cold retake** (details
  above). Review: "where 'logged in' lives" finally asked — both directions
  correct (in-memory store dies with the process; session cookie dies with
  the browser while the Postgres row survives, orphaned but still valid).
  FK direction passed cold and verified against a live `EXPLAIN ANALYZE`;
  one slip — suggested `Index Only Scan` for `SELECT *`, impossible when the
  index lacks the selected columns (untaught 1.7 material, not queued).
- 2026-09-08/09 — Module 0.2 finished and **Phase 0 gate attempted and
  failed.** The diagram went through four revisions: column 4 was initially
  read as "where can this fail" rather than "where can this be answered from
  cache"; corrected, then TLS ownership corrected (twice), then the return
  path made non-mirror (serialization, cache population, decryption moved off
  the radio onto the device). Artifact ended strong. The gate recitation lost
  the middle of the stack (retaken and passed 2026-09-16 — see Gate 0 result). Caching material, the
  hardest-won part, held up cold in both directions. Also updated
  `capstone/README.md` from the live OData service document (39 entity sets;
  base URL verified — the brief's unverified-URL warning is now resolved).
  Repair pass afterwards cleared all four gate items; notable that the
  plan-reading review item, missed twice before, passed cold on the student's
  own smoke-test output. Weak spot that reappeared: which side of a foreign
  key carries the index.

## Next session — first thing to do

1. **Review, max 3, pick the oldest-due first:** the two new stage-1 items
   (kernel refuses when nothing listens; responses don't close keep-alive
   connections), then "Postgres connections fork a process" (overdue since
   2026-09-11, not yet asked).
2. **Open Module 1.1.** Tutor writes
   `phases/phase-1-sql/exercises/01-reading-a-table-honestly.md` at session
   start (not written yet — do it before teaching, keep it 2-hour sized).
   First thing the student does: `make psql`, `\dt`, `\d users`, and predict
   a row count before running `count(*)`.

## Needs revisiting

- ~~**2026-08-30 — foreign keys and indexes.**~~ **Cleared 2026-09-01:**
  predicted `Seq Scan` on `tracks.album_id` unaided and named the cause —
  no index exists, `REFERENCES` creates a constraint. Still cycling in
  `REVIEW.md` at stage 2.
- **2026-08-30 — "fast" vs "efficient" / reading a plan.** *Missed again
  2026-09-01.* Given `rows=1200 loops=3, Rows Removed by Filter: 98800`,
  answered 100,000 rows examined. The per-loop figures must be multiplied by
  `loops`: (1200 + 98800) × 3 = 300,000. Same arithmetic as the 1.67M × 3 = 5M
  from the smoke test. Cleared by getting the multiplication right cold.
- **2026-09-01 — where state lives, rows 3 and 4.** Cart initially placed in a
  cookie (4KB cap; sent on every request). Page HTML now answered only as the
  rendered DOM — the fuller truth is that it exists in two places at once,
  source on the server, rendered copy in the browser. Cleared by reproducing
  the four-row table cold at the Phase 0 gate.
- **Not a gap, a signpost (2026-09-04):** while updating `capstone/README.md`
  from the live service document, the student noted that the API stores seat
  vacancies as their own rows (`FractieZetelVacature`, and the same shape for
  committees) rather than leaving gaps between occupancy rows. Asked why,
  they gave the query-efficiency reason — correct but secondary. The primary
  reason (a gap cannot distinguish real emptiness from missing data) was
  given. **Do not pursue the invariant/constraint question early** — that is
  Module 1.6 material and was withdrawn. Use this as the motivating example
  when temporal modelling arrives. Related: *gaps and islands*, due with
  window functions in Phase 1.
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
| Can trace an HTTP request end to end (DNS → kernel → TLS-terminating proxy → app → pool → Postgres and back), name each layer's job and owner, and reason about failure when any single layer dies | `phases/phase-0-orientation/notes/request-lifecycle.md`; Phase 0 gate retake 2026-09-16 | 2026-09-16 |

## Session log

*(Tutor appends one row per session, including short ones. "Next first step"
is the cold-start hook for the following session.)*

| Date | Hours | What happened | Next first step |
|---|---|---|---|
| 2026-08-27 | — | Course scaffolded by tutor. Decisions: capstone = Tweede Kamer vote tracker (official OData API); Postgres via Docker; anchor = weekday evening (day TBD); 4–6 h available this week. | Run `00-smoke-test.md` |
| 2026-08-30 | 0.5 | Exercise 00 done. `make up` clean, gym seeded (5M `plays`). Predictions: row count right (5M), both timings wrong. `EXPLAIN ANALYZE` introduced; predicted `Index Scan`, got `Parallel Seq Scan`, 1.67M rows discarded per worker. Corrected: FKs don't create indexes in Postgres. Baseline receipt for Module 1.7: **84ms** for `count(*) FROM plays WHERE user_id = 4242`. Anchor weekday: Wed or Fri, unguaranteed. | Start `01-a-server-is-a-process.md` |
| 2026-09-01 | ~2 | Module 0.1 A–D. HTTP server started, `curl -v` dissected line by line, `lsof -i :8000`, process killed, one response typed by hand into `nc`, state table filled and corrected. Taught: HTTP/1.0 vs 1.1 connection reuse, the connection 4-tuple and ephemeral ports, what dies with a process (binding, sockets, heap — not disk), status codes are for machines, session state as client identifier + server record. Two live findings from his own machine: `.env`/`.git/` served over HTTP, and cookies crossing ports on localhost. Review: FK/index passed → stage 2; plan-reading `loops` arithmetic missed → stage 1 again. | Start `02-trace-a-request.md` |
| 2026-09-08/09 | ~3 | *(Row backfilled 2026-09-16 — omitted at the time.)* Module 0.2 B–C: OData service verified live, `capstone/README.md` updated; request-lifecycle diagram through four revisions. **Phase 0 gate attempted, failed** — pool, planner/executor, app-server parsing, kernel socket. All four repaired in discussion. Review: plan `loops` arithmetic passed → stage 2; FK direction reset. | Quiz "logged in" item, then gate retake cold |
| 2026-09-16 | ~1 | **Phase 0 gate passed** on cold retake: full stack recited, three "what breaks" follow-ups (nginx dies / Postgres dies / app `kill -9`). Two defects queued: request stops at the *kernel* when nothing listens; return path doesn't close keep-alive connections. Review: "logged in" passed → 2, FK direction passed cold (verified with live `EXPLAIN ANALYZE`) → 2. **Phase 1 open.** | Review 3 items, then tutor writes and starts Module 1.1 exercise 01 |
