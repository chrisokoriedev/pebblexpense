# Pulse - Expense Tracker

Pulse is a simple Flutter expense tracker app that demonstrates state management, network requests, and clean architecture, created as a take-home exercise.

## Getting Started

### 1. Start the Local API (json-server)
To ensure the API is always available and doesn't expire (unlike crudcrud.com), a local `json-server` is provided.

Requirements: Node.js (v14+ recommended)

```bash
cd server
npm install
npm start
```
The mock API will run on `http://localhost:3000`.

### 2. Run the Flutter App
Ensure the API is running, then in a new terminal:
```bash
flutter pub get
flutter run
```
*Note: The app is currently configured to point to `127.0.0.1:3000` which works on Desktop and Web. If running on an Android emulator, you may need to update `baseUrl` in `lib/core/api_client.dart` to `10.0.2.2:3000`.*

## State Management Choice: Riverpod
I chose **Riverpod** (specifically `AsyncNotifier`) for state management.
- **Why?** It perfectly handles asynchronous data streams natively (loading, data, and error states) without writing boilerplate `isLoading` flags.
- It provides built-in caching, easy pull-to-refresh (`ref.refresh`), and declarative dependency injection, making it highly testable and robust for modern Flutter apps.

## Trade-offs & Future Improvements
Given the time constraint (4-6 hours), I made a few intentional trade-offs:
1. **Simple API Client instead of Dio:** I used the built-in `http` package wrapped in a simple `ApiClient` class to keep dependencies minimal. With more time, I would use `Dio` with interceptors for robust error handling, token injection, and retry logic.
2. **Basic Error Handling in UI:** The error states and snackbars are functional but could be styled better. A global error handler or a centralized dialog manager would be better for a production app.
3. **Optimistic Updates without persistence:** When deleting or adding, the UI updates optimistically. However, if the app goes offline, these requests will just fail. With more time, I would implement local persistence (e.g., Hive or SQLite) for an offline-first experience with a sync queue.
