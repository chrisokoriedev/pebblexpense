import 'package:go_router/go_router.dart';
import 'package:pebblexpense/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:pebblexpense/features/expenses/presentation/screens/expense_detail_screen.dart';
import 'package:pebblexpense/features/expenses/presentation/screens/expense_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ExpenseListScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ExpenseDetailScreen(expenseId: id);
      },
    ),
  ],
);

// Backward compatible alias
final router = appRouter;
