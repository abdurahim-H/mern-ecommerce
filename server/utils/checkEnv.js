/**
 * checkEnv: lightweight environment validation for developer experience.
 * - If NO_DB=true, MONGO_URI is not required.
 * - If USE_IN_MEMORY_DB=true, MONGO_URI is not required.
 * - If JWT_SECRET is missing, we inject a dev default but warn the user.
 */
const checkEnv = () => {
  const requireDb = !(process.env.NO_DB === 'true' || process.env.USE_IN_MEMORY_DB === 'true');
  const missing = [];

  if (!process.env.BASE_API_URL) missing.push('BASE_API_URL');
  if (!process.env.JWT_SECRET) {
    // Provide a safe, clearly-dev-only default to make local startup frictionless
    process.env.JWT_SECRET = 'dev-secret-please-change';
    console.warn('WARNING: JWT_SECRET not set — using development default. Set a real secret in production.');
  }

  if (requireDb && !process.env.MONGO_URI) missing.push('MONGO_URI');

  if (missing.length) {
    console.error(`Missing required environment variables: ${missing.join(', ')}`);
    console.error('Please create server/.env from server/.env.example and set the missing values, or run scripts/setup.sh.');
    // Do not crash the process; we want dev server to start in NO_DB mode if requested.
  }
};

module.exports = checkEnv;
