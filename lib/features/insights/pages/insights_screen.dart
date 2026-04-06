import 'package:finmate/core/router/route.dart';
import 'package:finmate/features/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/insights/widgets/top_category_widget.dart';
import 'package:finmate/features/insights/widgets/weekly_comparison_widget.dart';
import 'package:finmate/features/insights/widgets/category_breakdown_widget.dart';
import 'package:finmate/features/insights/widgets/monthly_trend_widget.dart';

/// Insights Screen
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  late DateTime _weekStart;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));

    Future.microtask(() {
      if (!mounted) return;
      ref.read(transactionProvider.notifier).loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.insights),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ref.watch(transactionProvider).when(
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(transactionProvider),
        ),
        data: (state) {
          if (state.transactions.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.analytics_outlined,
              message: 'No transactions to analyze',
              actionLabel: 'Add Transaction',
              onAction: () => Navigator.pushNamed(context, AppRoutes.addTransaction),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopCategoryWidget(transactions: state.transactions),
                const Gap(AppConstants.largePadding),
                WeeklyComparisonWidget(transactions: state.transactions, weekStart: _weekStart),
                const Gap(AppConstants.largePadding),
                CategoryBreakdownWidget(transactions: state.transactions),
                const Gap(AppConstants.largePadding),
                MonthlyTrendWidget(transactions: state.transactions),
              ],
            ),
          );
        },
      ),
    );
  }
}
