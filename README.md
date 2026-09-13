# Pulse — Personal Expense Tracker

Pulse is a production-grade personal expense tracker built with Flutter, Riverpod, and Clean Architecture. It connects to the PebbleScore Pulse API (or included local mock server) to manage expenses in Nigerian Naira with real-time running totals, robust error recovery, and seamless optimistic UI updates.

---

## Architecture Overview

The codebase is organized following Clean Architecture principles and feature-first modularity:

```
lib/
├── core/
│   ├── api_client.dart          # HTTP client, error decoding, custom headers (X-Force-Error, X-Delay)
│   ├── constants/               # API endpoints, design tokens, strings, paddings
│   ├── routes.dart              # GoRouter declarative navigation
│   └── utils.dart               # Kobo-to-Naira currency formatting, dates, category helpers
├── models/
│   ├── expense.dart             # Freezed immutable expense entity
│   ├── create_expense_dto.dart  # POST payload DTO (ensuring no id/createdAt sent)
│   └── expenses_response.dart   # GET list response DTO
├── providers/
│   ├── expense_provider.dart    # Riverpod AsyncNotifier: add, optimistic delete, rollback, total
│   └── expense_provider.g.dart  # Riverpod generated code
├── repositories/
│   └── expense_repository.dart  # Abstract repository & implementation
├── screens/
│   ├── expense_list_screen.dart # Home dashboard with pull-to-refresh & navigation
│   ├── add_expense_screen.dart  # Form validation & custom numpad entry
│   ├── expense_detail_screen.dart # Single item inspection & deletion modal
│   └── stats_screen.dart        # Category breakdowns & spending analytics
└── widgets/                     # Reusable UI components (BalanceSection, TransactionList, etc.)
```

---

## Getting Started

### 1. Start the Mock Backend Server

A Node.js mock server implementing 100% of the PebbleScore Pulse API specification is provided in `/server`:

```bash
cd server
npm install
npm start
```
The server will run at `http://127.0.0.1:3000`.

*To verify all 27 API tests (including validation, X-Force-Error, and X-Delay):*
```bash
npm test
```

### 2. Run the Flutter App

In the project root:

```bash
flutter pub get
flutter run
```

*To run Flutter unit and provider tests:*
```bash
flutter test
```

---

## State Management Choice & Rationale

We chose **Riverpod 2 (with code-generation & `AsyncNotifier`)** for this project.

### Why Riverpod over BLoC or Provider?
1. **Compile-Time Safety & Zero `BuildContext` Coupling**:
   Unlike standard `Provider`, Riverpod providers are global compile-time constants. Notifiers and repositories can be tested purely with `ProviderContainer` without mocking widget trees or context.
2. **First-Class Async State (`AsyncValue`)**:
   `AsyncNotifier` handles `data`, `loading`, and `error` states out of the box. Using `.when()` in widgets eliminates boilerplate for error banners and retry buttons.
3. **Targeted Re-renders & Computed State**:
   The running total (`totalExpensesProvider`) is a derived provider that automatically recalculates whenever the expense list changes, without triggering unnecessary rebuilds of list items.
4. **Clean Optimistic Updates & Rollback**:
   Deleting an item removes it immediately from local state for instant feedback, and cleanly rolls back if the network request fails. Adding an expense updates the list directly from the POST response without requiring an expensive full-list refetch.

---

## Trade-offs & What We Would Do With More Time

1. **Local Persistence & Offline-First Sync**:
   - *Trade-off*: Currently, state lives in memory and syncs with the remote API. If the app restarts without internet, previously fetched expenses are not cached on disk.
   - *With More Time*: Integrate **Drift (SQLite)** or **Hive** as a local database layer, with an outbox sync queue that caches mutations when offline and reconciles them when connectivity resumes.

2. **Pagination & Infinite Scrolling**:
   - *Trade-off*: The API returns all expenses in a single response (`/api/{bucket}/expenses`). For thousands of expenses, fetching the entire list would become inefficient.
   - *With More Time*: Implement cursor-based or offset-based pagination (`limit` and `offset`) on both the backend and a Sliver-based infinite scroll in Flutter.

3. **Custom Numpad vs. System Keyboard**:
   - *Trade-off*: We built a custom FinTech numpad for `AddExpenseScreen` to ensure a consistent mobile experience and prevent invalid decimal entry. However, it does not support native paste or hardware keyboard input on web/desktop.
   - *With More Time*: Support adaptive inputs (custom numpad on mobile touchscreens, native `TextField` with input formatters on desktop/web).

---

## Walkthrough / Presentation Guide (3–5 min)

For the screen recording walkthrough:
1. **App Demonstration**:
   - Launch app: view sample expenses pre-populated from the bucket, formatted in Nigerian Naira (`₦`).
   - Pull-to-refresh to fetch fresh data.
   - Add a new expense: demonstrate title validation, numpad input, and instant list update without full reload.
   - Tap an expense: open detail screen, trigger delete confirmation modal, and verify removal from list and updated running total.
   - Switch to Stats tab: view spending breakdown by category.
2. **Code Highlight (Proud of)**:
   - `lib/providers/expense_provider.dart`: Show the `ExpenseList` notifier demonstrating how optimistic updates, error rollbacks, and derived totals work seamlessly.
3. **Code Highlight (Would Change)**:
   - Offline-first cache: Discuss replacing the direct network repository calls with a repository that reads from local DB and syncs in the background.
