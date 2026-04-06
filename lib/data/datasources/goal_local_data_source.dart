import 'package:flutter/foundation.dart';
import 'package:finmate/core/errors/exceptions.dart' as app_exceptions;
import 'package:finmate/core/utils/app_logger.dart';
import 'package:finmate/data/models/goal_model.dart';
import 'package:finmate/data/datasources/database_helper.dart';

/// Abstract class for goal local data source
abstract class GoalLocalDataSource {
  Future<List<GoalModel>> getAllGoals();
  Future<List<GoalModel>> getActiveGoals();
  Future<List<GoalModel>> getAchievedGoals();
  Future<GoalModel> getGoalById(String id);
  Future<GoalModel> addGoal(GoalModel goal);
  Future<GoalModel> updateGoal(GoalModel goal);
  Future<void> deleteGoal(String id);
  Future<void> deleteAllGoals();
}

/// Implementation of goal local data source using sqflite
class GoalLocalDataSourceImpl implements GoalLocalDataSource {
  final DatabaseHelper databaseHelper;

  GoalLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<GoalModel>> getAllGoals() async {
    try {
      debugPrint('GoalLocalDataSource: getAllGoals starting...');
      final db = await databaseHelper.database;
      final result = await db.query(DatabaseHelper.goalsTable);
      debugPrint('GoalLocalDataSource: query completed, found ${result.length} goals');
      return result.map((row) => GoalModel.fromDb(row)).toList();
    } catch (e) {
      debugPrint('GoalLocalDataSource: Error loading goals: $e');
      AppLogger.error('Error getting all goals', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get goals');
    }
  }

  @override
  Future<List<GoalModel>> getActiveGoals() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.goalsTable,
        where: '${DatabaseHelper.columnAchieved} = ?',
        whereArgs: [0],
      );
      return result.map((row) => GoalModel.fromDb(row)).toList();
    } catch (e) {
      AppLogger.error('Error getting active goals', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get active goals');
    }
  }

  @override
  Future<List<GoalModel>> getAchievedGoals() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.goalsTable,
        where: '${DatabaseHelper.columnAchieved} = ?',
        whereArgs: [1],
      );
      return result.map((row) => GoalModel.fromDb(row)).toList();
    } catch (e) {
      AppLogger.error('Error getting achieved goals', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get achieved goals');
    }
  }

  @override
  Future<GoalModel> getGoalById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.goalsTable,
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id],
      );
      
      if (result.isEmpty) {
        throw app_exceptions.DatabaseException(message: 'Goal not found');
      }
      return GoalModel.fromDb(result.first);
    } catch (e) {
      AppLogger.error('Error getting goal by id: $id', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get goal');
    }
  }

  @override
  Future<GoalModel> addGoal(GoalModel goal) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(
        DatabaseHelper.goalsTable,
        goal.toDb(),
      );
      return goal;
    } catch (e) {
      debugPrint('GoalLocalDataSource: Error adding goal: $e');
      AppLogger.error('Error adding goal', e);
      throw app_exceptions.DatabaseException(message: 'Failed to add goal');
    }
  }

  @override
  Future<GoalModel> updateGoal(GoalModel goal) async {
    try {
      final db = await databaseHelper.database;
      final success = await db.update(
        DatabaseHelper.goalsTable,
        goal.toDb(),
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [goal.id],
      );
      if (success == 0) {
        throw app_exceptions.DatabaseException(message: 'Failed to update goal');
      }
      return goal;
    } catch (e) {
      AppLogger.error('Error updating goal', e);
      throw app_exceptions.DatabaseException(message: 'Failed to update goal');
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        DatabaseHelper.goalsTable,
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      AppLogger.error('Error deleting goal: $id', e);
      throw app_exceptions.DatabaseException(message: 'Failed to delete goal');
    }
  }

  @override
  Future<void> deleteAllGoals() async {
    try {
      final db = await databaseHelper.database;
      await db.delete(DatabaseHelper.goalsTable);
    } catch (e) {
      AppLogger.error('Error deleting all goals', e);
      throw app_exceptions.DatabaseException(message: 'Failed to delete all goals');
    }
  }
}
