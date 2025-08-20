MERN Ecommerce — Local Development (Self-contained)
===============================================

This repository is a developer-friendly copy (`mern-ecommerce-fix`) with automation and documentation to make local setup quick and repeatable.

Goals
- One-command (best-effort) local startup that brings up the DB and the app.
- Fast fallback modes for developers without Docker or Mongo.
- Clear troubleshooting steps and health checks so routes can be verified.

Quick overview of local modes
- Docker (recommended): starts a local MongoDB via Docker Compose, runs the client and server.
- In-memory Mongo: best-effort option (uses `mongodb-memory-server`) — may fail on unusual OS/platforms.
- NO_DB: fastest way to run the server without any DB; useful for UI and non-DB work.

# MERN Ecommerce — Developer-friendly fork (mern-ecommerce-fix)

This fork improves local developer experience by providing reliable, documented, and repeatable local startup flows. It is intentionally self-contained for development: the repo includes setup scripts, a seeded database workflow, and clear fallbacks when external services are not configured.

Why this fork
------------
- Starts clean local MongoDB via Docker Compose and seeds data automatically.
- Provides in-memory and NO_DB fallbacks for fast UI work without Docker.
- Graceful handling of missing external integrations (Mailgun, AWS) so the app doesn't crash.

Quick start (recommended — Docker)
---------------------------------
Prerequisites: Git, Node.js (16+), and Docker installed.

```bash
git clone https://github.com/abdurahim-H/mern-ecommerce.git
cd mern-ecommerce-fix
./scripts/setup.sh
docker compose up -d
npm run dev
```

Other local modes
-----------------
- In-memory Mongo (no Docker required but platform-dependent):
  - `npm run dev:in-memory`
- NO_DB (UI-only):
  - `npm run dev:no-db`

Health checks & quick verification
----------------------------------
- Root: http://localhost:3000/ (or the `PORT` in `server/.env`) — basic message
- Health: http://localhost:3000/api/health — returns DB connection status
- Products: http://localhost:3000/api/products — should return seeded products after seeding

Seeding
-------
Seed the database (creates admin + sample data):

```bash
cd server
npm run seed:db admin@example.com admin123
```

Developer notes
---------------
- `scripts/setup.sh` creates `server/.env` and `client/.env` from examples and writes safe development defaults.
- `scripts/start-local.js` orchestrates running Docker (preferred) or falling back to NO_DB.
- `server/utils/checkEnv.js` warns about missing envs and injects a dev `JWT_SECRET` if absent to prevent startup friction.

External services
-----------------
- S3 (uploads), Mailgun (email), Mailchimp (newsletter) and OAuth are optional. If keys are not provided:
  - The server logs a warning, and the affected endpoints degrade gracefully (no crash).
  - You can test core functionality (browse, cart, auth) without these keys.

Contributing
------------
Please read `CONTRIBUTING.md`. Open small PRs and include step-by-step reproduction for env-sensitive fixes.

License
-------
MIT — see `LICENSE`.


