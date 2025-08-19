require('dotenv').config();
const express = require('express');
const chalk = require('chalk');
const cors = require('cors');
const helmet = require('helmet');

const keys = require('./config/keys');
const routes = require('./routes');
const socket = require('./socket');
const setupDB = require('./utils/db');
const checkEnv = require('./utils/checkEnv');

const { port } = keys;
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

// fail fast if critical env vars are missing
checkEnv();

// Attempt to connect to the DB (don't crash the process on failure so devs can
// still run non-DB routes and see human-friendly errors).
setupDB();

// Initialize passport after envs are validated
require('./config/passport')(app);
app.use(routes);

const server = app.listen(port, () => {
  console.log(
    `${chalk.green('✓')} ${chalk.blue(
      `Listening on port ${port}. Visit http://localhost:${port}/ in your browser.`
    )}`
  );
});

socket(server);
	
// friendly root route for developer UX
app.get('/', (req, res) => {
  res.send(`Visit /${process.env.BASE_API_URL || 'api'}/health to check server health and DB status.`);
});
