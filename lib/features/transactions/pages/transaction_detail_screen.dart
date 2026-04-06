import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/themes/app_color.dart';
import 'package:finmate/core/utils/helpers/snackbar_helper.dart';
import 'package:finmate/domain/entities/transaction.dart';
import 'package:finmate/features/shared/providers/index.dart';

/// Transaction Detail Screen
class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionProvider);

    return transactionAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, st) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (state) {
        Transaction? transaction;
        for (final t in state.transactions) {
          if (t.id == transactionId) {
            transaction = t;
            break;
          }
        }

        if (transaction == null) {
          return Scaffold(
            body: Center(
              child: Text('Transaction not found'),
            ),
          );
        }

        return _buildDetailScreen(context, ref, transaction);
      },
    );
  }

  Widget _buildDetailScreen(
    BuildContext context,
    WidgetRef ref,
    Transaction transaction,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final currencyFormat = NumberFormat.currency(symbol: '₹');
    final isExpense = transaction.type == 'Expense';
    final amountColor = isExpense ? AppColors.errorDefault : AppColors.secondary02Default;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(
              context,
              '/edit-transaction?id=${transaction.id}',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context, ref, transaction.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card
            _buildAmountCard(context, transaction, isExpense, amountColor, currencyFormat),
            const Gap(24),

            // Transaction Type & Category
            _buildTypeAndCategory(context, transaction, isExpense),
            const Gap(24),

            // Date & Time
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date & Time',
              value: dateFormat.format(transaction.date),
            ),
            const Gap(16),

            // Category Details
            _buildDetailRow(
              icon: Icons.tag,
              label: 'Category',
              value: transaction.category,
            ),
            const Gap(16),

            // Notes
            if (transaction.notes != null && transaction.notes!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Gap(8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Text(
                      transaction.notes!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Gap(24),
                ],
              ),

            // Metadata
            _buildMetadata(transaction),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(
    BuildContext context,
    Transaction transaction,
    bool isExpense,
    Color amountColor,
    NumberFormat currencyFormat,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isExpense
                ? AppColors.errorLight.withOpacity(0.5)
                : AppColors.secondary02Light.withOpacity(0.5),
            isExpense
                ? AppColors.errorLight.withOpacity(0.2)
                : AppColors.secondary02Light.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: amountColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.type,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Gap(12),
          Text(
            currencyFormat.format(transaction.amount),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeAndCategory(
    BuildContext context,
    Transaction transaction,
    bool isExpense,
  ) {
    final categoryIcons = {
      'Food': Icons.restaurant,
      'Transport': Icons.directions_car,
      'Entertainment': Icons.movie,
      'Shopping': Icons.shopping_bag,
      'Utilities': Icons.lightbulb,
      'Health': Icons.favorite,
      'Other': Icons.category,
      'Salary': Icons.account_balance_wallet,
      'Investment': Icons.trending_up,
    };

    final icon = categoryIcons[transaction.category] ?? Icons.category;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isExpense
                  ? AppColors.errorLight
                  : AppColors.secondary02Light,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isExpense
                  ? AppColors.errorDefault
                  : AppColors.secondary02Default,
              size: 24,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  transaction.type,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryDefault,
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(Transaction transaction) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metadata',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grey600,
                    ),
                  ),
                  Text(
                    dateFormat.format(transaction.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (transaction.updatedAt != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Updated',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.grey600,
                      ),
                    ),
                    Text(
                      dateFormat.format(transaction.updatedAt!),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(transactionProvider.notifier).deleteTransaction(id);
              Navigator.pop(context);
              Navigator.pop(context);
              AppSnackBar.success(context, 'Transaction deleted');
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.errorDark),
            ),
          ),
        ],
      ),
    );
  }
}
