require('dotenv').config();
const chalk = require('chalk');
const keys = require('./config/keys');
const socket = require('./socket');
const { createApp } = require('./app');

const { port } = keys;
const app = createApp();

const server = app.listen(port, () => {
  console.log(
    `${chalk.green('✓')} ${chalk.blue(
      `Listening on port ${port}. Visit http://localhost:${port}/ in your browser.`
    )}`
  );
});

socket(server);
