# Pulse - Expense Tracker

A Flutter expense tracking application built with Riverpod and clean architecture, connected to a local Express mock backend matching the PebbleScore Pulse API specification.

## How to Start the Backend Server

The backend mock server runs with Node.js at `http://127.0.0.1:3000`:

```bash
cd server
npm install
npm start
```

*To verify all 27 endpoint test cases:*
```bash
npm test
```

## How to Run the Flutter App

In the project root directory:

```bash
flutter pub get
flutter run
```

*To run Flutter unit tests:*
```bash
flutter test
```

## API & Bucket Reference

- **Base URL:** `http://127.0.0.1:3000/api/{bucket}/expenses` (or live dev: `https://pebblescore-api.dev.pebblescore.com`)
- **Bucket Isolation:** Use any bucket string (defaults to `amaka`). New buckets auto-seed with sample expenses.
- **Supported Endpoints:**
  - `GET /api/{bucket}/expenses` - List expenses (200)
  - `GET /api/{bucket}/expenses/{id}` - Fetch single expense (200)
  - `POST /api/{bucket}/expenses` - Create expense (`title`, `amountKobo`, `category`) (201)
  - `DELETE /api/{bucket}/expenses/{id}` - Delete expense (204)
