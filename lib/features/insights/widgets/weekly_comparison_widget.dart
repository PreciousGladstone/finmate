import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/domain/entities/transaction.dart';

/// Weekly Comparison Widget
class WeeklyComparisonWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final DateTime weekStart;

  const WeeklyComparisonWidget({
    super.key,
    required this.transactions,
    required this.weekStart,
  });

  @override
  Widget build(BuildContext context) {
    final thisWeekStart = weekStart;
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    double thisWeekExpense = 0;
    double lastWeekExpense = 0;

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        if (transaction.date.isAfter(thisWeekStart) &&
            transaction.date.isBefore(thisWeekStart.add(const Duration(days: 7)))) {
          thisWeekExpense += transaction.amount;
        } else if (transaction.date.isAfter(lastWeekStart) &&
            transaction.date.isBefore(lastWeekStart.add(const Duration(days: 7)))) {
          lastWeekExpense += transaction.amount;
        }
      }
    }

    final currencyFormat = NumberFormat.currency(symbol: '₹');
    final percentChange =
        lastWeekExpense == 0 ? 0 : ((thisWeekExpense - lastWeekExpense) / lastWeekExpense * 100);

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Comparison',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.thisWeek,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(4),
                  Text(
                    currencyFormat.format(thisWeekExpense),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.lastWeek,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(4),
                  Text(
                    currencyFormat.format(lastWeekExpense),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: percentChange > 0 ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              percentChange > 0
                  ? '↑ ${percentChange.toStringAsFixed(1)}% increase'
                  : '↓ ${percentChange.abs().toStringAsFixed(1)}% decrease',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: percentChange > 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
