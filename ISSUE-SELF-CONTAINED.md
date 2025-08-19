Issue: Repo is not "fully self-contained" — missing automated setup and causes routing failures
===============================================================

Summary
-------
The repository is missing a reliable, one-command developer setup. Critical environment values (for example `BASE_API_URL`, `MONGO_URI`, `JWT_SECRET`) are expected but not provided automatically. As a result, developers often run the client against `/api/...` while the server mounts at `/${BASE_API_URL}` (or an undefined path) causing POST/other API requests to 404. Missing envs or DB connectivity also cause the server to fail silently or crash, making routes unreachable.

Observed behavior
-----------------
- Server mounts API routes using `server/config/keys.js` which reads `process.env.BASE_API_URL`. The top-level router in `server/routes/index.js` uses this value to mount all API routes under `/${BASE_API_URL}`.
- If `BASE_API_URL` is missing from `server/.env`, the server will mount under an unexpected path (e.g. `/undefined`) while the client expects `/api`.
- `server/index.js` does enable `express.json()` and `cors()`, so body-parsing/CORS are present; the main cause of 404s is incorrect base path or server not running.
- The repo contains `server/.env.example` and `client/.env.example` but no automated step to copy them into `.env` or validate critical env vars.
- Root `package.json` provides `postinstall` that installs both client and server but does not handle environment population or DB seeding automatically.

Why this breaks "self-contained"
---------------------------------
- New developers must manually create `.env` files for both server and client and supply values (MONGO_URI, JWT_SECRET, BASE_API_URL, CLIENT_URL, etc.).
- Without a running MongoDB and proper `MONGO_URI`, the server's DB initialization (`server/utils/db.js`) will fail and routes may not be available.
- Without `BASE_API_URL` the server's route mounting path doesn't match the client's expected requests, causing POST endpoints to appear broken.

Reproduction steps (how to observe the issue)
-------------------------------------------
1. Clone repo.
2. Do not create `server/.env` (leave only `server/.env.example`).
3. Install deps and start server (for example, `cd server && npm install && npm run dev`).
4. Attempt a POST to a known route the client uses, e.g. `POST /api/auth/login`.
   - Expected: either 404 (if BASE_API_URL unset/mismatch) or server error/crash (if DB missing).

Root causes identified
----------------------
1. Missing `.env` creation/copy step and no early check for required env variables.
2. The app's base API path depends on `BASE_API_URL` which, if missing, yields mismatched client/server paths.
3. No simple, documented local-first setup: create `.env`, start MongoDB, seed DB, then run dev.

Low-risk fixes we recommend
--------------------------
1. Add an automated setup script (`scripts/setup.sh`) that:
   - Copies `server/.env.example` -> `server/.env` and `client/.env.example` -> `client/.env` if missing.
   - Prompts or accepts environment overrides for `MONGO_URI`, `JWT_SECRET`, `BASE_API_URL`.
   - Optionally runs `npm install` (or inform the user to run it) and offers to run `npm run seed:db`.
2. Add a startup pre-check in `server/index.js` (or a new `server/utils/checkEnv.js`) that exits with a clear error message when critical envs are missing (BASE_API_URL, MONGO_URI, JWT_SECRET). This prevents silent misrouting.
3. Add `npm run setup` in root `package.json` to run the new setup script.
4. Add a smoke-check endpoint `GET /${BASE_API_URL}/health` to validate server+DB connectivity.
5. Update README quick-start with exact steps to run locally without Docker (one-liners): setup, seed, dev.

Next steps to validate
---------------------
1. Reproduce the issue locally (start server without creating `.env`) and capture server logs to show the misrouting or startup failure.
2. Implement the setup script and env-check, then verify they resolve the problem by repeating the reproduction steps.

Notes
-----
- This issue file documents the diagnosis and recommended low-risk fixes. I will now attempt to run the server locally "as-is" to reproduce the reported behavior and capture logs.
