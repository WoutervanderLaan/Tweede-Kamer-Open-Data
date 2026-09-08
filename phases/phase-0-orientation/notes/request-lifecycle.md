# Request Lifecycle Diagram

## Questions

1. List every layer the request touches, in order, from the phone's radio to the Postgres row and back. For every layer: (a) its name, (b) what it adds or decides, (c) whether you, the backend owner, control it. Include at minimum: DNS, TCP, TLS, the reverse proxy, the app process, the connection pool, the database — and whatever you argue belongs between them.
2. Mark on the diagram: every place state could live, and every place the request could be answered without reaching Postgres.

## Answers

The request goes:

| Layers                                        | Do I own it?      | State lives here?          | State can answer without reaching Postgres |
| --------------------------------------------- | ----------------- | -------------------------- | ------------------------------------------ |
| Client app                                    | No                | _Yes_                      | _Yes_                                      |
| through the phone's Wi-Fi/cellular network    | No                | _No_                       | No                                         |
| DNS resolution                                | No (only records) | _Yes_                      | No                                         |
| TCP connection                                | No                | Yes                        | No                                         |
| The kernel socket                             | _Yes_             | _Yes_                      | No                                         |
| Reverse proxy & TLS handshake _decryption_    | Yes               | Yes                        | _YES_ (Cached data)                        |
| HTTP/app server                               | Yes               | Yes                        | Yes                                        |
| Application/business logic                    | Yes               | _Depends on design_        | Yes                                        |
| Connection pool                               | Yes               | Yes                        | No                                         |
| PostgreSQL query planner/executor             | Yes               | _Yes_ (cached query plans) | No (reached Postgres here)                 |
| Storage/cache where the row is read           | _Yes_             | Yes                        | -                                          |
| Connection pool                               | Yes               | Yes                        | -                                          |
| Application/business logic _serialization_    | Yes               | _Depends on design_        | -                                          |
| HTTP/app server _compression_                 | Yes               | Yes                        | -                                          |
| Reverse proxy & TLS _caching & re-encryption_ | Yes               | Yes                        | -                                          |
| The kernel socket                             | _Yes_             | _Yes_                      | -                                          |
| TCP connection                                | No                | Yes                        | -                                          |
| phone's Wi-Fi/cellular network                | No                | _No_                       | -                                          |
| Client app _decryption_                       | No                | _Yes_                      | -                                          |

Each layer adds or decides something different:

- the network _transports_ packets,
- DNS _resolves_ the hostname,
- TCP provides _reliable transport_,
- The kernel socket _queues and assigns_ incoming connections,
- TLS provides _encryption/authentication_,
- the proxy _terminates/routes_ traffic,
- the app _interprets_ the HTTP request and constructs the query,
- the pool _manages_ DB connections,
- and PostgreSQL plans and _executes_ the query.

I control the DNS configuration and essentially everything from the reverse proxy through the database; I don't control the phone's radio, Internet routing, or the underlying TCP/network infrastructure.

### Feedback

- Some layers can return a successful, correct response without the database ever being consulted. The work was done once, the result was kept, and a later identical request gets served from the kept copy. That's caching — and it's the single biggest lever on backend performance you'll meet.

- A connection pool doesn't create/close a DB connection for every request. It gives the application an already-open connection and then takes it back when the query is finished.

- HTTP is a protocol; the HTTP server/framework is what parses the HTTP message and dispatches it to your application.
