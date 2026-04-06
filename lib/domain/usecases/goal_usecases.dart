import 'package:finmate/core/utils/result.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/domain/repositories/goal_repository.dart';

/// Use case to get all goals
class GetAllGoalsUseCase {
  final GoalRepository repository;

  GetAllGoalsUseCase({required this.repository});

  Future<Result<List<Goal>>> call() => repository.getAllGoals();
}

/// Use case to get active goals
class GetActiveGoalsUseCase {
  final GoalRepository repository;

  GetActiveGoalsUseCase({required this.repository});

  Future<Result<List<Goal>>> call() => repository.getActiveGoals();
}

/// Use case to get achieved goals
class GetAchievedGoalsUseCase {
  final GoalRepository repository;

  GetAchievedGoalsUseCase({required this.repository});

  Future<Result<List<Goal>>> call() => repository.getAchievedGoals();
}

/// Use case to add a goal
class AddGoalUseCase {
  final GoalRepository repository;

  AddGoalUseCase({required this.repository});

  Future<Result<Goal>> call(Goal goal) => repository.addGoal(goal);
}

/// Use case to update a goal
class UpdateGoalUseCase {
  final GoalRepository repository;

  UpdateGoalUseCase({required this.repository});

  Future<Result<Goal>> call(Goal goal) => repository.updateGoal(goal);
}

/// Use case to delete a goal
class DeleteGoalUseCase {
  final GoalRepository repository;

  DeleteGoalUseCase({required this.repository});

  Future<Result<void>> call(String id) => repository.deleteGoal(id);
}

/// Use case to update goal progress
class UpdateGoalProgressUseCase {
  final GoalRepository repository;

  UpdateGoalProgressUseCase({required this.repository});

  Future<Result<Goal>> call(String goalId, double amount) =>
      repository.updateGoalProgress(goalId, amount);
}
