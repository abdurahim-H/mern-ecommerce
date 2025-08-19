#!/usr/bin/env node
const { execSync, spawn } = require('child_process');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
console.log('Running local start orchestration...');

function exists(cmd) {
  try {
    execSync(`which ${cmd}`, { stdio: 'ignore' });
    return true;
  } catch (e) {
    return false;
  }
}

// Run setup.sh to populate env files
try {
  execSync('./scripts/setup.sh', { stdio: 'inherit', cwd: ROOT });
} catch (e) {
  console.error('setup.sh failed:', e.message);
}

if (exists('docker')) {
  console.log('Docker detected — starting Mongo via docker compose');
  try {
    execSync('docker compose up -d', { stdio: 'inherit', cwd: ROOT });
  } catch (e) {
    console.error('docker compose up -d failed:', e.message);
    console.log('Falling back to NO_DB mode');
    spawn('npm', ['run', 'dev:no-db'], { cwd: ROOT, stdio: 'inherit', shell: true });
    process.exit(0);
  }

  console.log('Starting full dev (client + server)');
  spawn('npm', ['run', 'dev'], { cwd: ROOT, stdio: 'inherit', shell: true });
} else {
  console.log('Docker not found — falling back to NO_DB quick-start');
  console.log('To use full local DB please install Docker and re-run this script.');
  spawn('npm', ['run', 'dev:no-db'], { cwd: ROOT, stdio: 'inherit', shell: true });
}
