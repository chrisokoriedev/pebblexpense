const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const app = express();
const PORT = process.env.PORT || 3000;
const DB_FILE = path.join(__dirname, 'db.json');

// Middleware
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'X-Force-Error', 'X-Delay']
}));
app.use(express.json());

// In-memory bucket store
let buckets = {};

function getSampleExpenses() {
  const now = Date.now();
  return [
    {
      id: `exp_${crypto.randomBytes(4).toString('hex')}`,
      title: 'Bolt to office',
      amountKobo: 320000,
      category: 'Transport',
      createdAt: new Date(now - 2 * 86400000).toISOString()
    },
    {
      id: `exp_${crypto.randomBytes(4).toString('hex')}`,
      title: 'Groceries',
      amountKobo: 1255050,
      category: 'Food',
      createdAt: new Date(now - 86400000).toISOString()
    },
    {
      id: `exp_${crypto.randomBytes(4).toString('hex')}`,
      title: 'Internet Subscription',
      amountKobo: 2500000,
      category: 'Bills',
      createdAt: new Date(now - 4 * 3600000).toISOString()
    }
  ];
}

// Load from db.json
function loadDatabase() {
  try {
    if (fs.existsSync(DB_FILE)) {
      const data = JSON.parse(fs.readFileSync(DB_FILE, 'utf-8'));
      if (data.buckets && typeof data.buckets === 'object') {
        buckets = data.buckets;
      } else if (Array.isArray(data.expenses)) {
        // Migrate legacy flat db.json
        buckets = {
          default: data.expenses,
          amaka: data.expenses.slice()
        };
      }
    }
  } catch (err) {
    console.warn('Could not read db.json, starting with empty store:', err.message);
    buckets = {};
  }
}

// Save to db.json
function saveDatabase() {
  try {
    fs.writeFileSync(DB_FILE, JSON.stringify({ buckets }, null, 2), 'utf-8');
  } catch (err) {
    console.error('Error saving db.json:', err.message);
  }
}

loadDatabase();

// Ensure bucket exists or initialize with sample data
function getOrCreateBucket(bucketName) {
  if (!buckets[bucketName]) {
    buckets[bucketName] = getSampleExpenses();
    saveDatabase();
  }
  return buckets[bucketName];
}

// Middleware for X-Force-Error and X-Delay
app.use(async (req, res, next) => {
  // Handle X-Force-Error: 500
  const forceError = req.header('X-Force-Error');
  if (forceError === '500') {
    return res.status(500).json({ error: 'internal error' });
  }

  // Handle X-Delay: <ms>
  const delay = req.header('X-Delay');
  if (delay) {
    const delayMs = parseInt(delay, 10);
    if (!isNaN(delayMs) && delayMs > 0) {
      await new Promise((resolve) => setTimeout(resolve, delayMs));
    }
  }

  next();
});

// Root / Health check
app.get('/', (req, res) => {
  res.json({
    name: 'PebbleScore Pulse Mock API',
    status: 'running',
    reference: 'https://pebblescore-api.dev.pebblescore.com/api/{bucket}/expenses'
  });
});

// GET /api/:bucket/expenses - List all expenses
app.get('/api/:bucket/expenses', (req, res) => {
  const { bucket } = req.params;
  const expenses = getOrCreateBucket(bucket);
  res.status(200).json({ expenses });
});

// GET /api/:bucket/expenses/:id - Fetch one expense by id
app.get('/api/:bucket/expenses/:id', (req, res) => {
  const { bucket, id } = req.params;
  const expenses = getOrCreateBucket(bucket);
  const expense = expenses.find((e) => e.id === id);

  if (!expense) {
    return res.status(404).json({ error: 'expense not found' });
  }

  res.status(200).json(expense);
});

// POST /api/:bucket/expenses - Create an expense
app.post('/api/:bucket/expenses', (req, res) => {
  const { bucket } = req.params;
  const { title, amountKobo, category } = req.body;

  // Validation: title
  if (typeof title !== 'string' || title.trim() === '') {
    return res.status(400).json({ error: 'title is required' });
  }

  // Validation: amountKobo
  if (
    typeof amountKobo !== 'number' ||
    !Number.isInteger(amountKobo) ||
    amountKobo < 0
  ) {
    return res.status(400).json({ error: 'amountKobo must be a non-negative integer' });
  }

  // Validation: category
  const validCategories = ['Food', 'Transport', 'Bills', 'Other'];
  if (category !== null && category !== undefined && !validCategories.includes(category)) {
    return res.status(400).json({
      error: 'category must be one of: Food, Transport, Bills, Other or null'
    });
  }

  const expenses = getOrCreateBucket(bucket);

  const newExpense = {
    id: `exp_${crypto.randomBytes(4).toString('hex')}`,
    title: title.trim(),
    amountKobo,
    category: category ?? null,
    createdAt: new Date().toISOString()
  };

  expenses.unshift(newExpense);
  saveDatabase();

  res.status(201).json(newExpense);
});

// DELETE /api/:bucket/expenses/:id - Delete an expense by id
app.delete('/api/:bucket/expenses/:id', (req, res) => {
  const { bucket, id } = req.params;
  const expenses = getOrCreateBucket(bucket);
  const index = expenses.findIndex((e) => e.id === id);

  if (index === -1) {
    return res.status(404).json({ error: 'expense not found' });
  }

  expenses.splice(index, 1);
  saveDatabase();

  res.status(204).send();
});

// 404 for unrecognised routes
app.use((req, res) => {
  res.status(404).json({ error: 'expense not found' });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Unhandled server error:', err);
  res.status(500).json({ error: 'internal error' });
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`PebbleScore Pulse Mock API server running on http://127.0.0.1:${PORT}`);
  });
}

module.exports = app;
