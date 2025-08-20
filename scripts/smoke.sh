#!/usr/bin/env bash
set -euo pipefail

# Simple smoke tests for MERN Ecommerce API.
# Usage:
#   bash ./scripts/smoke.sh
# Optional env vars:
#   BASE_URL   (default: http://localhost:3000)
#   API_PREFIX (default: /api)

BASE_URL=${BASE_URL:-http://localhost:3000}
API_PREFIX=${API_PREFIX:-/api}
# If true, skip DB-dependent checks (product/category/contact)
SKIP_DB=${SKIP_DB:-false}

cyan() { echo -e "\033[36m$1\033[0m"; }
green() { echo -e "\033[32m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

failures=0

req() {
  local method=$1
  local url=$2
  local data=${3:-}
  http_code="000"
  if [[ -n "$data" ]]; then
    http_code=$(curl -sS -m 5 -o /tmp/smoke_resp.json -w "%{http_code}" -X "$method" -H 'Content-Type: application/json' "$url" --data "$data" || echo "000")
  else
    http_code=$(curl -sS -m 5 -o /tmp/smoke_resp.json -w "%{http_code}" -X "$method" "$url" || echo "000")
  fi
}

expect_2xx() {
  local what=$1
  local code=$2
  if [[ "$code" =~ ^2[0-9]{2}$ ]]; then
    green "✔ $what ($code)"
  else
    red "✖ $what ($code)"
    failures=$((failures+1))
    cat /tmp/smoke_resp.json || true
    echo
  fi
}

cyan "Running smoke tests against ${BASE_URL}${API_PREFIX} ... (SKIP_DB=${SKIP_DB})"

# 1) Health
req GET "${BASE_URL}${API_PREFIX}/health" ""
expect_2xx "GET /health" "$http_code"

if [[ "$SKIP_DB" != "true" ]]; then
  # 2) Public product list (store list)
  # Note: product list route requires a JSON-parsable sortOrder query param.
  ENC_SORT=%7B%22createdAt%22%3A-1%7D
  req GET "${BASE_URL}${API_PREFIX}/product/list?sortOrder=${ENC_SORT}&limit=1" ""
  expect_2xx "GET /product/list" "$http_code"

  # 3) Category list (public)
  req GET "${BASE_URL}${API_PREFIX}/category/list" ""
  expect_2xx "GET /category/list" "$http_code"

  # 4) Contact add (email send is best-effort; API should not crash without keys)
  TS=$(date +%s)
  EMAIL="smoke+${TS}@example.com"
  BODY='{"name":"Smoke Tester","email":"'"$EMAIL"'","message":"Hello from smoke test"}'
  req POST "${BASE_URL}${API_PREFIX}/contact/add" "$BODY"
  expect_2xx "POST /contact/add" "$http_code"
else
  cyan "Skipping DB-dependent checks (product/category/contact) per SKIP_DB=true"
fi

echo
if [[ $failures -eq 0 ]]; then
  green "All smoke tests passed."
  exit 0
else
  red "$failures smoke test(s) failed."
  exit 1
fi
