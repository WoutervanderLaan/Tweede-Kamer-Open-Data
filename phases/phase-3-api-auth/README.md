# Phase 3 — API design and auth

Locked until the Phase 2 gate is passed.

Modules (details in `CURRICULUM.md`):
- **3.1** The contract comes first — status codes you can defend,
  idempotency, pagination, filtering, versioning, RFC 9457 error shapes.
- **3.2** Django REST Framework — serializers as the validation boundary,
  cursor pagination, the serializer N+1 trap, drf-spectacular.
- **3.3** Auth, honestly — argon2, sessions vs tokens, refresh flows, OIDC
  conceptually, CSRF vs CORS, token storage in a React Native client.

The contract document and all implementation live in `capstone/api/`.

## Layout

- `exercises/` — tutor-written (contract-critique drills, status-code
  defences, auth threat walks).
- `notes/` — yours.
