Quick local developer setup (self-contained)
============================================

This copy (`mern-ecommerce-fix`) includes helpers to run locally with minimal friction.

Options:

1) Docker compose (recommended - full environment)

- Start services (Mongo):

```bash
# from the repository root (no absolute path required)
cd $(git rev-parse --show-toplevel || .)
./scripts/setup.sh
docker compose up -d
npm run dev
```

2) NO_DB (fast, no database) — for UI and non-DB flows

```bash
# from the repository root
./scripts/setup.sh
npm run dev:no-db
# visit http://localhost:3001/
# check DB status: http://localhost:3001/api/health
```

3) In-memory MongoDB (best-effort; may fail on some OS/distributions)

```bash
# from the repository root
./scripts/setup.sh
npm run dev:in-memory
```

Notes
-----
- `USE_IN_MEMORY_DB` uses `mongodb-memory-server` which downloads MongoDB binaries for your platform. On non-standard distros the download may fail; Docker is more reliable.
- `NO_DB` starts the server without connecting to Mongo — routes that require DB will return errors but the server stays up for local dev.

If you want, I can add a single `make dev` or a one-shot script to run the whole flow for new devs.

Quick start: you can now run the whole flow with `./scripts/dev.sh` or `npm run dev:local` from the repo root.
