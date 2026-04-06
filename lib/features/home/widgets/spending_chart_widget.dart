import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/shared/providers/index.dart';

/// Spending by Category Chart Widget
class SpendingChartWidget extends StatelessWidget {
  final TransactionState state;

  const SpendingChartWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final expensesByCategory = <String, double>{};

    for (var transaction in state.transactions) {
      if (transaction.type == TransactionType.expense) {
        expensesByCategory[transaction.category] =
            (expensesByCategory[transaction.category] ?? 0) + transaction.amount;
      }
    }

    if (expensesByCategory.isEmpty) {
      return const SizedBox.shrink();
    }

    const colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    final pieChartSectionData = expensesByCategory.entries.map((entry) {
      final colorIndex = expensesByCategory.keys.toList().indexOf(entry.key) % colors.length;

      return PieChartSectionData(
        color: colors[colorIndex],
        radius: 30,
        titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.spendingByCategory,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            const Gap(12),
            Expanded(
              child: SizedBox(
                height: 150,
                child: PieChart(PieChartData(sections: pieChartSectionData)),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: expensesByCategory.entries.map((entry) {
                  final colorIndex = expensesByCategory.keys.toList().indexOf(entry.key) % colors.length;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[colorIndex],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
