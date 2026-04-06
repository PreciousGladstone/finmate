import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/core/utils/service_locator.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/domain/usecases/goal_usecases.dart';
import 'package:finmate/core/utils/app_logger.dart';

/// State class for goal operations
class GoalState {
  final List<Goal> goals;
  final List<Goal> activeGoals;
  final List<Goal> achievedGoals;

  const GoalState({
    required this.goals,
    required this.activeGoals,
    required this.achievedGoals,
  });

  /// Get the first active goal (used for monthly goal display)
  Goal? get monthlyGoal => activeGoals.isNotEmpty ? activeGoals.first : null;

  GoalState copyWith({
    List<Goal>? goals,
    List<Goal>? activeGoals,
    List<Goal>? achievedGoals,
  }) {
    return GoalState(
      goals: goals ?? this.goals,
      activeGoals: activeGoals ?? this.activeGoals,
      achievedGoals: achievedGoals ?? this.achievedGoals,
    );
  }
}

/// Riverpod AsyncNotifier for managing goal state
class GoalNotifier extends AsyncNotifier<GoalState> {
  late final GetAllGoalsUseCase _getAllGoalsUseCase;
  late final GetActiveGoalsUseCase _getActiveGoalsUseCase;
  late final GetAchievedGoalsUseCase _getAchievedGoalsUseCase;
  late final AddGoalUseCase _addGoalUseCase;
  late final UpdateGoalUseCase _updateGoalUseCase;
  late final DeleteGoalUseCase _deleteGoalUseCase;
  late final UpdateGoalProgressUseCase _updateGoalProgressUseCase;

  /// Initialize use cases - called once
  void _initializeUseCases() {
    _getAllGoalsUseCase = getIt<GetAllGoalsUseCase>();
    _getActiveGoalsUseCase = getIt<GetActiveGoalsUseCase>();
    _getAchievedGoalsUseCase = getIt<GetAchievedGoalsUseCase>();
    _addGoalUseCase = getIt<AddGoalUseCase>();
    _updateGoalUseCase = getIt<UpdateGoalUseCase>();
    _deleteGoalUseCase = getIt<DeleteGoalUseCase>();
    _updateGoalProgressUseCase = getIt<UpdateGoalProgressUseCase>();
  }

  @override
  Future<GoalState> build() async {
    // Lazy initialization: return empty state without loading data
    debugPrint('GoalProvider: Initialized (lazy)');
    _initializeUseCases();
    return const GoalState(
      goals: [],
      activeGoals: [],
      achievedGoals: [],
    );
  }

  /// Fetch all goals and categorize them
  Future<void> _loadGoalsFromDb() async {
    try {
      debugPrint('GoalProvider: Loading goals...');
      AppLogger.log('Starting _loadGoals');

      List<Goal> goals = [];
      List<Goal> activeGoals = [];
      List<Goal> achievedGoals = [];

      // Get all goals
      final allResult = await _getAllGoalsUseCase();
      allResult.fold(
        onSuccess: (g) => goals = g,
        onFailure: (f) => AppLogger.error('Failed to load all goals: $f'),
      );

      // Get active goals
      final activeResult = await _getActiveGoalsUseCase();
      activeResult.fold(
        onSuccess: (g) => activeGoals = g,
        onFailure: (f) => AppLogger.error('Failed to load active goals: $f'),
      );

      // Get achieved goals
      final achievedResult = await _getAchievedGoalsUseCase();
      achievedResult.fold(
        onSuccess: (g) => achievedGoals = g,
        onFailure: (f) => AppLogger.error('Failed to load achieved goals: $f'),
      );

      AppLogger.log('Loaded ${goals.length} goals');
      state = AsyncValue.data(
        GoalState(
          goals: goals,
          activeGoals: activeGoals,
          achievedGoals: achievedGoals,
        ),
      );
      debugPrint('GoalProvider: Loaded successfully');
    } catch (e, st) {
      debugPrint('GoalProvider: Error: $e');
      AppLogger.error('Error loading goals', e, st);
      state = AsyncValue.error(e, st);
    }
  }

  /// Public method to refresh goals (called from UI)
  Future<void> loadGoals() async {
    state = const AsyncValue.loading();
    await _loadGoalsFromDb();
  }

  /// Add a new goal
  Future<void> addGoal(Goal goal) async {
    try {
      final result = await _addGoalUseCase(goal);
      result.fold(
        onSuccess: (_) async {
          // Reload goals after adding
          await loadGoals();
        },
        onFailure: (failure) {
          AppLogger.error('Failed to add goal', failure);
          state = AsyncValue.error(failure, StackTrace.current);
        },
      );
    } catch (e, st) {
      AppLogger.error('Error adding goal', e, st);
      state = AsyncValue.error(e, st);
    }
  }

  /// Update a goal
  Future<void> updateGoal(Goal goal) async {
    try {
      final result = await _updateGoalUseCase(goal);
      result.fold(
        onSuccess: (_) async {
          // Reload goals after updating
          await loadGoals();
        },
        onFailure: (failure) {
          AppLogger.error('Failed to update goal', failure);
          state = AsyncValue.error(failure, StackTrace.current);
        },
      );
    } catch (e, st) {
      AppLogger.error('Error updating goal', e, st);
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete a goal
  Future<void> deleteGoal(String id) async {
    try {
      final result = await _deleteGoalUseCase(id);
      result.fold(
        onSuccess: (_) async {
          // Reload goals after deleting
          await loadGoals();
        },
        onFailure: (failure) {
          AppLogger.error('Failed to delete goal', failure);
          state = AsyncValue.error(failure, StackTrace.current);
        },
      );
    } catch (e, st) {
      AppLogger.error('Error deleting goal', e, st);
      state = AsyncValue.error(e, st);
    }
  }

  /// Update goal progress
  Future<void> updateGoalProgress(String goalId, double newAmount) async {
    try {
      final result = await _updateGoalProgressUseCase(goalId, newAmount);
      result.fold(
        onSuccess: (_) async {
          // Reload goals after updating progress
          await loadGoals();
        },
        onFailure: (failure) {
          AppLogger.error('Failed to update goal progress', failure);
          state = AsyncValue.error(failure, StackTrace.current);
        },
      );
    } catch (e, st) {
      AppLogger.error('Error updating goal progress', e, st);
      state = AsyncValue.error(e, st);
    }
  }
}

/// Riverpod provider for goal state
final goalProvider = AsyncNotifierProvider<GoalNotifier, GoalState>(
  () => GoalNotifier(),
);
