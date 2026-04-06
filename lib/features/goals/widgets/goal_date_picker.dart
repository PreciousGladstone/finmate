import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';

/// Goal Date Picker Widget
class GoalDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onDateTap;

  const GoalDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Date',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const Gap(12),
                Text(
                  DateFormat(AppConstants.dateFormat)
                      .format(selectedDate ?? DateTime.now()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
