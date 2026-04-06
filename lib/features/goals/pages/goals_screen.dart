import 'package:finmate/core/router/route.dart';
import 'package:finmate/features/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/goals/widgets/goals_list.dart';

/// Goals Screen
class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      ref.read(goalProvider.notifier).loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.goals),
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Active',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Completed',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ref.watch(goalProvider).when(
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (state) {
            return TabBarView(
              children: [
                // Active Goals Tab
                GoalsList(
                  emptyMessage: 'No active goals',
                  onAddGoal: () => Navigator.pushNamed(context, AppRoutes.addGoal),
                  showAchieved: false,
                ),
                // Completed Goals Tab
                GoalsList(
                  emptyMessage: 'No completed goals yet',
                  onAddGoal: () => Navigator.pushNamed(context, AppRoutes.addGoal),
                  showAchieved: true,
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.addGoal),
          label: Text('Goals'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
