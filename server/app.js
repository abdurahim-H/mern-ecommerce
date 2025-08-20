require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const routes = require('./routes');
const setupDB = require('./utils/db');
const checkEnv = require('./utils/checkEnv');

// Build and configure the Express app (no listening here)
const createApp = () => {
  const app = express();

  app.use(express.urlencoded({ extended: true }));
  app.use(express.json());
  app.use(
    helmet({
      contentSecurityPolicy: false,
      frameguard: true
    })
  );
  app.use(cors());

  // fail fast if critical env vars are missing (but do not crash)
  checkEnv();

  // Attempt to connect to the DB (non-fatal on failure for local/dev)
  setupDB();

  // Initialize passport after envs are validated
  require('./config/passport')(app);
  app.use(routes);

  // friendly root route for developer UX
  app.get('/', (req, res) => {
    res.send(`Visit /${process.env.BASE_API_URL || 'api'}/health to check server health and DB status.`);
  });

  return app;
};

module.exports = { createApp };
