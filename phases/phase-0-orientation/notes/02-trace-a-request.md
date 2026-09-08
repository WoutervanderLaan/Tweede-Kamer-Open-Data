# Notes

## A1. List, in order, everything the curl -v output shows happening before the first byte of HTTP is sent. (Hint: there are at least three distinct phases, and none of them are HTTP.)

For a typical curl -v https://example.com request, the phases are:

1. DNS resolution — curl resolves example.com to an IP address.
2. TCP connection — it establishes a TCP connection to that IP, including the TCP handshake.
3. TLS handshake — because it's HTTPS, curl negotiates TLS, verifies the certificate, and establishes encryption.
4. HTTP begins — only after TLS is established does curl send the HTTP request, e.g. GET / HTTP/1.1.

## A2. For each phase: what problem does it solve? What would a user see if it failed?

- DNS: Domain name system. It holds the records for domain names and their associated ip addresses. If it fails a user would see a failure to connect to the requested resource.
- TCP: TCP fails in two distinct ways, and telling them apart is one of the most useful five seconds in debugging:
  - Connection refused — instant. The host is reachable, the packet arrived, and nothing is listening on that port. Remember last session: the binding died with the process. Connection refused usually means your app crashed.
  - Connection timed out — hangs, then gives up. Packets are vanishing with no reply at all. That's a firewall, a security group, a wrong IP, or a host that isn't there. Something is silently dropping your traffic.

    > Fast failure means "reached it, nobody home". Slow failure means "never reached it". Write both down — the gate will ask.

- TSL ??

## A3. Run it twice. Which phases got faster the second time, and what does that suggest is being remembered — and by whom?

- DNS: 72ms → 4.6ms. Your OS resolver cached the answer, and it will hold it until the record's TTL expires.
- TCP: 78ms → 96ms → 75ms. No memory whatsoever. Every new connection pays a full handshake, forever. That is the entire reason connection pooling exists — hold connections open and reuse them rather than re-handshaking. It's on your diagram in section C, and it's a Phase 2 topic.
- TLS: 397ms → 133ms. Real, but not for the obvious reason — separate curl processes don't share a TLS session cache. Most likely the certificate revocation check happened once and got cached by the OS.

## B4. What did you get back — and is it JSON, XML, HTML? What does this document seem to be?

I got back a JSON response, which looks like some kind of table of contents, or sorts.

## B5. Pick one field per party you'd keep in your future schema and one you'd drop, with a sentence of why.

1. To keep: "NaamNL". This is to identify the party. Key data. To drop: "Verwijderd". This property does not seem very informative and only suggests to mean if it has been removed from the data. But if it has, it would simply not be in the data (I assume)
2. To keep: "Id". Unique identifier for each entry in the Fractie data. To dop: "Verwijderd", but maybe also "NaamEN". Prefer one "Naam" prop that holds the formal Dutch name.
3. To keep: "AantalZetels". Key information about seats in the parliament. Nothing anymore to drop.

## B6.HTTP question: this API is public, no auth. What did your request send that identified anything about you?

> \> GET /OData/v4/2.0/Fractie?$top=3 HTTP/1.1
> \> Host: gegevensmagazijn.tweedekamer.nl
> \> User-Agent: curl/8.7.1
> \> Accept: _/_
