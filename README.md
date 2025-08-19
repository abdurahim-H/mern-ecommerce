MERN Ecommerce — Local Development (Self-contained)
===============================================

This repository is a developer-friendly copy (`mern-ecommerce-fix`) with automation and documentation to make local setup quick and repeatable.

Goals
- One-command (best-effort) local startup that brings up the DB and the app.
- Fast fallback modes for developers without Docker or Mongo.
- Clear troubleshooting steps and health checks so routes can be verified.

Quick overview of local modes
- Docker (recommended): starts a local MongoDB via Docker Compose, runs the client and server.
- In-memory Mongo: best-effort option (uses `mongodb-memory-server`) — may fail on unusual OS/platforms.
- NO_DB: fastest way to run the server without any DB; useful for UI and non-DB work.

One-command (recommended)
1. Ensure Docker is installed and running on your machine.
2. From repo root:

```bash
# populate .env from examples and add dev defaults
./scripts/setup.sh

# orchestration: will use Docker when available, otherwise fallback to NO_DB
npm run start:local
```

Quick manual flows
- Full (Docker) — reliable, reproducible

```bash
./scripts/setup.sh
docker compose up -d
npm run dev
```

- NO_DB (fast)

```bash
./scripts/setup.sh
npm run dev:no-db
```

- In-memory (best-effort)

```bash
./scripts/setup.sh
npm run dev:in-memory
```

Health check
- Root: http://localhost:3001/ — quick message
- Health: http://localhost:3001/api/health — returns { ok: true, db: "connected" | "disconnected" }

Developer scripts (copy)
- `npm run start:local` — orchestration script (setup, docker compose up -d if available, then dev)
- `npm run dev` — runs both client and server in parallel (root package.json)
- `npm run dev:no-db` — runs server with `NO_DB=true` to skip DB connection
- `npm run dev:in-memory` — runs server with `USE_IN_MEMORY_DB=true` (may fail on some systems)

Troubleshooting
- Missing JWT_SECRET causes passport-jwt to fail at startup. `./scripts/setup.sh` injects a development default. Always set a strong secret in production.
- If `mongodb-memory-server` fails to download binaries: use Docker Compose or install `mongod` locally.
- If server crashes with EADDRINUSE: port 3001 is in use. Stop the other process or change `PORT` in `server/.env`.

Files added in this copy
- `scripts/setup.sh` — copies env examples and populates dev defaults.
- `scripts/start-local.js` — orchestrates setup and starts Docker fallback or NO_DB.
- `docker-compose.yml` — local MongoDB service.
- `server/routes/api/health.js` — health endpoint.
- `server/utils/checkEnv.js` and `server/utils/db.js` — robust env checks and DB connection handling.

Next steps for merge
- I pushed the branch `self-contained-setup` to your fork. Open a PR from `self-contained-setup` -> `mohamedsamara/mern-ecommerce` and assign reviewers.

If you want, I can open the PR for you or continue and validate the Docker flow on this machine (requires Docker install).
# MERN Ecommerce

## Description

An ecommerce store built with MERN stack, and utilizes third party API's. This ecommerce store enable three main different flows or implementations:

1. Buyers browse the store categories, products and brands
2. Sellers or Merchants manage their own brand component
3. Admins manage and control the entire store components 

### Features:

  * Node provides the backend environment for this application
  * Express middleware is used to handle requests, routes
  * Mongoose schemas to model the application data
  * React for displaying UI components
  * Redux to manage application's state
  * Redux Thunk middleware to handle asynchronous redux actions

## Demo

This application is deployed on Vercel Please check it out :smile: [here](https://mern-store-gold.vercel.app).

See admin dashboard [demo](https://mernstore-bucket.s3.us-east-2.amazonaws.com/admin.mp4)

## Docker Guide

To run this project locally you can use docker compose provided in the repository. Here is a guide on how to run this project locally using docker compose.

Clone the repository
```
git clone https://github.com/mohamedsamara/mern-ecommerce.git
```

Edit the dockercompose.yml file and update the the values for MONGO_URI and JWT_SECRET

Then simply start the docker compose:

```
docker-compose build
docker-compose up
```

## Database Seed

* The seed command will create an admin user in the database
* The email and password are passed with the command as arguments
* Like below command, replace brackets with email and password. 
* For more information, see code [here](server/utils/seed.js)

```
npm run seed:db [email-***@****.com] [password-******] // This is just an example.
```

## Install

`npm install` in the project root will install dependencies in both `client` and `server`. [See package.json](package.json)

Some basic Git commands are:

```
git clone https://github.com/mohamedsamara/mern-ecommerce.git
cd project
npm install
```

## ENV

Create `.env` file for both client and server. See examples:

[Frontend ENV](client/.env.example)

[Backend ENV](server/.env.example)


## Vercel Deployment

Both frontend and backend are deployed on Vercel from the same repository. When deploying on Vercel, make sure to specifiy the root directory as `client` and `server` when importing the repository. See [client vercel.json](client/vercel.json) and [server vercel.json](server/vercel.json).

## Start development

```
npm run dev
```

## Languages & tools

- [Node](https://nodejs.org/en/)

- [Express](https://expressjs.com/)

- [Mongoose](https://mongoosejs.com/)

- [React](https://reactjs.org/)

- [Webpack](https://webpack.js.org/)


### Code Formatter

- Add a `.vscode` directory
- Create a file `settings.json` inside `.vscode`
- Install Prettier - Code formatter in VSCode
- Add the following snippet:  

```json

    {
      "editor.formatOnSave": true,
      "prettier.singleQuote": true,
      "prettier.arrowParens": "avoid",
      "prettier.jsxSingleQuote": true,
      "prettier.trailingComma": "none",
      "javascript.preferences.quoteStyle": "single",
    }

```

