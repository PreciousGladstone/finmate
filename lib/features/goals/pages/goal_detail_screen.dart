import 'package:finmate/core/router/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/themes/app_color.dart';
import 'package:finmate/core/utils/helpers/snackbar_helper.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/goals/widgets/goal_progress_dialog.dart';

/// Goal Detail Screen - Premium detail view for goals
class GoalDetailScreen extends ConsumerWidget {
  final String goalId;

  const GoalDetailScreen({
    super.key,
    required this.goalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalProvider);

    return goalAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, st) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (state) {
        Goal? goal;
        for (final g in state.goals) {
          if (g.id == goalId) {
            goal = g;
            break;
          }
        }

        if (goal == null) {
          return Scaffold(
            body: Center(child: Text('Goal not found')),
          );
        }

        return _buildDetailScreen(context, ref, goal);
      },
    );
  }

  Widget _buildDetailScreen(BuildContext context, WidgetRef ref, Goal goal) {
    final currencyFormat = NumberFormat.currency(symbol: '₹');
    final dateFormat = DateFormat('MMM dd, yyyy');
    final progressPercent = goal.progressPercentage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(
              context,
              '${AppRoutes.editGoal}?id=${goal.id}',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context, ref, goal.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Progress with Amount
            _buildProgressSection(
              context,
              goal,
              progressPercent,
              currencyFormat,
            ),
            const Gap(32),

            // Goal Title
            Text(
              goal.title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Gap(8),

            // Achievement Badge
            if (goal.achieved)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary02Light,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.secondary02Default,
                    ),
                    const Gap(6),
                    Text(
                      'Goal Completed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary02Default,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            const Gap(24),

            // Description
            if (goal.description != null && goal.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
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
                      goal.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Gap(24),
                ],
              ),

            // Amount Details
            _buildAmountGrid(goal, currencyFormat),
            const Gap(24),

            // Timeline
            _buildTimelineSection(goal, dateFormat),
            const Gap(24),

            // Progress Bar
            _buildLinearProgressSection(progressPercent),
            const Gap(24),

            // Days Remaining
            _buildDaysRemaining(goal),
            const Gap(24),

            // Action Button
            if (!goal.achieved)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddProgressDialog(context, goal),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Progress'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primaryDefault,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    Goal goal,
    double progressPercent,
    NumberFormat currencyFormat,
  ) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.backgroundLight,
                  ),
                ),
                // Circular Progress
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progressPercent / 100,
                    strokeWidth: 8,
                    backgroundColor: AppColors.grey200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressPercent >= 100
                          ? AppColors.secondary02Default
                          : AppColors.primaryDefault,
                    ),
                  ),
                ),
                // Center content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${progressPercent.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDefault,
                          ),
                    ),
                    const Gap(4),
                    Text(
                      'Complete',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey700,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountGrid(Goal goal, NumberFormat currencyFormat) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildAmountCard(
          label: 'Target Amount',
          amount: currencyFormat.format(goal.targetAmount),
          color: AppColors.primaryDefault,
          icon: Icons.flag,
        ),
        _buildAmountCard(
          label: 'Current Amount',
          amount: currencyFormat.format(goal.currentAmount ?? 0),
          color: AppColors.secondary02Default,
          icon: Icons.trending_up,
        ),
        _buildAmountCard(
          label: 'Remaining',
          amount: currencyFormat.format(
            (goal.targetAmount - (goal.currentAmount ?? 0)).clamp(0, double.infinity),
          ),
          color: AppColors.warningDefault,
          icon: Icons.hourglass_empty,
        ),
        _buildAmountCard(
          label: 'Progress',
          amount: '${goal.progressPercentage.toStringAsFixed(1)}%',
          color: AppColors.secondary01Default,
          icon: Icons.pie_chart,
        ),
      ],
    );
  }

  Widget _buildAmountCard({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.grey700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(4),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(Goal goal, DateFormat dateFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Started',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.grey700,
                      ),
                    ),
                    Text(
                      dateFormat.format(goal.startDate),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.grey300,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Target Date',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.grey700,
                      ),
                    ),
                    Text(
                      dateFormat.format(goal.endDate),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinearProgressSection(double progressPercent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progressPercent / 100,
            minHeight: 8,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressPercent >= 100
                  ? AppColors.secondary02Default
                  : AppColors.primaryDefault,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaysRemaining(Goal goal) {
    final daysRemaining = goal.endDate.difference(DateTime.now()).inDays;
    final isOverdue = daysRemaining < 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOverdue ? AppColors.errorLight : AppColors.secondary02Light,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverdue
              ? AppColors.errorDefault.withOpacity(0.2)
              : AppColors.secondary02Default.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOverdue ? Icons.schedule : Icons.history,
            color: isOverdue ? AppColors.errorDefault : AppColors.secondary02Default,
            size: 20,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOverdue ? 'Overdue' : 'Days Remaining',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isOverdue
                      ? '${(-daysRemaining)} days ago'
                      : '$daysRemaining days left',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isOverdue
                        ? AppColors.errorDefault
                        : AppColors.secondary02Default,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProgressDialog(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (_) => GoalProgressDialog(goal: goal),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(goalProvider.notifier).deleteGoal(id);
              Navigator.pop(context);
              Navigator.pop(context);
              AppSnackBar.success(context, 'Goal deleted');
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
