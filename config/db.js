const { Pool } = require('pg');

// One shared pool of database connections for the whole app.
// SSL is turned on only when DATABASE_SSL=true (needed for the cloud database later).
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_SSL === 'true' ? { rejectUnauthorized: false } : false,
});

module.exports = pool;
