import 'package:finmate/core/router/route.dart';
import 'package:finmate/core/themes/app_color.dart';
import 'package:finmate/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/goals/widgets/goal_progress_dialog.dart';

/// Goal Options Menu Widget
class GoalOptionsMenu extends StatelessWidget {
  final Goal goal;
  final GoalNotifier goalNotifier;
  final VoidCallback? onOptionSelected;

  const GoalOptionsMenu({
    super.key,
    required this.goal,
    required this.goalNotifier,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            goal.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          _buildMenuItem(
            context,
            icon: Icons.edit,
            label: 'Edit',
            onTap: () => _handleEdit(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.add,
            label: 'Add Progress',
            onTap: () => _handleAddProgress(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.delete,
            label: 'Delete',
            color: AppColors.errorDefault,
            onTap: () => _handleDelete(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  void _handleEdit(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '${AppRoutes.editGoal}?id=${goal.id}');
    onOptionSelected?.call();
  }

  void _handleAddProgress(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => GoalProgressDialog(goal: goal),
    );
    onOptionSelected?.call();
  }

  void _handleDelete(BuildContext context) {
    Navigator.pop(context);
    goalNotifier.deleteGoal(goal.id);
    AppSnackBar.success(context, 'Goal deleted');
    onOptionSelected?.call();
  }
}
