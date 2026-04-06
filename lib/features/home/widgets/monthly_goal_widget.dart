import 'package:finmate/core/router/route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/goals/widgets/goal_progress_card.dart';
import 'package:finmate/features/shared/providers/index.dart';

/// Monthly Goal Widget
class MonthlyGoalWidget extends StatelessWidget {
  final GoalState state;

  const MonthlyGoalWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.monthlyGoal == null) {
      return const SizedBox.shrink();
    }

    final goal = state.monthlyGoal!;
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.monthlyGoal,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        GoalProgressCard(
          title: goal.title,
          progress: goal.progressPercentage,
          targetAmount: currencyFormat.format(goal.targetAmount),
          currentAmount: currencyFormat.format(goal.currentAmount),
          daysRemaining: goal.daysRemaining.toString(),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.goals);
          },
          achieved: goal.achieved,
        ),
      ],
    );
  }
}
