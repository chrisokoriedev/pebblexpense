import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';
import 'package:pebblexpense/features/expenses/controller/transaction_filter_controller.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/error_state_card.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/filter_pill.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/transaction_grouped_list.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/transaction_search_bar.dart';

class AllTransactionsScreen extends ConsumerStatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  ConsumerState<AllTransactionsScreen> createState() =>
      _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends ConsumerState<AllTransactionsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(transactionFilterControllerProvider);
    _searchController = TextEditingController(text: filter.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(transactionFilterControllerProvider);
    final groupedAsync = ref.watch(groupedTransactionsProvider);
    final filterNotifier = ref.read(
      transactionFilterControllerProvider.notifier,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  TransactionSearchBar(
                    controller: _searchController,
                    showClear: filter.searchQuery.isNotEmpty,
                    onChanged: filterNotifier.setSearchQuery,
                    onClear: () {
                      _searchController.clear();
                      filterNotifier.clearSearch();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 34.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  FilterPill(
                    label: 'All',
                    isSelected: filter.selectedCategory == 'All',
                    onTap: () => filterNotifier.setSelectedCategory('All'),
                  ),
                  ...AppConstants.categories.map(
                    (cat) => FilterPill(
                      label: cat,
                      emoji: AppConstants.categoryEmojis[cat],
                      isSelected: filter.selectedCategory == cat,
                      onTap: () => filterNotifier.setSelectedCategory(cat),
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: RefreshIndicator(
                onRefresh:
                    () => ref.read(expenseListProvider.notifier).refresh(),
                child: groupedAsync.when(
                  data:
                      (grouped) => TransactionGroupedList(
                        grouped: grouped,
                        query: filter.searchQuery,
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (e, _) => ErrorStateCard(
                        errorMessage: e.toString(),
                        onRetry:
                            () => ref
                                .read(expenseListProvider.notifier)
                                .refresh(),
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
