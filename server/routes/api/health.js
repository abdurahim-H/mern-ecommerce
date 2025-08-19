const router = require('express').Router();
const mongoose = require('mongoose');

router.get('/', async (req, res) => {
  const dbState = mongoose.connection.readyState; // 0 = disconnected, 1 = connected
  res.json({
    ok: true,
    db: dbState === 1 ? 'connected' : 'disconnected'
  });
});

module.exports = router;
