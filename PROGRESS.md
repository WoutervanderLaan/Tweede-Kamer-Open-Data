# PROGRESS.md — read first, every session

> **Tutor:** read this file and `REVIEW.md` before saying anything else, then
> open with the three-line status. The student assumes they remember nothing.

## Position

- **Phase:** 0 — Orientation
- **Module:** 0.2 — The life of one request (**A–C done**; diagram artifact
  complete after four revisions)
- **Next gate:** Phase 0 — **attempted 2026-09-08, NOT PASSED.** All four
  repair items cleared in discussion 2026-09-09. **Retake is the first thing
  next session**, and the student chose to defer it rather than retake in the
  same conversation — the right call, and it makes the result mean something.

## Cadence

- Budget: 4–6 h/week, irregular blocks; zero weeks happen and are fine.
- Anchor session: **Wednesday or Friday evening**, not guaranteed (student's
  own framing, 2026-08-30). Treat as a target, not a commitment — if two
  weeks pass with neither, revisit whether the anchor idea is working at all.
- Week of 2026-08-25: 4–6 h available.

## Gate 0 — retake checklist

Recite section C cold again. Four layers were wrong; everything else passed
and does not need re-proving. **All four repaired 2026-09-09 — but one at a
time, with the tutor naming the layer.** That is a weaker signal than the
gate itself: the artifact was already correct before the failed attempt, and
what collapsed was holding the whole stack at once. Assume nothing; run the
retake cold.

- [x] **Connection pool** — sits between app logic and Postgres, lends
      already-open connections. At the gate it was placed before the HTTP
      server and described as "distributes load" (that's a load balancer).
      **Repaired 2026-09-09** in discussion — strong answer, named the
      mechanism and the pool-exhaustion tradeoff unprompted.
- [x] **Planner and executor** (repaired 2026-09-09) — at the gate replaced with an
      invented "PostgreSQL task queue" and a mislabelled "storage/cache task
      execution". Planner decides *how* to get rows; executor carries it out;
      storage serves pages beneath both.
- [x] **HTTP/app server parses and routes** (repaired 2026-09-09) — at the gate given the
      proxy's job ("decrypts request"), leaving parsing absent from the stack
      entirely.
- [x] **Kernel socket precedes the reverse proxy** (repaired 2026-09-09) — the OS accepts the
      connection before any userspace process reads from it.

## Last session

- 2026-09-08/09 — Module 0.2 finished and **Phase 0 gate attempted and
  failed.** The diagram went through four revisions: column 4 was initially
  read as "where can this fail" rather than "where can this be answered from
  cache"; corrected, then TLS ownership corrected (twice), then the return
  path made non-mirror (serialization, cache population, decryption moved off
  the radio onto the device). Artifact ended strong. The gate recitation lost
  the middle of the stack — see the retake checklist. Caching material, the
  hardest-won part, held up cold in both directions. Also updated
  `capstone/README.md` from the live OData service document (39 entity sets;
  base URL verified — the brief's unverified-URL warning is now resolved).
  Repair pass afterwards cleared all four gate items; notable that the
  plan-reading review item, missed twice before, passed cold on the student's
  own smoke-test output. Weak spot that reappeared: which side of a foreign
  key carries the index.
- 2026-09-01 (~2 h, ran past midnight) — Module 0.1 worked end to end.
  Ran `python3 -m http.server`, dissected `curl -v`, found the process with
  `lsof`, killed it, served a request by hand with `nc`, filled in the
  where-state-lives table. Review: FK/index item passed, plan-reading item
  missed again. Two accidental findings from the student's own output —
  `.env` and `.git/` being served over HTTP, and cookies from other localhost
  apps arriving at a bare `nc` listener (cookies scope by host, not port).

## Next session — first thing to do

1. **Quiz "Where 'logged in' lives"** — overdue since 2026-09-04 and deferred
   twice for gate work. It is the only review item never actually asked.
2. **Then the Phase 0 gate retake, cold:** section C from memory — every
   layer, its job, its owner — followed by three "what breaks if this layer
   dies?" follow-ups, asked one at a time. The follow-ups were skipped on the
   failed attempt and have never been administered.
3. Pass → Phase 1 opens (SQL, the gym database). Fail → name the specific
   layers again and do not open Phase 1.

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

## Session log

*(Tutor appends one row per session, including short ones. "Next first step"
is the cold-start hook for the following session.)*

| Date | Hours | What happened | Next first step |
|---|---|---|---|
| 2026-08-27 | — | Course scaffolded by tutor. Decisions: capstone = Tweede Kamer vote tracker (official OData API); Postgres via Docker; anchor = weekday evening (day TBD); 4–6 h available this week. | Run `00-smoke-test.md` |
| 2026-08-30 | 0.5 | Exercise 00 done. `make up` clean, gym seeded (5M `plays`). Predictions: row count right (5M), both timings wrong. `EXPLAIN ANALYZE` introduced; predicted `Index Scan`, got `Parallel Seq Scan`, 1.67M rows discarded per worker. Corrected: FKs don't create indexes in Postgres. Baseline receipt for Module 1.7: **84ms** for `count(*) FROM plays WHERE user_id = 4242`. Anchor weekday: Wed or Fri, unguaranteed. | Start `01-a-server-is-a-process.md` |
| 2026-09-01 | ~2 | Module 0.1 A–D. HTTP server started, `curl -v` dissected line by line, `lsof -i :8000`, process killed, one response typed by hand into `nc`, state table filled and corrected. Taught: HTTP/1.0 vs 1.1 connection reuse, the connection 4-tuple and ephemeral ports, what dies with a process (binding, sockets, heap — not disk), status codes are for machines, session state as client identifier + server record. Two live findings from his own machine: `.env`/`.git/` served over HTTP, and cookies crossing ports on localhost. Review: FK/index passed → stage 2; plan-reading `loops` arithmetic missed → stage 1 again. | Start `02-trace-a-request.md` |
