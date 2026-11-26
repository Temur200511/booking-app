const express = require('express');
const bcrypt = require('bcryptjs');
const { body, validationResult } = require('express-validator');
const pool = require('../config/db');

const router = express.Router();

const SALT_ROUNDS = 12;

// Validation rules for registration (server-side; never trust the client)
const registerRules = [
  body('full_name')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Full name must be 2-100 characters'),
  body('email')
    .trim()
    .toLowerCase()
    .isEmail()
    .withMessage('A valid email is required')
    .isLength({ max: 255 }),
  body('password')
    .isLength({ min: 8, max: 72 })
    .withMessage('Password must be 8-72 characters')
    .matches(/[A-Za-z]/)
    .withMessage('Password must contain a letter')
    .matches(/[0-9]/)
    .withMessage('Password must contain a number'),
  body('phone')
    .optional({ values: 'falsy' })
    .trim()
    .matches(/^\+?[0-9\s-]{7,20}$/)
    .withMessage('Phone number is not valid'),
];

// POST /api/auth/register - create a new customer account
router.post('/register', registerRules, async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array().map((e) => ({ field: e.path, message: e.msg })) });
  }

  const { full_name, email, password, phone } = req.body;
  const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);

  try {
    // Parameterised query ($1, $2...) prevents SQL injection.
    // Role is always 'customer' here - it is never taken from the request body.
    const result = await pool.query(
      `INSERT INTO users (full_name, email, phone, password_hash, role)
       VALUES ($1, $2, $3, $4, 'customer')
       RETURNING id, full_name, email, phone, role, created_at`,
      [full_name, email, phone || null, passwordHash]
    );
    return res.status(201).json({ user: result.rows[0] });
  } catch (err) {
    // 23505 = unique_violation (email already registered)
    if (err.code === '23505') {
      return res.status(409).json({ error: 'Email is already registered' });
    }
    throw err;
  }
});

module.exports = router;
