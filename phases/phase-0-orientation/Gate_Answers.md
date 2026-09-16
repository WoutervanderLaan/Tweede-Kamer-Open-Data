# GATE

## Question

---

> GET https://api.your-capstone.nl/motions?page=2, fired by the RN app.

Walk it from the phone to the Postgres row and back. For each layer: its name, what it adds or decides, and whether you own it.

From memory. Go

---

## Answer

| Step                              | Adds or decides what?                                                      | Do I own it?     |
| --------------------------------- | -------------------------------------------------------------------------- | ---------------- |
| RN App                            | client _initiates_ the api request                                         | No               |
| Mobile Network                    | _transports_ packets of the request                                        | No               |
| DNS lookup                        | _resolves_ the hostname                                                    | Only the records |
| TCP                               | provides _reliable transport_                                              | No               |
| Kernel socket                     | _accepts_ incoming connection                                              | Yes              |
| Reverse proxy & TLS handshake     | _terminates / routes request; may serve cached data; provides encryption_  | Yes              |
| HTTP server/framework             | _parses and dispatches_ request to the appropriate handler                 | Yes              |
| App/business logic                | _interprets and processes_ the request                                     | Yes              |
| Connection pool                   | _lends connection_ to db                                                   | Yes              |
| PostgresQL planner/executor       | _plans and executes_ queries                                               | Yes              |
| Storage/Cache task rows from disk | _reads_ required pages from shared buffers / OS cache / disk               | Yes              |
| Connection pool                   | _returns_ connection to the pool                                           | Yes              |
| App/business logic                | _processes and serializes_ returned query data; _adds headers for caching_ | Yes              |
| HTTP/server stack                 | serializes response into HTTP bytes; compression may occur                 | Yes              |
| Reverse proxy & TLS handshake     | _re-encrypts, writes to cache; provides encryption_                        | Yes              |
| Kernel socket                     | _terminates_ open connection                                               | Yes              |
| TCP                               | provides _reliable transport_                                              | No               |
| Mobile Network                    | _transports_ packets of the response                                       | No               |
| RN App                            | app _receives_ plaintext HTTP response                                     | No               |

| Step                        | Adds or decides what?                                                          | Do I own it?     |
| --------------------------- | ------------------------------------------------------------------------------ | ---------------- |
| Client app                  | Initiates the request                                                          | No               |
| Mobile cellular network     | transport the request                                                          | No               |
| DNS resolution              | resolves the hostname                                                          | Only the records |
| TCP                         | provides reliable transport                                                    | No               |
| Kernel socket               | accepts incoming requests                                                      | Yes              |
| Reverse proxy/TLS           | terminates/routes requests; might serve cached data; provides encryption (TLS) | Yes              |
| HTTP/server stack/framework | parses and dispatches request to appropriate handler                           | Yes              |
| app/business logic          | interprets and processes request                                               | Yes              |
| connection pool             | lends connection to db                                                         | Yes              |
| Postgres planner/executor   | Plans and executes queries                                                     | Yes              |
| Disk Storage                | Reads actual rows from disk/storage/cache                                      | Yes              |
| connection pool             | return connection to pool                                                      | Yes              |
| app/business logic          | Process returned query result; serialization; adds headers for caching         | Yes              |
| HTTP/server stack/framework | serializes response into HTTP bytes; compression may occur                     | Yes              |
| Reverse proxy/TLS           | writes to cache is needed/re-encrypts                                          | Yes              |
| Kernel socket               | terminates open connection                                                     | Yes              |
| TCP                         | provides reliable transport                                                    | No               |
| Mobile cellular network     | transport the response                                                         | No               |
| Client app                  | receives the returned response                                                 | No               |
