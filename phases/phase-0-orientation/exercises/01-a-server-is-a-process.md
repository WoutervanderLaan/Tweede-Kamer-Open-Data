# 01 — A server is a process

Module 0.1. Goal: replace "the backend" as a place in the fog with "an
ordinary process on a port" that you have started, watched, poked, and
killed. ~60–90 minutes. Answers go in `notes/01-a-server-is-a-process.md` —
write real sentences; the gate is spoken, but writing is how you'll find out
what you don't actually know.

## A. Start one, look at it

macOS ships Python 3. In any directory with a few files:

```sh
python3 -m http.server 8000
```

1. Before touching a browser, predict: what will `http://localhost:8000` show?
2. Open it in the browser. Then, in a second terminal:

   ```sh
   curl -v http://localhost:8000/
   ```

   Read the `>` lines (what you sent) and `<` lines (what came back) — all of
   them. Note two headers you can explain and two you can't. The ones you
   can't are session material; bring them.

3. Find the process behind it:

   ```sh
   lsof -i :8000
   ```

   Write down: what is a port, in one sentence of your own. What does it mean
   that this process is "listening"?

4. Load the page in two browser tabs plus `curl` at the same time. One
   process — how does it serve three clients? (You don't need the right
   vocabulary yet; describe what must be happening.)

## B. Kill it

5. Ctrl-C the server. Reload the browser tab.
   - What _exactly_ stopped existing? The files? The port? Something else?
   - Where would a "logged-in user" have gone, if this server had login?
     It never wrote anything to disk. Sit with that question — it is the
     whole point of this module. Write your best answer even if unsure.

## C. Serve one request by hand

`nc` (netcat) listens on a port and shows you raw bytes.

```sh
nc -l 8080
```

6. Point your browser at `http://localhost:8080`. The text that appears in
   the terminal **is** an HTTP request — the whole thing. Copy it into your
   notes and annotate every line you recognise.
7. The browser is still spinning: nothing answered yet. Answer it by typing
   into the terminal, ending with a blank line, then Ctrl-C:

   ```
   HTTP/1.1 200 OK
   Content-Type: text/html

   <h1>served by hand</h1>
   ```

   What did the browser render? What happens if you type a `404` instead of
   `200`? Try it (browsers are surprisingly chill about this — note what that
   tells you about who status codes are _for_).

## D. Where state lives

8. Close with a table in your notes, filled in with your current best
   guesses — wrong guesses are welcome, they're what the session corrects:

   | Kind of state               | Lives where? | Survives server restart? | Survives browser restart? |
   | --------------------------- | ------------ | ------------------------ | ------------------------- |
   | Your account/profile        |              |                          |                           |
   | "You are logged in"         |              |                          |                           |
   | Contents of a shopping cart |              |                          |                           |
   | This page's HTML            |              |                          |                           |

Bring the notes to the next session. The tutor will poke at B.5 and D
hardest.
