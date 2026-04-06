import 'package:finmate/core/utils/result.dart';
import 'package:finmate/domain/entities/goal.dart';

/// Repository interface for goal operations
abstract class GoalRepository {
  /// Get all goals
  Future<Result<List<Goal>>> getAllGoals();

  /// Get a single goal by ID
  Future<Result<Goal>> getGoalById(String id);

  /// Get active goals (not achieved and not ended)
  Future<Result<List<Goal>>> getActiveGoals();

  /// Get achieved goals
  Future<Result<List<Goal>>> getAchievedGoals();

  /// Add a new goal
  Future<Result<Goal>> addGoal(Goal goal);

  /// Update an existing goal
  Future<Result<Goal>> updateGoal(Goal goal);

  /// Delete a goal
  Future<Result<void>> deleteGoal(String id);

  /// Delete all goals
  Future<Result<void>> deleteAllGoals();

  /// Update goal progress
  Future<Result<Goal>> updateGoalProgress(String goalId, double amount);
}
