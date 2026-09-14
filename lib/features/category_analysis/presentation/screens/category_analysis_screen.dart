import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/features/category_analysis/controller/category_analysis_controller.dart';
import 'package:pebblexpense/features/category_analysis/presentation/widgets/category_detail_card.dart';
import 'package:pebblexpense/features/category_analysis/presentation/widgets/segmented_distribution_card.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/error_state_card.dart';

class CategoryAnalysisScreen extends ConsumerWidget {
  const CategoryAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);
    final analysisData = ref.watch(categoryAnalysisProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(expenseListProvider.notifier).refresh(),
          child: expensesAsync.when(
            data: (_) {
              if (analysisData == null || analysisData.totalKobo == 0) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 120.h),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pie_chart_outline_rounded,
                            size: 48.spMin,
                            color: Colors.black26,
                          ),
                          12.verticalSpace,
                          Text(
                            'No categories to analyze yet.\nAdd some expenses to see the breakdown!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.spMin,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category Analysis',
                      style: TextStyle(
                        fontSize: 22.spMin,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      'Distribution of your spending across categories',
                      style: TextStyle(
                        fontSize: 12.spMin,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    16.verticalSpace,
                    SegmentedDistributionCard(data: analysisData),
                    20.verticalSpace,
                    Text(
                      'Category Breakdown',
                      style: TextStyle(
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,
                    ...analysisData.breakdownItems.map(
                      (item) => CategoryDetailCard(item: item),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (e, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    ErrorStateCard(
                      errorMessage: e.toString(),
                      onRetry:
                          () =>
                              ref.read(expenseListProvider.notifier).refresh(),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
