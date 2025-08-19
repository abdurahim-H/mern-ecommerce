# Contributing to the Self-Contained Dev Flow

This document explains how to review, test, and contribute to the `self-contained-setup` changes.

## Local review checklist
1. Fetch the branch `self-contained-setup` from the fork and check it out locally.
2. Run `./scripts/setup.sh` to populate `.env` files and apply dev defaults (it avoids overwriting existing `.env`).
3. If you have Docker installed:
   - Run `npm run start:local` (or `docker compose up -d && npm run dev`) and verify `http://localhost:3001/api/health` returns `{"ok":true,"db":"connected"}`.
4. If you don't have Docker installed:
   - Run `npm run dev:no-db` and verify the server starts and `http://localhost:3001/api/health` returns `{"ok":true,"db":"disconnected"}`.

## What to look for in review
- Clear documentation (README.LOCAL.md and README.md) with steps for new devs.
- `scripts/setup.sh` should not destructively overwrite developer `.env` files.
- Changes are scoped to developer experience helpers and do not modify core business logic.
- `server/routes/api/health.js` exists and returns a small JSON health payload.

## How to open a PR
1. Push your branch to your fork (automation may have already done this).
2. Open a PR from `youruser/mern-ecommerce:self-contained-setup` → `mohamedsamara/mern-ecommerce:master`.
3. In the PR description, summarize what changed, how to test locally, and any limitations (eg. in-memory Mongo may fail on some OSes).

If you'd like, I can open the PR for you or validate the Docker flow on a machine that has Docker installed.
