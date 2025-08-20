#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Running repo dev helper from $ROOT_DIR"

# Ensure env files exist
./scripts/setup.sh

# If docker compose is available, prefer it
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  echo "Docker Compose detected — starting services..."
  docker compose up -d
  echo "Waiting for DB to settle..."
  sleep 4
  npm run dev
else
  echo "Docker not detected — falling back to NO_DB mode"
  npm run dev:no-db
fi
