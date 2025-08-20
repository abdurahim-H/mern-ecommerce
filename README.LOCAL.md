## Local development — reproducible setup

This file gives exact, copy-paste commands to get the project running locally in three supported modes. Docker Compose is recommended for reliability; in-memory and NO_DB are available for convenience.

Prerequisites
-------------
- Git
- Node.js 16+
- Docker (recommended) or Node for NO_DB/in-memory modes

Recommended (Docker)
---------------------
```bash
# from repo root
./scripts/setup.sh        # creates server/.env and client/.env with sensible defaults
docker compose up -d      # start Mongo
npm run dev               # run client + server locally
```

Manual seeding (if needed)
```bash
cd server
npm run seed:db admin@example.com admin123
```

In-memory Mongo (no Docker)
```bash
./scripts/setup.sh
npm run dev:in-memory
```

NO_DB (UI-only)
```bash
./scripts/setup.sh
npm run dev:no-db
```

Smoke checks
------------
- GET http://localhost:3000/api/health  — DB connection state
- GET http://localhost:3000/api/products — seeded products
- POST http://localhost:3000/api/contact/add — saves contact even if mail sending fails

Troubleshooting
---------------
- If `mongodb-memory-server` fails to download binaries: use Docker Compose or install `mongod`.
- If API requests 404: ensure `BASE_API_URL` in `server/.env` matches client settings.
- Missing Mailgun/AWS keys will warn in logs and disable related features; core app will still run.

Recommended additions (optional)
--------------------------------
- `scripts/smoke.sh` to run the smoke checks after startup.
- `npm run dev:local` wrapper that runs setup, docker compose, seed and dev in one step.
