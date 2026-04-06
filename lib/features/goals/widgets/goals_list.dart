import 'package:finmate/core/router/route.dart';
import 'package:finmate/features/shared/widgets/empty_state_widget.dart';
import 'package:finmate/features/goals/widgets/goal_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/goals/widgets/goal_options_menu.dart';

/// Goals List Widget
class GoalsList extends ConsumerWidget {
  final String emptyMessage;
  final VoidCallback? onAddGoal;
  final bool showAchieved;

  const GoalsList({
    super.key,
    required this.emptyMessage,
    this.onAddGoal,
    this.showAchieved = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalProvider);

    return goalAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
      data: (goalState) {
        // Get ALL goals from provider and filter here
        final allGoals = goalState.goals;
        final displayGoals = showAchieved
            ? allGoals.where((g) => g.achieved).toList()
            : allGoals.where((g) => !g.achieved).toList();

        if (displayGoals.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.flag_outlined,
            message: emptyMessage,
            actionLabel: 'Create Goal',
            onAction: onAddGoal ?? () {},
          );
        }

        final currencyFormat = NumberFormat.currency(symbol: '₹');

        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: displayGoals.length,
          itemBuilder: (context, index) {
            final goal = displayGoals[index];

            // Find the latest version of this goal from the provider
            Goal? latestGoal;
            for (final g in allGoals) {
              if (g.id == goal.id) {
                latestGoal = g;
                break;
              }
            }
            final displayGoal = latestGoal ?? goal;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
              child: GestureDetector(
                onLongPress: () => _showGoalOptions(context, ref, displayGoal),
                child: GoalProgressCard(
                  title: displayGoal.title,
                  progress: displayGoal.progressPercentage,
                  targetAmount: currencyFormat.format(displayGoal.targetAmount),
                  currentAmount: currencyFormat.format(displayGoal.currentAmount),
                  daysRemaining: displayGoal.daysRemaining.toString(),
                  onTap: () => Navigator.pushNamed(context, '${AppRoutes.goalDetail}?id=${displayGoal.id}'),
                  achieved: displayGoal.achieved,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showGoalOptions(BuildContext context, WidgetRef ref, Goal goal) {
    final goalNotifier = ref.read(goalProvider.notifier);
    showModalBottomSheet(
      context: context,
      builder: (_) => GoalOptionsMenu(
        goal: goal,
        goalNotifier: goalNotifier,
      ),
    );
  }
}
