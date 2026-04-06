import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

/// Reusable transaction date picker widget
/// Displays and handles date selection with formatted output
class TransactionDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onDateTap;

  const TransactionDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDateTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: AppColors.textColor),
            const Gap(12),
            Text(
              DateFormat(AppConstants.dateFormat)
                  .format(selectedDate ?? DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
