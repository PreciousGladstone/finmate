/// Abstract interface for remote goal operations
/// Implement this to connect to any backend
abstract class GoalRemoteDataSource {
  /// Fetch all goals from remote
  Future<List<Map<String, dynamic>>> getAllGoals();

  /// Fetch goal by ID from remote
  Future<Map<String, dynamic>> getGoalById(String id);

  /// Add goal to remote
  Future<Map<String, dynamic>> addGoal(Map<String, dynamic> goal);

  /// Update goal on remote
  Future<Map<String, dynamic>> updateGoal(
    String id,
    Map<String, dynamic> goal,
  );

  /// Delete goal from remote
  Future<void> deleteGoal(String id);

  /// Sync local goals with remote (for conflict resolution)
  Future<List<Map<String, dynamic>>> syncGoals(
    List<Map<String, dynamic>> localGoals,
  );
}
