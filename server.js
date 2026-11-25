require('dotenv').config();
const express = require('express');
const servicesRouter = require('./routes/services');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.use('/api/services', servicesRouter);

// Unknown API routes -> 404
app.use('/api', (req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Central error handler -> 500 (details are logged, not sent to the client)
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
