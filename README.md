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

> **Device/emulator connectivity:** On startup the app races all known API hosts in parallel — `http://10.0.2.2:3000` (works from Android emulators out of the box) and `http://127.0.0.1:3000` — and uses whichever answers first (2s cap). On a **physical device**, `127.0.0.1` is the phone itself, so bridge the PC server over USB once per connection:
>
> ```bash
> adb reverse tcp:3000 tcp:3000
> ```
>
> The winning host is cached for the session; if nothing answers, the next request re-probes.

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
