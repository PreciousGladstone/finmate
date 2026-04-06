import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finmate/core/themes/app_color.dart';

/// Goal Action Buttons Widget
class GoalActionButtons extends StatelessWidget {
  final VoidCallback onSaveGoal;
  final VoidCallback? onAddProgress;
  final bool isEditing;

  const GoalActionButtons({
    super.key,
    required this.onSaveGoal,
    this.onAddProgress,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onSaveGoal,
            child: const Text('Save Goal'),
          ),
        ),
        if (isEditing && onAddProgress != null) ...[
          const Gap(12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAddProgress,
              icon: const Icon(Icons.add),
              label: const Text('Add Progress'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
