# Curriculum — Backend Engineering, Self-Directed

**Student:** frontend engineer (~4y React Native / TypeScript). Python: reads it,
has written very little. SQL: basic SELECT + JOIN. Backend concepts: theoretical.

**Goal:** genuinely comfortable owning backend work — schema design, real
queries, building and securing an API, deploying and operating it. The bar is
*credible backend engineer in a full-stack role*, not backend specialist. Every
claim of skill must be backed by something built in this repo.

**The spine:** one capstone — a Tweede Kamer voting tracker built on the
official parliamentary open-data API (see `capstone/README.md`) — carried
through every phase. Phase 1 also uses a second, pre-seeded practice database
("the gym", ~6.5M rows) so that bad queries are *visibly* slow.

**Time model:** 4–6 h/week in irregular blocks, zero weeks happen. Durations
below are honest estimates at that pace, but **gates decide advancement, not
the calendar**. A gate is pass/fail, administered by the tutor, and failing it
means staying — with a named list of what's missing.

---

## How a module runs

Every module in this file lists **Learn** (concepts), **Build** (the artifact
that proves it), and **Gate** (pass/fail exit check). Exercises are written by
the tutor into `phases/<phase>/exercises/` during sessions; solutions are
written by the student, always. Session mechanics — the three files that run
the course, predict-before-run, the review queue — are in `CLAUDE.md`.

---

## Phase 0 — Orientation (1–2 weeks)

What a server process actually is, stateless HTTP, where state lives, and the
full lifecycle of one request. Nothing here is graded on code.

### 0.1 A server is a process
- **Learn:** a server is an ordinary process listening on a port; sockets,
  localhost vs the network; one process, many clients; what dies when the
  process dies; stateless HTTP; the places state can actually live (database,
  cache, cookie, token, client memory) and what each costs.
- **Build:** run a throwaway HTTP server on your Mac, talk to it with `curl`
  and a browser; serve one request *by hand* with `nc` so you've typed an HTTP
  response yourself; written answers in `phases/phase-0-orientation/notes/`.
- **Gate:** explain, unaided, what exactly stopped existing when you killed
  the server — and where a "logged-in user" would have lived, given that it
  didn't.

### 0.2 The life of one request
- **Learn:** DNS → TCP → TLS → HTTP request → reverse proxy → application
  process → connection pool → database → response, and what each layer adds;
  request/response anatomy (`curl -v`); status code families; cookies vs
  headers; where the backend engineer's responsibility starts and stops.
- **Build:** dissect real requests with `curl -v`, including your first calls
  to the Tweede Kamer OData API (this doubles as verifying the capstone's data
  source from your machine); a request-lifecycle diagram for the future
  capstone, every layer named, kept in `notes/`.
- **Gate (= phase gate):** trace a request end to end and name every layer —
  from "the RN app calls `GET /api/motions`" to the row leaving Postgres and
  back — then answer three "what breaks if *this* layer dies?" follow-ups.

---

## Phase 1 — SQL and data modelling (2–3 months) — THE CORE

Raw SQL in `psql` against local Postgres. No ORM, no GUI query builder. Gym
database for drills; the capstone schema is born in 1.6.

### 1.1 Reading a table honestly
- **Learn:** SELECT/WHERE/ORDER BY/LIMIT/DISTINCT; expressions and aliases;
  `\d`, `\dt`, `\timing`; NULL and three-valued logic (`= NULL` vs `IS NULL`,
  NULLs in `NOT IN`, in comparisons, in `ORDER BY`); why `DISTINCT` is usually
  a confession that you don't understand your data.
- **Build:** first drill set against the gym; a personal `psql` crib sheet in
  `phases/phase-1-sql/notes/`.
- **Gate:** predict the row count and NULL behaviour of six tutor-written
  queries *before* running them; at least five correct, misses explained back.

### 1.2 Joins
- **Learn:** INNER/LEFT/RIGHT/FULL; a join as row multiplication, not lookup;
  join conditions vs filters (`ON` vs `WHERE` on a LEFT JOIN — the classic);
  semi-joins and anti-joins (`EXISTS`, `NOT EXISTS`, `LEFT ... IS NULL`);
  self-joins; how row counts explode and when duplicates mean a bad join key.
- **Build:** drill set: artists with no albums, users who never played a
  premium track, playlist overlaps — each with a predicted row count first.
- **Gate:** given three joins, state before running: row count upper bound,
  why each is/isn't an anti-join, and what happens to the count when the
  filter moves between `ON` and `WHERE`.

### 1.3 Aggregation
- **Learn:** GROUP BY as partitioning; aggregate functions; HAVING vs WHERE;
  `count(*)` vs `count(col)` vs `count(DISTINCT col)`; conditional aggregation
  with `FILTER`; division-by-zero and NULL traps in averages (the gym's
  zero-duration tracks live here); group-then-join vs join-then-group.
- **Build:** drill set: listen-through rates, monthly active users, revenue-ish
  rollups per country — including one query that is subtly wrong until the
  zero-duration wart is handled.
- **Gate:** write four aggregate queries cold; explain for one of them why
  grouping before joining changes the answer.

### 1.4 Subqueries and CTEs
- **Learn:** scalar/row/table subqueries; correlated vs uncorrelated and what
  correlation costs; `IN` vs `EXISTS` vs `ANY`; CTEs for legibility;
  `LATERAL`; when a CTE is just a subquery with a name and when it changes
  the plan.
- **Build:** rewrite three of your own earlier queries two ways each
  (subquery ↔ CTE ↔ join where possible) and say which you'd ship and why.
- **Gate:** take a gnarly nested tutor query, explain what it returns without
  running it, then restructure it to be readable without changing results.

### 1.5 Window functions
- **Learn:** `OVER`, `PARTITION BY`, frame vs partition; `row_number`/`rank`/
  `dense_rank`; `lag`/`lead`; running totals; top-N-per-group (the interview
  classic); windows vs GROUP BY — when each collapses rows and when not.
- **Build:** drill set: each user's top track, play-count deltas month over
  month, "first play ever per user" three different ways.
- **Gate:** top-N-per-group cold, correct on the first run, plus one lag/lead
  query — and state for each *how many rows* survive before executing.

### 1.6 Schema design — the capstone schema is born
- **Learn:** primary keys (natural vs surrogate, when composite); foreign keys
  and what they actually enforce; nullability as a design statement;
  uniqueness constraints as business rules; normalisation 1NF→3NF pragmatically;
  when to break normal form on purpose and what it costs; modelling time
  (things that change: party membership!); CHECK constraints; why "just add a
  JSON column" is usually deferred design debt.
- **Build:** the capstone schema v1, designed from the actual shapes of the
  Tweede Kamer API (parties, MPs, seat history, motions, decisions, votes) —
  DDL in `capstone/schema/`, hand-inserted sample rows, plus
  `capstone/QUESTIONS.md`: five non-obvious questions the schema must answer
  (agreement between parties, margin of passage, MP attendance, …).
- **Gate:** defend the schema under tutor critique: every key choice, every
  nullable column, every constraint. Indefensible choices get redesigned —
  that's not failure, that's the module.

### 1.7 Indexes and EXPLAIN ANALYZE
- **Learn:** heap + B-tree mental model; what an index costs (writes, space,
  planner options); reading `EXPLAIN (ANALYZE, BUFFERS)`: seq/index/bitmap
  scans, nested loop vs hash vs merge join, rows expected vs actual; why the
  planner ignores your index (low selectivity, functions on the column, type
  mismatches, stale statistics, tiny tables); composite index column order;
  partial and covering indexes; `pg_stat_statements`; why the gym's foreign
  keys being unindexed hurt you all phase.
- **Build:** make five slow gym queries fast, with before/after plans and a
  one-line explanation each, in `phases/phase-1-sql/notes/explain-log.md`;
  build one index the planner refuses to use and explain the refusal.
- **Gate:** given a slow query you haven't seen, diagnose it from the plan
  and fix it — or prove the fix isn't an index — without help.

### 1.8 Transactions and concurrency
- **Learn:** what ACID actually promises; `BEGIN/COMMIT/ROLLBACK`; isolation
  levels (read committed → repeatable read → serializable) and the anomalies
  each allows; the lost update, produced live in two psql terminals; row
  locks, `SELECT ... FOR UPDATE`; deadlocks — cause one, read the error;
  idempotency as the application-level answer.
- **Build:** a written lab log of the lost update, the fix, and the deadlock,
  in `phases/phase-1-sql/notes/` — reproducible on demand.
- **Gate:** reproduce a lost update unprompted, fix it two ways (lock vs
  isolation level), and say what each fix costs under load.

### Phase 1 gate (the big one)
1. Design a schema from scratch for a fresh domain the tutor supplies —
   defended live.
2. Answer the five `capstone/QUESTIONS.md` questions in raw SQL against real
   imported data (a first cut of the importer arrives early in Phase 2; the
   gate may run against hand-loaded sample data if taken before then).
3. Diagnose and fix a slow query using EXPLAIN ANALYZE, no help, thinking
   aloud.

---

## Phase 2 — Python, then Django's ORM as a leaky abstraction (1–2 months)

### 2.1 Python for a TypeScript engineer
- **Learn:** *differences, not basics* — `uv` and virtualenvs (what problem
  they solve that `node_modules` solves differently); project layout and
  packaging (`pyproject.toml`); the type system vs TS (gradual, structural
  `Protocol`s, `mypy`); dataclasses; dict/list/tuple/set idioms and
  comprehensions vs `map`/`filter`; mutability and the default-argument trap;
  iterators and generators (lazy like your future querysets); exceptions as
  control flow vs error values; context managers (`with` — your `finally` on
  rails); dunder protocols vs interfaces; `ruff`, `pytest` first contact;
  where async Python lives and why Django mostly isn't it.
- **Build:** **the capstone importer** — a real Python project (`uv`, `ruff`,
  `mypy`, `pytest`) that pulls parties, MPs, seats, motions, decisions and
  votes from the Tweede Kamer OData API with `httpx`, handles pagination,
  and upserts into *your* Phase 1 schema with `psycopg` (raw SQL — the ORM
  hasn't earned its place yet). Re-runnable without duplicating rows.
- **Gate:** explain your own importer line by line — including every `ON
  CONFLICT`, every type hint, and what happens when the API hands you a
  malformed row — then add a tutor-requested feature live.

### 2.2 Django's ORM, eyes open
- **Learn:** project/app anatomy and settings; models mapped onto the schema
  *you* designed (adopting an existing database — `inspectdb`, `managed`,
  `--fake-initial` — a real-world skill most tutorials skip); queryset
  laziness and exactly when SQL fires; the N+1 disease, diagnosed with
  `connection.queries`, cured with `select_related` (JOIN) vs
  `prefetch_related` (second query) — and why they're not interchangeable;
  `annotate`/`aggregate`/`Subquery`/`Exists` mapped back to the Phase 1 SQL
  they compile to; `values`/`only`/`bulk_create`; migrations: autogenerated,
  hand-written, data migrations, and what each one locks on a populated
  table; `transaction.atomic`; `select_for_update`; `get_or_create` races.
- **Build:** Django project over the capstone database; the Phase 1 five
  questions re-answered as querysets, each with its predicted SQL written
  down *before* checking; one hand-written migration executed against your
  populated capstone data.
- **Gate (= phase gate):** for any queryset the tutor writes, predict the
  SQL and the query *count* before running; design the migration plan for
  adding a NOT NULL column to a large populated table, including the naive
  plan's failure mode.

---

## Phase 3 — API design and auth (1–1.5 months)

### 3.1 The contract comes first
- **Learn:** resources and verbs; status codes you can defend (200/201/204,
  301/304, 400/401/403/404/405/409/410/422, 429, 500/503); idempotency and
  idempotency keys; pagination — offset vs cursor, and why you already know
  from 1.7 what's wrong with deep OFFSET; filtering and sorting conventions;
  versioning options and their costs; one consistent error shape (RFC 9457);
  validation at the boundary as a security posture, not a nicety.
- **Build:** the complete capstone API contract — endpoints, params, status
  codes, error bodies, pagination — as a document in `capstone/api/`,
  written *before* any implementation.
- **Gate:** defend every status code and every design choice in the contract
  under tutor cross-examination; revise what doesn't survive.

### 3.2 Django REST Framework
- **Learn:** serializers as the validation boundary; ViewSets vs APIViews and
  when the abstraction helps vs hides; routers; permissions classes;
  pagination classes (cursor pagination for real this time); filtering;
  throttling; `drf-spectacular` so the contract and the OpenAPI schema can't
  drift apart; the serializer N+1 trap.
- **Build:** implement the contract over the capstone data; prove with
  `connection.queries` that list endpoints run a constant number of queries.
- **Gate:** implemented API matches the written contract; any drift is either
  fixed or argued for and the contract amended.

### 3.3 Auth, honestly
- **Learn:** password storage (argon2, and why "hash" is the wrong mental
  model for MD5-era schemes); sessions vs tokens — actual trade-offs, not
  fashion; JWTs and their failure modes; refresh flows and rotation; OIDC
  conceptually (authorization code + PKCE — what your RN app would really
  use); CSRF vs CORS — which attack each one stops, and why they are not the
  same conversation; token storage in React Native (Keychain, not
  AsyncStorage); rate limiting login.
- **Build:** auth on the capstone API (`django-allauth` not needed — sessions
  + `simplejwt` tokens by hand first), plus one genuinely per-user feature:
  followed motions / saved searches, so authorization has something real to
  protect.
- **Gate (= phase gate):** full written contract for a new feature including
  auth, defended; plus a whiteboard walk of the RN client's token lifecycle —
  storage, refresh, logout, and what leaks if the phone is stolen.

---

## Phase 4 — Running it in production (1–1.5 months)

### 4.1 Config, logging, errors
- **Learn:** 12-factor config via environment (`django-environ`); settings
  splits without foot-guns; secrets hygiene; structured logging (`structlog`)
  — logs as data, request IDs; error tracking (Sentry); health endpoints.
- **Build:** capstone reads all config from env; JSON logs with request IDs;
  Sentry wired and a deliberate error traced from phone… er, browser to alert.
- **Gate:** show the same build booting into dev and prod configs by env
  alone; find a specific request's story in the logs on demand.

### 4.2 Docker and the real deploy
- **Learn:** a production Dockerfile (multi-stage, non-root, layer caching);
  gunicorn and workers; static files (whitenoise); Fly.io deploy with managed
  Postgres; TLS and a real domain; running migrations on deploy —
  expand/contract, why `NOT NULL` without a default on a big table bites,
  backfill strategies; backups and actually restoring one.
- **Build:** **the capstone goes live** on a real URL; deploy pipeline
  documented in `capstone/OPERATIONS.md`; one migration executed against the
  live, populated database using the expand/contract pattern.
- **Gate:** it's live, migrated, and you restored a backup to prove the
  backup is real.

### 4.3 Background work — Celery and Redis
- **Learn:** why web requests must not do slow work; Celery + Redis broker;
  at-least-once delivery and what it forces (idempotent tasks); retries and
  backoff; beat schedules; what happens to a task mid-flight when the worker
  dies; monitoring queue depth.
- **Build:** the importer becomes a scheduled Celery beat job on the live
  deployment — nightly sync of new motions and votes, idempotent by
  construction (your Phase 2 upserts finally cash in).
- **Gate:** kill the worker mid-import on purpose; explain and then
  demonstrate what happened to the task, the data, and the queue.

### 4.4 Caching, invalidation, rate limiting
- **Learn:** HTTP caching (ETag/Cache-Control) vs server-side caching and why
  you reach for HTTP first; Redis low-level caching; TTL vs event
  invalidation; the stampede problem; what is safe to cache when votes update
  nightly; DRF throttling, and where real rate limiting actually sits.
- **Build:** cache the expensive endpoints (party-agreement matrix), with
  invalidation triggered by the nightly import; sensible throttles on the API.
- **Gate (= phase gate):** the capstone is live on a real domain, and for
  each of {gunicorn worker, Celery worker, Postgres, Redis} you answer "what
  happens when this process dies?" — concretely, for *your* system, including
  what the user sees and what recovers by itself.

---

## Phase 5 — Testing and depth (ongoing)

### 5.1 Tests that touch the database
- **Learn:** `pytest` + `pytest-django`; the test database and transactional
  isolation; API tests with the DRF client; factories (`model-bakery`);
  testing constraints, permissions, and contracts — not mocking the database
  away; `assertNumQueries` as an N+1 regression tripwire; CI on GitHub
  Actions.
- **Build:** a test suite over the capstone API that would catch: a broken
  contract, a permissions hole, an N+1 regression, a constraint violation.
  CI runs it on every push.
- **Gate:** tutor introduces a subtle bug on a branch; your suite catches it
  (and if it doesn't, the missing test gets written and the lesson logged).

### 5.2 Systems depth (reading, spaced)
- *Designing Data-Intensive Applications* ch. 1–3, 5, 7 — each mapped to a
  thing you built; use-the-index-luke.com as the 1.7 companion; the Postgres
  docs' MVCC chapter after 1.8 has made it concrete; one incident post-mortem
  read per month, retold in your own words at session start.

---

## Out of scope, on purpose

GraphQL, microservices, Kubernetes, gRPC. If they come up before Phase 4's
gate is passed, the tutor's job is to push back and name what they'd displace.
They earn a place only after this curriculum's bar — one boring, well-operated
monolith — is met.

## Timeline sketch (at 4–6 h/week, zero weeks absorbed)

| Phase | Calendar guess |
|---|---|
| 0 — Orientation | weeks 1–2 |
| 1 — SQL & modelling | weeks 3–14 |
| 2 — Python & Django ORM | weeks 15–22 |
| 3 — API & auth | weeks 23–28 |
| 4 — Production | weeks 29–34 |
| 5 — Testing & depth | ongoing from week 30-ish |

Roughly: live capstone by next spring. The table is a compass, not a contract
— gates are the contract.

---

## Tooling policy

Industry-standard choices, cross-checked against the reference project
[Amsterdam/aapp_api_services](https://github.com/Amsterdam/aapp_api_services)
(a production Django/DRF service for the Amsterdam city app):

| Purpose | This course | Reference repo | Note |
|---|---|---|---|
| Packaging | `uv` | `uv` | |
| Lint/format | `ruff` | `ruff` | |
| Types | `mypy` + `django-stubs` | — | added: typing is your strength, use it |
| Tests | `pytest` + `pytest-django` | same | |
| Factories | `model-bakery` | `model-bakery` | |
| Postgres driver | `psycopg` (v3) | `psycopg2` | v3 is current; you'll meet v2 in older code |
| HTTP client | `httpx` | — | `requests` is what you'll see at work |
| Framework | Django + DRF | Django + DRF | |
| OpenAPI | `drf-spectacular` | same | |
| JWT | `djangorestframework-simplejwt` | same | |
| Cache | `django-redis` | same | |
| Jobs | Celery + Redis | — (Azure equivalents) | curriculum requirement |
| Logging | `structlog` | Azure OpenTelemetry | same role, platform-neutral |
| Errors | Sentry | Azure App Insights | same role |
| Serving | gunicorn + whitenoise | gunicorn | |
| Config | `django-environ` | — | |
| Hooks | `pre-commit` | same | |
| Runtime | Python 3.13+, Postgres 17, Redis 7 | Python 3.14 | |
