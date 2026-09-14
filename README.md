# Pulse — Personal Expense Tracker

Pulse is a production-grade personal expense tracker built with Flutter and Riverpod using a **Feature-First Architecture** (`core/` + `features/`). It connects to the PebbleScore Pulse API (or included local mock server) to manage expenses in Nigerian Naira with real-time running totals, robust error recovery, and seamless optimistic UI updates.

---

## Architecture Overview

The codebase is organized into **Core** and **Feature-First** modules. Each feature encapsulates its own `data`, `controller`, and `presentation` layers:

```
lib/
├── core/
│   ├── constants/               # API endpoints, design tokens, strings, paddings
│   ├── network/                 # ApiClient, HTTP handling, error decoding
│   ├── router/                  # GoRouter declarative navigation (app_router.dart)
│   ├── theme.dart               # App typography & theme data
│   └── utils/                   # Currency formatting, dates, category helpers
│
└── features/
    ├── expenses/
    │   ├── data/
    │   │   ├── models/          # Freezed immutable entities & DTOs
    │   │   └── repositories/    # IExpenseRepository & implementation
    │   ├── controller/          # ExpenseListController & TransactionFilterController
    │   └── presentation/
    │       ├── screens/         # Dashboard, Add, Detail, All Transactions (< 200 lines)
    │       └── widgets/         # Modular widgets (Numpad, Balance, SearchBar, etc.)
    │
    ├── insights/
    │   ├── controller/          # WeeklyInsightsController (day totals, peak, velocity)
    │   └── presentation/
    │       ├── screens/         # Spending Insights screen
    │       └── widgets/         # WeeklyBarChartCard, MetricGrid, DashedLinePainter
    │
    └── category_analysis/
        ├── controller/          # CategoryAnalysisController (breakdowns, percentages)
        └── presentation/
            ├── screens/         # Category Analysis screen
            └── widgets/         # SegmentedDistributionCard, CategoryDetailCard
```

### Key Highlights
- **Logic Decoupling**: Aggregations, weekly spending trends, category distributions, and date-grouping are handled by Riverpod controllers, keeping widget `build()` methods pure and reactive.
- **Modularity (< 200 Lines)**: Every screen and widget is modularized into dedicated files to ensure readability and maintainability.
- **Optimistic CRUD**: Instant list updates with automatic rollback on network failure.

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

*To run backend test suite:*
```bash
npm test
```

### 2. Run the Flutter App

In the project root:

```bash
flutter pub get
flutter run
```

---

## State Management Rationale

We chose **Riverpod (AsyncNotifier)** for this project:

1. **Compile-Time Safety & Testability**: Global compile-time providers eliminate `BuildContext` coupling and allow testing via `ProviderContainer` without mocking widget trees.
2. **First-Class Async State (`AsyncValue`)**: Built-in handling of data, loading, and error states with `.when()` eliminates boilerplate for loading spinners and retry banners.
3. **Derived Providers**: State like `totalExpensesProvider`, `weeklyInsightsProvider`, and `categoryAnalysisProvider` automatically recompute when expense data updates without rebuilding unrelated widgets.
4. **Optimistic Updates**: Mutations update local state immediately for instant UX feedback and roll back gracefully on server errors.

---

## Trade-offs & Future Enhancements

1. **Offline Persistence**: Currently, state lives in memory and syncs with the remote API. Adding **Drift (SQLite)** with an outbox sync queue would enable full offline capabilities.
2. **Pagination**: The current endpoint returns all expenses in a single response. For large datasets, offset/cursor pagination with infinite scrolling would be beneficial.
3. **Adaptive Input**: The custom FinTech numpad provides a consistent mobile keypad experience; desktop/web could add support for hardware keyboard shortcuts and native text input.

---

## Walkthrough / Presentation Guide (3–5 min)

1. **App Demonstration**:
   - **Home**: Running total, recent transactions, quick actions.
   - **Add Expense**: Title validation, custom numpad, category chips, and instant list update.
   - **Expense Detail**: Inspection and deletion with confirmation modal and optimistic removal.
   - **Insights**: Weekly activity bar chart with daily average guideline and velocity metric cards.
   - **Categories**: Segmented proportion bar and breakdown cards with spending percentages.
   - **All Transactions**: Search by title, filter pills, and grouped date sections.
2. **Code Highlights**:
   - `lib/features/expenses/controller/expense_list_controller.dart`: Shows optimistic mutations, rollback, and derived totals.
   - `lib/features/insights/controller/weekly_insights_controller.dart`: Shows clean decoupled business logic for data aggregation.
