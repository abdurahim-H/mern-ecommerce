#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Running repo setup in $ROOT_DIR"

# Copy env examples if missing
if [ ! -f "$ROOT_DIR/server/.env" ]; then
  cp "$ROOT_DIR/server/.env.example" "$ROOT_DIR/server/.env"
  echo "Created server/.env from example"
else
  echo "server/.env already exists"
fi

if [ ! -f "$ROOT_DIR/client/.env" ]; then
  cp "$ROOT_DIR/client/.env.example" "$ROOT_DIR/client/.env"
  echo "Created client/.env from example"
else
  echo "client/.env already exists"
fi

# Populate sensible defaults for local dev into server/.env if missing
ensure_kv() {
  local key=$1
  local value=$2
  if ! grep -q "^${key}=" "$ROOT_DIR/server/.env"; then
    echo "${key}=${value}" >> "$ROOT_DIR/server/.env"
    echo "Added ${key} default to server/.env"
  fi
}

ensure_kv "JWT_SECRET" "dev-secret-please-change"
ensure_kv "BASE_API_URL" "api"
ensure_kv "MONGO_URI" "mongodb://127.0.0.1:27017/mern_ecommerce"

echo "Setup complete. Next: docker compose up -d (start Mongo) and npm run dev (from repo root)."
