import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/domain/entities/transaction.dart';

/// Top Spending Category Widget
class TopCategoryWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const TopCategoryWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expensesByCategory = <String, double>{};

    for (var transaction in transactions) {
      if (transaction.type == 'Expense') {
        expensesByCategory[transaction.category] =
            (expensesByCategory[transaction.category] ?? 0) + transaction.amount;
      }
    }

    if (expensesByCategory.isEmpty) {
      return const SizedBox.shrink();
    }

    final topCategory = expensesByCategory.entries.reduce((a, b) => a.value > b.value ? a : b);
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.topCategory,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${TransactionCategory.icons[topCategory.key]} ${topCategory.key}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                currencyFormat.format(topCategory.value),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
