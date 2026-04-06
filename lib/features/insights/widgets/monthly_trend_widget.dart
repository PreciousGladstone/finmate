import 'package:finmate/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/domain/entities/transaction.dart';
import 'chart_header.dart';
import 'chart_subtitle.dart';
import 'spending_line_chart.dart';

/// Monthly Trend Widget
class MonthlyTrendWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const MonthlyTrendWidget({super.key, required this.transactions});

  Map<String, double> _calculateMonthlyData() {
    final monthlyData = <String, double>{};
    for (int i = 5; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: 30 * i));
      final monthKey = DateFormat('MMM').format(date);
      monthlyData[monthKey] = 0;
    }

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        final monthKey = DateFormat('MMM').format(transaction.date);
        if (monthlyData.containsKey(monthKey)) {
          monthlyData[monthKey] = monthlyData[monthKey]! + transaction.amount;
        }
      }
    }
    return monthlyData;
  }

  @override
  Widget build(BuildContext context) {
    final monthlyData = _calculateMonthlyData();
    final maxValue = monthlyData.values.fold<double>(0, (a, b) => a > b ? a : b);
    final minValue = monthlyData.values.fold<double>(double.infinity, (a, b) => a < b ? a : b);
    final actualMin = minValue == double.infinity ? 0.0 : minValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ChartHeader(),
        const Gap(4),
        const ChartSubtitle(),
        const Gap(12),
        SpendingLineChart(
          monthlyData: monthlyData,
          maxValue: maxValue,
          actualMin: actualMin,
        ),
      ],
    );
  }
}
