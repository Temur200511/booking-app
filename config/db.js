const { Pool } = require('pg');

// One shared pool of database connections for the whole app.
// In production (DATABASE_SSL=true) the connection is encrypted with TLS and
// the database server's certificate is verified, preventing man-in-the-middle attacks.
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_SSL === 'true' ? { rejectUnauthorized: true } : false,
});

module.exports = pool;
