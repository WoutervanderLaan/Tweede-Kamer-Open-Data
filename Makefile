# Course environment commands. `make` with no target prints this list.

.PHONY: help up down status logs psql capstone redis reset

help:
	@echo "make up        start Postgres + Redis (first run seeds ~6.5M rows, takes minutes)"
	@echo "make status    container health (postgres 'healthy' = seeded and ready)"
	@echo "make logs      follow postgres logs (watch the seed happen on first boot)"
	@echo "make psql      psql into the seeded practice db (gym)"
	@echo "make capstone  psql into YOUR db (capstone)"
	@echo "make redis     redis-cli (unused until Phase 4)"
	@echo "make down      stop containers (data survives)"
	@echo "make reset     DESTROY all data and reseed from scratch"

up:
	docker compose up -d
	@echo ""
	@echo "First boot seeds the gym database — 'make status' says 'healthy' when ready."

down:
	docker compose down

status:
	@docker compose ps
	@echo ""
	@echo "postgres '(healthy)' means seeding is done and connections work."

logs:
	docker compose logs -f postgres

psql:
	docker compose exec postgres psql -U student -d gym

capstone:
	docker compose exec postgres psql -U student -d capstone

redis:
	docker compose exec redis redis-cli

reset:
	docker compose down -v
	docker compose up -d
	@echo ""
	@echo "Wiped. Reseeding now — follow along with 'make logs'."
