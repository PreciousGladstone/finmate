import 'package:flutter/foundation.dart';
import 'package:finmate/core/network/http_client.dart';
import 'package:finmate/core/config/api_config.dart';
import 'package:finmate/data/datasources/goal_remote_data_source.dart';

/// Concrete implementation of GoalRemoteDataSource using HTTP
/// This can be swapped with any other backend implementation
class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  final HttpClient _httpClient;

  GoalRemoteDataSourceImpl(this._httpClient);

  @override
  Future<List<Map<String, dynamic>>> getAllGoals() async {
    try {
      debugPrint('GoalRemoteDataSource: Fetching all goals...');
      final response = await _httpClient.get(
        ApiConfig.goalsEndpoint,
      );

      // Handle both array and paginated responses
      final goals = response['data'] as List<dynamic>? ??
          response['goals'] as List<dynamic>? ??
          (response is List ? response : []);

      final result = List<Map<String, dynamic>>.from(
        goals.map((goal) => goal as Map<String, dynamic>),
      );

      debugPrint('GoalRemoteDataSource: Fetched ${result.length} goals');
      return result;
    } catch (e) {
      debugPrint('GoalRemoteDataSource: Error fetching goals: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getGoalById(String id) async {
    try {
      debugPrint('GoalRemoteDataSource: Getting goal $id...');
      final response = await _httpClient.get(
        '${ApiConfig.goalsEndpoint}/$id',
      );

      final goal = response['data'] as Map<String, dynamic>? ?? response;
      debugPrint('GoalRemoteDataSource: Got goal $id');
      return goal;
    } catch (e) {
      debugPrint('GoalRemoteDataSource: Error getting goal $id: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> addGoal(
    Map<String, dynamic> goal,
  ) async {
    try {
      debugPrint('GoalRemoteDataSource: Adding goal...');
      final response = await _httpClient.post(
        ApiConfig.goalsEndpoint,
        data: goal,
      );

      final result = response['data'] as Map<String, dynamic>? ?? response;
      debugPrint('GoalRemoteDataSource: Goal added successfully');
      return result;
    } catch (e) {
      debugPrint('GoalRemoteDataSource: Error adding goal: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateGoal(
    String id,
    Map<String, dynamic> goal,
  ) async {
    try {
      debugPrint('GoalRemoteDataSource: Updating goal $id...');
      final response = await _httpClient.put(
        '${ApiConfig.goalsEndpoint}/$id',
        data: goal,
      );

      final result = response['data'] as Map<String, dynamic>? ?? response;
      debugPrint('GoalRemoteDataSource: Goal $id updated');
      return result;
    } catch (e) {
      debugPrint('GoalRemoteDataSource: Error updating goal: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    try {
      debugPrint('GoalRemoteDataSource: Deleting goal $id...');
      await _httpClient.delete(
        '${ApiConfig.goalsEndpoint}/$id',
      );
      debugPrint('GoalRemoteDataSource: Goal $id deleted');
    } catch (e) {
      debugPrint('GoalRemoteDataSource: Error deleting goal: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> syncGoals(
    List<Map<String, dynamic>> localGoals,
  ) async {
    try {
      debugPrint('GoalRemoteDataSource: Syncing ${localGoals.length} goals...');
      final response = await _httpClient.post(
        '${ApiConfig.goalsEndpoint}/sync',
        data: {
          'goals': localGoals,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      final synced = response['data'] as List<dynamic>? ?? [];
      final result = List<Map<String, dynamic>>.from(
        synced.map((goal) => goal as Map<String, dynamic>),
      );

      debugPrint('GoalRemoteDataSource: Synced ${result.length} goals');
      return result;
    } catch (e) {
      debugPrint('GoalRemoteDataSource: Error syncing goals: $e');
      rethrow;
    }
  }
}
