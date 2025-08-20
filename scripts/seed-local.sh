#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Args or defaults
ADMIN_EMAIL=${1:-admin@example.com}
ADMIN_PASS=${2:-admin123}

./scripts/setup.sh

if command -v docker >/dev/null 2>&1; then
  if ! docker info >/dev/null 2>&1; then
    echo "Docker daemon not available. If you just added your user to the docker group, run: newgrp docker or open a new terminal." >&2
    exit 1
  fi
  echo "Starting Mongo via Docker Compose..."
  docker compose up -d
else
  echo "Docker is not installed. Install Docker or ensure a local MongoDB is running at MONGO_URI in server/.env" >&2
fi

# Wait briefly for Mongo to accept connections
sleep 4

(
  cd server
  echo "Seeding DB with admin user ${ADMIN_EMAIL}..."
  node utils/seed.js "$ADMIN_EMAIL" "$ADMIN_PASS"
)

echo "Seed complete."
