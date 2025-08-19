#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "Running repo setup in $ROOT_DIR"

# copy env examples if .env missing
if [ ! -f "$ROOT_DIR/server/.env" ]; then
  cp "$ROOT_DIR/server/.env.example" "$ROOT_DIR/server/.env"
  echo "Created server/.env from example"
fi

if [ ! -f "$ROOT_DIR/client/.env" ]; then
  cp "$ROOT_DIR/client/.env.example" "$ROOT_DIR/client/.env"
  echo "Created client/.env from example"
fi

echo "Setup complete. You can run: docker compose up -d (to start Mongo) and npm run dev (in root)"

# Populate sensible defaults for local dev into server/.env if missing
if ! grep -q "JWT_SECRET" "$ROOT_DIR/server/.env"; then
  echo "JWT_SECRET=dev-secret-please-change" >> "$ROOT_DIR/server/.env"
  echo "Added JWT_SECRET default to server/.env"
fi

if ! grep -q "BASE_API_URL" "$ROOT_DIR/server/.env"; then
  echo "BASE_API_URL=api" >> "$ROOT_DIR/server/.env"
  echo "Added BASE_API_URL=api to server/.env"
fi

if ! grep -q "MONGO_URI" "$ROOT_DIR/server/.env"; then
  echo "MONGO_URI=mongodb://127.0.0.1:27017/mern_ecommerce" >> "$ROOT_DIR/server/.env"
  echo "Added MONGO_URI default to server/.env"
fi
#!/usr/bin/env bash
set -e
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

echo "Setup complete. Edit server/.env to add your MONGO_URI and JWT_SECRET, then run 'npm run dev' from project root to start both client and server." 
