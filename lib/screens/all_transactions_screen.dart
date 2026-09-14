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
  ConsumerState<AllTransactionsScreen> createState() =>
      _AllTransactionsScreenState();
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
            // Header & Search Bar
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Transactions',
                    style: TextStyle(
                      fontSize: 22.spMin,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  3.verticalSpace,
                  Text(
                    'Search and filter your expense history',
                    style: TextStyle(
                      fontSize: 12.spMin,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  14.verticalSpace,

                  // Modern, flat search field
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFF2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim().toLowerCase();
                        });
                      },
                      style: TextStyle(fontSize: 13.spMin, color: Colors.black),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search by title...',
                        hintStyle: TextStyle(
                          fontSize: 13.spMin,
                          color: Colors.black38,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.black45,
                          size: 20.spMin,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.black45,
                                  size: 18.spMin,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Flatter, compact category filter pills
            SizedBox(
              height: 34.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _FilterPill(
                    label: 'All',
                    isSelected: _selectedCategory == 'All',
                    onTap: () => setState(() => _selectedCategory = 'All'),
                  ),
                  ...AppConstants.categories.map((cat) {
                    return _FilterPill(
                      label: cat,
                      emoji: AppConstants.categoryEmojis[cat],
                      isSelected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  }),
                ],
              ),
            ),

            10.verticalSpace,

            // Transaction List with Pull-To-Refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(expenseListProvider.notifier).refresh(),
                child: expensesAsync.when(
                  data: (expenses) {
                    final filtered = expenses.where((e) {
                      final matchesQuery =
                          _searchQuery.isEmpty ||
                          e.title.toLowerCase().contains(_searchQuery);
                      final matchesCategory =
                          _selectedCategory == 'All' ||
                          (e.category ?? 'Other') == _selectedCategory;
                      return matchesQuery && matchesCategory;
                    }).toList();

                    if (filtered.isEmpty) {
                      return ListView(
                        children: [
                          SizedBox(height: 100.h),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _searchQuery.isNotEmpty
                                      ? Icons.search_off_rounded
                                      : Icons.receipt_long_rounded,
                                  size: 42.spMin,
                                  color: Colors.black26,
                                ),
                                12.verticalSpace,
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No transactions found for "$_searchQuery"'
                                      : 'No transactions in this category',
                                  style: TextStyle(
                                    fontSize: 13.spMin,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    // Group by date (e.g. "THU, 20 JUL")
                    final Map<String, List<Expense>> grouped = {};
                    for (final exp in filtered) {
                      final dateKey = DateFormat('EEE, d MMM')
                          .format(exp.createdAt.toLocal())
                          .toUpperCase();
                      grouped.putIfAbsent(dateKey, () => []).add(exp);
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: grouped.length,
                      itemBuilder: (context, groupIndex) {
                        final dateHeader = grouped.keys.elementAt(groupIndex);
                        final itemsInGroup = grouped[dateHeader]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                20.w,
                                14.h,
                                20.w,
                                6.h,
                              ),
                              child: Text(
                                dateHeader,
                                style: TextStyle(
                                  fontSize: 11.spMin,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            ...itemsInGroup.map((expense) {
                              return ExpenseListItem(
                                expense: expense,
                                onTap: () =>
                                    context.push('/detail/${expense.id}'),
                              );
                            }),
                          ],
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => _ErrorState(
                    errorMessage: e.toString(),
                    onRetry: () =>
                        ref.read(expenseListProvider.notifier).refresh(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Flat, compact filter pill that matches the FAB's green & black language
class _FilterPill extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
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
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(right: 6.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          // Active: Lime (#CEF175) matching the FAB. Inactive: Flat soft grey (#EFEFF2)
          color: isSelected ? const Color(0xFFCEF175) : const Color(0xFFEFEFF2),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFB5DF40) : Colors.transparent,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: TextStyle(fontSize: 11.spMin)),
              4.horizontalSpace,
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5.spMin,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorState({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 32.spMin,
                color: const Color(0xFFE53935),
              ),
            ),
            12.verticalSpace,
            Text(
              'Connection Error',
              style: TextStyle(
                fontSize: 16.spMin,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            6.verticalSpace,
            Text(
              errorMessage.contains('Connection refused')
                  ? 'Could not connect to the backend server. Ensure the server is running on port 3000.'
                  : errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.spMin,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            16.verticalSpace,
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCEF175), // Matching FAB
                foregroundColor: Colors.black,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
