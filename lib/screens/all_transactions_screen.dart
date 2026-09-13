import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/widgets/expense_list_item.dart';

class AllTransactionsScreen extends ConsumerStatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  ConsumerState<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends ConsumerState<AllTransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Title & Search Section
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Transactions',
                    style: TextStyle(
                      fontSize: 24.spMin,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'Search and filter your entire expense history',
                    style: TextStyle(
                      fontSize: 13.spMin,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  16.verticalSpace,

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim().toLowerCase();
                        });
                      },
                      style: TextStyle(fontSize: 14.spMin, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search by title or merchant...',
                        hintStyle: TextStyle(fontSize: 14.spMin, color: Colors.black38),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.black45, size: 22.spMin),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.black45),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Category Filter Chips
            SizedBox(
              height: 46.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedCategory == 'All',
                    onTap: () => setState(() => _selectedCategory = 'All'),
                  ),
                  ...AppConstants.categories.map((cat) {
                    return _FilterChip(
                      label: cat,
                      emoji: AppConstants.categoryEmojis[cat],
                      isSelected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  }),
                ],
              ),
            ),

            8.verticalSpace,

            // Transaction List
            Expanded(
              child: expensesAsync.when(
                data: (expenses) {
                  // Filter by search query & category
                  final filtered = expenses.where((e) {
                    final matchesQuery = _searchQuery.isEmpty ||
                        e.title.toLowerCase().contains(_searchQuery);
                    final matchesCategory = _selectedCategory == 'All' ||
                        (e.category ?? 'Other') == _selectedCategory;
                    return matchesQuery && matchesCategory;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.receipt_long_rounded,
                              size: 48.spMin,
                              color: Colors.black26,
                            ),
                            12.verticalSpace,
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No transactions found for "$_searchQuery"'
                                  : 'No transactions in this category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.spMin,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Group by date (e.g. "THU, 20 JUL" matching screenshot)
                  final Map<String, List<Expense>> grouped = {};
                  for (final exp in filtered) {
                    final dateKey = DateFormat('EEE, d MMM').format(exp.createdAt.toLocal()).toUpperCase();
                    grouped.putIfAbsent(dateKey, () => []).add(exp);
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 24.h),
                    itemCount: grouped.length,
                    itemBuilder: (context, groupIndex) {
                      final dateHeader = grouped.keys.elementAt(groupIndex);
                      final itemsInGroup = grouped[dateHeader]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header matching reference screenshot: "THU, 20 JUL"
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 6.h),
                            child: Text(
                              dateHeader,
                              style: TextStyle(
                                fontSize: 11.spMin,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          ...itemsInGroup.map((expense) {
                            return ExpenseListItem(
                              expense: expense,
                              onTap: () => context.push('/detail/${expense.id}'),
                            );
                          }),
                        ],
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: TextStyle(fontSize: 13.spMin)),
              6.horizontalSpace,
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.spMin,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
