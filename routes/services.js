const express = require('express');
const pool = require('../config/db');

const router = express.Router();

// GET /api/services - list all active services
router.get('/', async (req, res) => {
  const result = await pool.query(
    'SELECT id, name, description, duration_minutes, price FROM services WHERE is_active = TRUE ORDER BY id'
  );
  res.status(200).json(result.rows);
});

module.exports = router;
