# 02 — The life of one request

Module 0.2. Goal: every layer between "app calls an URL" and "row leaves
Postgres" gets a name, an owner, and a failure mode. This exercise also
verifies your capstone's data source, live, from your machine. ~90 minutes.
Answers in `notes/02-trace-a-request.md`; the diagram in
`notes/request-lifecycle.md`.

## A. Dissect a real request

```sh
curl -v https://opendata.tweedekamer.nl 2>&1 | head -40
```

1. List, in order, everything the `curl -v` output shows happening *before*
   the first byte of HTTP is sent. (Hint: there are at least three distinct
   phases, and none of them are HTTP.)
2. For each phase: what problem does it solve? What would a user see if it
   failed?
3. Run it twice. Which phases got faster the second time, and what does that
   suggest is being remembered — and by whom?

## B. First contact with your capstone's data

The capstone brief (`capstone/README.md`) names a base URL for the
parliamentary OData API — written from documentation, unverified. Verify it:

```sh
curl -s "https://gegevensmagazijn.tweedekamer.nl/OData/v4/2.0/" | head -c 2000
```

4. What did you get back — and is it JSON, XML, HTML? What does this
   document seem to *be*? Cross-check the entity names against the table in
   `capstone/README.md`; note any differences (and fix the brief if it's
   wrong — it's your project file).
5. Fetch actual parties (add `?$top=3` — quote the URL in zsh; `$` means
   something to your shell):

   ```sh
   curl -s "https://gegevensmagazijn.tweedekamer.nl/OData/v4/2.0/Fractie?\$top=3"
   ```

   Pick one field per party you'd *keep* in your future schema and one you'd
   drop, with a sentence of why. First schema instincts, on the record.
6. HTTP question: this API is public, no auth. What did your request send
   that identified *anything* about you? (Check the `>` lines of `curl -v`.)

## C. The diagram — your Phase 0 artifact

Build `notes/request-lifecycle.md` for this future request:

> The RN app calls `GET https://api.your-capstone.nl/motions?page=2`

7. List every layer the request touches, in order, from the phone's radio to
   the Postgres row and back. For every layer: **(a)** its name, **(b)** what
   it adds or decides, **(c)** whether *you*, the backend owner, control it.
   Include at minimum: DNS, TCP, TLS, the reverse proxy, the app process,
   the connection pool, the database — and whatever you argue belongs
   between them.
8. Mark on the diagram: every place state could live, and every place the
   request could be answered *without* reaching Postgres.

## D. Gate rehearsal

The Phase 0 gate is exactly C, spoken aloud without the notes, plus three
"what breaks if this layer dies?" follow-ups from the tutor. When your
diagram is done, tell the tutor you're ready and take the gate cold in the
next session.
