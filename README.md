# Pulse - Expense Tracker (PebbleScore Take-Home)

Pulse is a Flutter expense tracker app featuring clean architecture, Riverpod state management, responsive UI, and full integration with the **PebbleScore Pulse Mock API**.

---

## PebbleScore Pulse API Specification

### Base URL
- **Local Mock Server:** `http://127.0.0.1:3000` (or `http://10.0.2.2:3000` for Android Emulator)
- **Live Endpoint:** `https://pebblescore-api.dev.pebblescore.com/api/{bucket}/expenses`

Replace `{bucket}` with any string (e.g. `amaka` or your name) so data remains isolated. A new bucket is created automatically on first call, pre-populated with realistic sample expenses.

### Endpoints
| Method | Path | Purpose | Success Status |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/{bucket}/expenses` | List all expenses | `200 OK` |
| `GET` | `/api/{bucket}/expenses/{id}` | Fetch one expense by id | `200 OK` |
| `POST` | `/api/{bucket}/expenses` | Create an expense (server assigns `id` and `createdAt`) | `201 Created` |
| `DELETE` | `/api/{bucket}/expenses/{id}` | Delete an expense by id | `204 No Content` |

### Expense Object
- `id` (`string`): Server-generated short id with `exp_` prefix (e.g. `exp_a1b2c3d4`). Ignored if sent on POST.
- `title` (`string`): Required, non-empty. Empty titles return `400 Bad Request`.
- `amountKobo` (`integer`): Required whole number of kobo (`1 NGN = 100 kobo`). Non-integers or negative amounts return `400 Bad Request`.
- `category` (`string | null`): One of: `Food`, `Transport`, `Bills`, `Other`, or `null`. Invalid non-null values return `400 Bad Request`.
- `createdAt` (`string`): Server-generated ISO-8601 UTC timestamp. Ignored if sent on POST.

### Optional Request Headers
- `X-Force-Error: 500`: Forces a single `500 Internal Server Error` `{ "error": "internal error" }`.
- `X-Delay: <milliseconds>`: Pauses server execution before returning a response.

---

## Getting Started

### 1. Start the Backend Mock Server
The repository comes with a full Express mock server that implements the PebbleScore specification:

```bash
cd server
npm install
npm start
```
The mock API will be live at `http://localhost:3000`.

To run the automated backend test suite verifying all 27 endpoint test cases:
```bash
npm test
```

### 2. Run the Flutter App
In the project root:
```bash
flutter pub get
flutter run
```

To run the Flutter unit tests:
```bash
flutter test
```

---

## State Management & Architecture
- **Riverpod (AsyncNotifier):** Manages asynchronous data streams (loading, data, error) declaratively with optimistic caching.
- **Clean Model Mapping:** Uses Freezed & JSON Serializable for immutable models.
- **Typed Error Handling:** Extracts `{ "error": "..." }` responses from the API and displays meaningful feedback.
