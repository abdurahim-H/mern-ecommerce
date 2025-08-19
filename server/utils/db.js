require('dotenv').config();
const chalk = require('chalk');
const mongoose = require('mongoose');

const keys = require('../config/keys');
const { database } = keys;

// Optional in-memory MongoDB for local development when Docker/host DB is not available
let _inMemoryServer = null;

/**
 * Attempt to connect to MongoDB. Failures are logged but do not crash the process.
 * This makes local development possible when MongoDB is not available (server
 * will still run and expose routes that don't require DB), and provides clearer
 * logging for the developer.
 */
const setupDB = async () => {
  const useInMemory = process.env.USE_IN_MEMORY_DB === 'true';

  // If developer explicitly asked to run without DB, skip connecting entirely
    const noDb = process.env.NO_DB === 'true';

    // If explicitly skipping DB, return early
    if (noDb) {
      console.warn('NO_DB=true — skipping MongoDB connection as requested.');
      return;
    }

  // If no DB URL and not explicitly asking for in-memory, skip
  if ((!database || !database.url) && !useInMemory) {
    console.warn('No database URL configured (MONGO_URI). Skipping MongoDB connection.');
    return;
  }

  try {
    // Recommended mongoose options -- guard in case installed mongoose version
    // doesn't support `strictQuery` setter or will treat it as a connect option.
    try {
      if (typeof mongoose.set === 'function') {
        mongoose.set('strictQuery', false);
      }
    } catch (setErr) {
      console.warn('Could not set mongoose strictQuery option:', setErr.message || setErr);
    }

    let connectUrl = database && database.url;

    // If requested, spin up an in-memory MongoDB instance
    if (useInMemory) {
      try {
        const { MongoMemoryServer } = require('mongodb-memory-server');

        // allow overriding the binary version via env var
        const preferred = process.env.MONGO_MEMORY_BINARY_VERSION;
        const fallbacks = [preferred, '6.0.8', '5.0.9', '4.4.18'].filter(Boolean);

        let created = null;
        for (const v of fallbacks) {
          try {
            if (v) {
              created = await MongoMemoryServer.create({ binary: { version: v } });
            } else {
              created = await MongoMemoryServer.create();
            }
            if (created) {
              _inMemoryServer = created;
              connectUrl = _inMemoryServer.getUri();
              console.log(`Using in-memory MongoDB (binary version: ${v || 'default'})`);
              break;
            }
          } catch (tryErr) {
            console.warn(`In-memory MongoDB start failed for version ${v || 'default'}:`, tryErr.message || tryErr);
            // try next
          }
        }

        if (!created) {
          throw new Error('All attempts to start in-memory MongoDB failed');
        }
      } catch (memErr) {
        console.warn('Failed to start in-memory MongoDB:', memErr.message || memErr);
      }
    }

    if (!connectUrl) {
      throw new Error('No MongoDB connection URL available');
    }

    await mongoose.connect(connectUrl, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });

    console.log(`${chalk.green('✓')} ${chalk.blue('MongoDB Connected!')}`);

    mongoose.connection.on('error', err => {
      console.error('MongoDB connection error:', err);
    });
  } catch (err) {
    console.error(`${chalk.green('✗')} ${chalk.red('MongoDB connection failed:')}`, err.message || err);
    // Do not re-throw — keep server running so developer can see clearer errors and test non-DB flows.
  }
};

module.exports = setupDB;
