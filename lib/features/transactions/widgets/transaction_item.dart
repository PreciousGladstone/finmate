import 'package:finmate/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Transaction item widget for displaying a single transaction
class TransactionItem extends StatelessWidget {
  final String category;
  final String amount;
  final String date;
  final String type;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool isExpense;

  const TransactionItem({
    super.key,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.onTap,
    this.onDelete,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isExpense ? Colors.red : Colors.green).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  TransactionCategory.icons[category] ?? '📌',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isExpense ? '-' : '+'}$amount',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.close, size: 16, color: Colors.grey[400]),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
