import 'package:finmate/core/router/route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/shared/widgets/empty_state_widget.dart';
import 'package:finmate/features/transactions/widgets/transaction_item.dart';
import 'package:finmate/features/shared/providers/index.dart';

/// Recent Transactions Widget
class RecentTransactionsWidget extends StatelessWidget {
  final TransactionState state;

  const RecentTransactionsWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final recentTransactions = state.transactions.take(5).toList();
    final dateFormat = DateFormat(AppConstants.dateFormat);
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    if (recentTransactions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.recentTransactions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          EmptyStateWidget(
            message: AppStrings.noTransactionsYet,
            icon: Icons.receipt,
            actionLabel: AppStrings.addTransaction,
            onAction: () => Navigator.pushNamed(context, AppRoutes.transactions),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.recentTransactions,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: recentTransactions.map((transaction) {
              return TransactionItem(
                category: transaction.category,
                amount: currencyFormat.format(transaction.amount),
                date: dateFormat.format(transaction.date),
                type: transaction.type,
                isExpense: transaction.type == TransactionType.expense,
                onTap: () => Navigator.pushNamed(context, '${AppRoutes.transactionDetail}?id=${transaction.id}'),
              );
            }).toList(),
          ),
        ),
        const Gap(12),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.transactions),
            child: const Text('View All Transactions'),
          ),
        ),
      ],
    );
  }
}
