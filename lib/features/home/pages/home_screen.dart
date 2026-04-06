import 'package:finmate/features/shared/widgets/index.dart';
import 'package:finmate/features/home/widgets/summary_cards_widget.dart';
import 'package:finmate/features/home/widgets/monthly_goal_widget.dart';
import 'package:finmate/features/home/widgets/spending_chart_widget.dart';
import 'package:finmate/features/home/widgets/recent_transactions_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/shared/providers/index.dart';

/// Home Dashboard Screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      ref.read(transactionProvider.notifier).loadTransactions();
      ref.read(goalProvider.notifier).loadGoals();
    });
  }

  void _refresh() async {
    await ref.read(transactionProvider.notifier).loadTransactions();
    await ref.read(goalProvider.notifier).loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ref.watch(transactionProvider).when(
        loading: () => const LoadingWidget(),
        error: (e, st) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(transactionProvider),
        ),
        data: (transState) => ref.watch(goalProvider).when(
          loading: () => const LoadingWidget(),
          error: (e, st) => AppErrorWidget(
            message: e.toString(),
            onRetry: () => ref.refresh(goalProvider),
          ),
          data: (goalState) => RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryCardsWidget(state: transState),
                  const Gap(AppConstants.largePadding),
                  MonthlyGoalWidget(state: goalState),
                  const Gap(AppConstants.largePadding),
                  SpendingChartWidget(state: transState),
                  const Gap(AppConstants.largePadding),
                  RecentTransactionsWidget(state: transState),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
