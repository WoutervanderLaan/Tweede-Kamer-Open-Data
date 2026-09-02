# Notes

> \> GET / HTTP/1.1
>
> < HTTP/1.0 200 OK

You asked in HTTP/1.1. It answered in HTTP/1.0. What does that difference actually change about the TCP connection underneath — and which line in curl's output is telling you the consequence?

> I don't know

Fair — that's new. Direct answer:

HTTP/1.0 closes the TCP connection after every response. One request, one connection, done. HTTP/1.1 made persistent connections the default: the socket stays open and the next request reuses it. Python's SimpleHTTP is a toy and only speaks 1.0, so even though you asked in 1.1, it answers 1.0 and hangs up.

curl told you both times:

"HTTP 1.0, assume close after body"
"Closing connection"

Why it matters: a TCP connection costs a handshake — a full network round trip before a single byte of your request moves. On a page pulling 50 assets, HTTP/1.0 means 50 handshakes. Keep-alive in 1.1, and multiplexing in HTTP/2, both exist to kill that cost. Note also Content-Length: 686 — with the connection closing you could infer the body ended at EOF, but on a persistent connection the client needs to be told where the body stops. Remember that; you'll need it in section C.

## What is a port?

A machine has one IP address and many processes; a port is the number the kernel uses to decide which process an arriving packet gets handed to. Nothing is stored there.

## How does it serve three clients?

Each must have some kind of state and specific signature, that keeps track of what needs to happen and to whom a response need to go.

---

Right instinct, and the concrete version is worth knowing exactly.

The port isn't the identifier — the connection is. The listening socket on :8000 does exactly one job: accept. Each accept() hands back a new, separate socket, and the kernel tells connections apart by a four-part signature:

(client IP, client port, server IP, server port)
The server half is always 127.0.0.1:8000. The client half differs — your OS assigns each outgoing connection a random high-numbered ephemeral port. That's your "specific signature", and it's the kernel's, not the application's. Your lsof -i :8000 output shows it: one LISTEN row, plus one row per live connection.

So the process is holding three open sockets. How it works on them concurrently — a thread each, a process each, or one loop juggling all of them — is a design decision, not a law. Python's http.server gives each connection a thread. That distinction becomes load-bearing in Phase 4.

## HTTP req

```GET / HTTP/1.1
Host: localhost:8080
Connection: keep-alive
sec-ch-ua: "Not=A?Brand";v="99", "Google Chrome";v="151", "Chromium";v="151"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "macOS"
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,_/_;q=0.8,application/signed-exchange;v=b3;q=0.7
Sec-Fetch-Site: none
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Accept-Encoding: gzip, deflate, br, zstd
Accept-Language: en-US,en;q=0.9,nl-NL;q=0.8,nl;q=0.7,lt;q=0.6
Cookie: <redacted>
```

## Table

| Kind of state               | Lives where?                    | Survives server restart?    | Survives browser restart?  |
| --------------------------- | ------------------------------- | --------------------------- | -------------------------- |
| Your account/profile        | Server (DB)                     | If in DB, yes, otherwise no | Yes                        |
| "You are logged in"         | Client (Cookie)                 | Yes, if Redis, DB or JWT    | Yes, if not session cookie |
| Contents of a shopping cart | Client (Localstorage) or Server | If in localstorage          | Yes                        |
| This page's HTML            | Client (As rendered DOM)        | Yes, as DOM                 | No, needs to refetch       |
