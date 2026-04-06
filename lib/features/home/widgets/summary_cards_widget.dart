import 'package:finmate/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/shared/widgets/stat_card.dart';
import 'package:finmate/features/shared/providers/index.dart';

/// Summary Cards Widget - Balance, Income, Expense
class SummaryCardsWidget extends StatelessWidget {
  final TransactionState state;

  const SummaryCardsWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹');
    return Column(
      children: [
        StatCard(
          label: AppStrings.balance,
          value: currencyFormat.format(state.balance),
          color: AppColors.primaryDefault,
          icon: Icons.account_balance_wallet,
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: AppStrings.income,
                value: currencyFormat.format(state.income),
                color: AppColors.successDefault,
                icon: Icons.trending_up,
              ),
            ),
            const Gap(12),
            Expanded(
              child: StatCard(
                label: AppStrings.expense,
                value: currencyFormat.format(state.expense),
                color: AppColors.errorDefault,
                icon: Icons.trending_down,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
