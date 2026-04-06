import 'package:finmate/core/errors/exceptions.dart';
import 'package:finmate/core/utils/result.dart';
import 'package:finmate/data/datasources/goal_local_data_source.dart';
import 'package:finmate/data/models/goal_model.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/domain/repositories/goal_repository.dart';

/// Implementation of GoalRepository
class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDataSource localDataSource;

  GoalRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<Goal>>> getAllGoals() async {
    try {
      final goals = await localDataSource.getAllGoals();
      return Result.success(goals);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<List<Goal>>> getActiveGoals() async {
    try {
      final goals = await localDataSource.getActiveGoals();
      return Result.success(goals);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<List<Goal>>> getAchievedGoals() async {
    try {
      final goals = await localDataSource.getAchievedGoals();
      return Result.success(goals);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<Goal>> getGoalById(String id) async {
    try {
      final goal = await localDataSource.getGoalById(id);
      return Result.success(goal);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<Goal>> addGoal(Goal goal) async {
    try {
      final model = GoalModel.fromEntity(goal);
      final result = await localDataSource.addGoal(model);
      return Result.success(result);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<Goal>> updateGoal(Goal goal) async {
    try {
      final model = GoalModel.fromEntity(goal);
      final result = await localDataSource.updateGoal(model);
      return Result.success(result);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<void>> deleteGoal(String id) async {
    try {
      await localDataSource.deleteGoal(id);
      return Result.success(null);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<void>> deleteAllGoals() async {
    try {
      await localDataSource.deleteAllGoals();
      return Result.success(null);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<Goal>> updateGoalProgress(String goalId, double amount) async {
    try {
      final goal = await localDataSource.getGoalById(goalId);
      final newCurrentAmount = goal.currentAmount! + amount;
      final isAchieved = newCurrentAmount >= goal.targetAmount;
      
      // Create an updated goal entity
      final updatedGoal = goal.copyWith(
        currentAmount: newCurrentAmount,
        achieved: isAchieved,
        updatedAt: DateTime.now(),
      );
      
      // Convert entity to model for database update
      final updatedModel = GoalModel.fromEntity(updatedGoal);
      final result = await localDataSource.updateGoal(updatedModel);
      return Result.success(result);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }
}
