import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/widgets/expense_list_item.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expenseListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(expenseListProvider.notifier).build(),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _TopHeader()),
              const SliverToBoxAdapter(child: _BalanceSection()),
              const SliverToBoxAdapter(child: _ActionRow()),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View all >',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildTransactionList(context, state, ref),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _MockBottomNavBar(),
    );
  }

  Widget _buildTransactionList(BuildContext context, AsyncValue state, WidgetRef ref) {
    return state.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text('No transactions yet.', style: TextStyle(color: Colors.black54)),
              ),
            ),
          );
        }

        // We can optionally group by date here. For simplicity, just display as a list with a "TODAY" header mock.
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    ExpenseListItem(
                      expense: expenses[0],
                      onTap: () => context.push('/detail/${expenses[0].id}'),
                    ),
                  ],
                );
              }
              final expense = expenses[index];
              return ExpenseListItem(
                expense: expense,
                onTap: () => context.push('/detail/${expense.id}'),
              );
            },
            childCount: expenses.length,
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Text('Error: $e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(expenseListProvider.notifier).build(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
          ),
          const Text(
            'My Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.black),
                  onPressed: () {},
                ),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFCEF175), // Lime green
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceSection extends ConsumerWidget {
  const _BalanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmountKobo = ref.watch(totalExpensesProvider);
    final formatCurrency = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    final totalText = formatCurrency.format(totalAmountKobo / 100);

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFCEF175),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text('**** 3425'),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Your Balance',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          totalText,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0FF), // Light purple hint
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.savings, size: 14, color: Color(0xFF7B61FF)),
              SizedBox(width: 6),
              Text(
                'You saved ₦2,900 in last Month >',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B61FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            icon: Icons.arrow_outward,
            label: 'Add Expense',
            isPrimary: true,
            onTap: () => context.push('/add'),
          ),
          _ActionButton(
            icon: Icons.south_west,
            label: 'Request',
            onTap: () {},
          ),
          _ActionButton(
            icon: Icons.swap_horiz,
            label: 'Exchange',
            onTap: () {},
          ),
          _ActionButton(
            icon: Icons.more_horiz,
            label: 'More',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary ? const Color(0xFFCEF175) : Colors.white;
    
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: bgColor,
            child: Icon(icon, color: Colors.black, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MockBottomNavBar extends StatelessWidget {
  const _MockBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomNavItem(icon: Icons.home_outlined, label: 'Home', isActive: true),
            _BottomNavItem(icon: Icons.insert_chart_outlined, label: 'Statistic'),
            _BottomNavItem(icon: Icons.crop_free, label: 'Scan', isCenter: true),
            _BottomNavItem(icon: Icons.credit_card_outlined, label: 'Card'),
            _BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCenter;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: const Color(0xFFCEF175),
        child: Icon(icon, color: Colors.black),
      );
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.black : Colors.black45),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.black : Colors.black45,
          ),
        ),
      ],
    );
  }
}
