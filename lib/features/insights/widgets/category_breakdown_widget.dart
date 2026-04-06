import 'package:finmate/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/domain/entities/transaction.dart';

/// Category Breakdown Widget
class CategoryBreakdownWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const CategoryBreakdownWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expensesByCategory = <String, double>{};

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        expensesByCategory[transaction.category] =
            (expensesByCategory[transaction.category] ?? 0) + transaction.amount;
      }
    }

    if (expensesByCategory.isEmpty) {
      return const SizedBox.shrink();
    }

    final currencyFormat = NumberFormat.currency(symbol: '₹');
    final sortedCategories = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.categoryBreakdown,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              final entry = sortedCategories[index];
              final percentage = (entry.value / expensesByCategory.values.reduce((a, b) => a + b) * 100);

              return Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: index < sortedCategories.length - 1
                          ? Colors.grey[200]!
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${TransactionCategory.icons[entry.key]} ${entry.key}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          currencyFormat.format(entry.value),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 6,
                        backgroundColor: AppColors.grey200,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryDefault),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
