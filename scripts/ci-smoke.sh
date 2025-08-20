#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[ci-smoke] Preparing environment..."
./scripts/setup.sh

# Start API server in NO_DB mode for CI (no Mongo needed)
(
  cd server
  echo "[ci-smoke] Starting server in NO_DB mode..."
  NO_DB=true BASE_API_URL=api PORT=3000 nohup npm run dev >/tmp/server-ci.log 2>&1 &
  echo $! > /tmp/server-ci.pid
)

# Wait for /health
echo "[ci-smoke] Waiting for /api/health (up to 60s)..."
for i in {1..60}; do
  code=$(curl -s -m 2 -o /tmp/health-ci.json -w "%{http_code}" http://127.0.0.1:3000/api/health || echo 000)
  if [ "$code" = "200" ]; then
    echo "[ci-smoke] Health OK"
    break
  fi
  sleep 1
  if [ $i -eq 60 ]; then
    echo "[ci-smoke] Server not healthy in time. Last code: $code" >&2
    exit 1
  fi
done

# Run smoke with SKIP_DB=true to avoid DB-dependent checks
SKIP_DB=true BASE_URL=http://127.0.0.1:3000 API_PREFIX=/api bash ./scripts/smoke.sh

echo "[ci-smoke] Done."
