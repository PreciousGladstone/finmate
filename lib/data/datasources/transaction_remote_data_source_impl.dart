import 'package:flutter/foundation.dart';
import 'package:finmate/core/network/http_client.dart';
import 'package:finmate/core/config/api_config.dart';
import 'package:finmate/core/errors/network_exception.dart';
import 'package:finmate/data/datasources/transaction_remote_data_source.dart';

/// Concrete implementation of TransactionRemoteDataSource using HTTP
/// This can be swapped with any other backend implementation
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final HttpClient _httpClient;

  TransactionRemoteDataSourceImpl(this._httpClient);

  @override
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    try {
      debugPrint('TransactionRemoteDataSource: Fetching all transactions...');
      final response = await _httpClient.get(
        ApiConfig.transactionsEndpoint,
      );

      // Handle both array and paginated responses
      final transactions = response['data'] as List<dynamic>? ??
          response['transactions'] as List<dynamic>? ??
          (response is List ? response : []);

      final result = List<Map<String, dynamic>>.from(
        transactions.map((tx) => tx as Map<String, dynamic>),
      );

      debugPrint(
        'TransactionRemoteDataSource: Fetched ${result.length} transactions',
      );
      return result;
    } catch (e) {
      debugPrint('TransactionRemoteDataSource: Error fetching transactions: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getTransactionById(String id) async {
    try {
      debugPrint('TransactionRemoteDataSource: Getting transaction $id...');
      final response = await _httpClient.get(
        '${ApiConfig.transactionsEndpoint}/$id',
      );

      final transaction = response['data'] as Map<String, dynamic>? ?? response;
      debugPrint('TransactionRemoteDataSource: Got transaction $id');
      return transaction;
    } catch (e) {
      debugPrint(
        'TransactionRemoteDataSource: Error getting transaction $id: $e',
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> addTransaction(
    Map<String, dynamic> transaction,
  ) async {
    try {
      debugPrint('TransactionRemoteDataSource: Adding transaction...');
      final response = await _httpClient.post(
        ApiConfig.transactionsEndpoint,
        data: transaction,
      );

      final result = response['data'] as Map<String, dynamic>? ?? response;
      debugPrint('TransactionRemoteDataSource: Transaction added successfully');
      return result;
    } catch (e) {
      debugPrint('TransactionRemoteDataSource: Error adding transaction: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateTransaction(
    String id,
    Map<String, dynamic> transaction,
  ) async {
    try {
      debugPrint('TransactionRemoteDataSource: Updating transaction $id...');
      final response = await _httpClient.put(
        '${ApiConfig.transactionsEndpoint}/$id',
        data: transaction,
      );

      final result = response['data'] as Map<String, dynamic>? ?? response;
      debugPrint('TransactionRemoteDataSource: Transaction $id updated');
      return result;
    } catch (e) {
      debugPrint('TransactionRemoteDataSource: Error updating transaction: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      debugPrint('TransactionRemoteDataSource: Deleting transaction $id...');
      await _httpClient.delete(
        '${ApiConfig.transactionsEndpoint}/$id',
      );
      debugPrint('TransactionRemoteDataSource: Transaction $id deleted');
    } catch (e) {
      debugPrint('TransactionRemoteDataSource: Error deleting transaction: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> syncTransactions(
    List<Map<String, dynamic>> localTransactions,
  ) async {
    try {
      debugPrint(
        'TransactionRemoteDataSource: Syncing ${localTransactions.length} transactions...',
      );
      final response = await _httpClient.post(
        '${ApiConfig.transactionsEndpoint}/sync',
        data: {
          'transactions': localTransactions,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      final synced = response['data'] as List<dynamic>? ?? [];
      final result = List<Map<String, dynamic>>.from(
        synced.map((tx) => tx as Map<String, dynamic>),
      );

      debugPrint('TransactionRemoteDataSource: Synced ${result.length} transactions');
      return result;
    } catch (e) {
      debugPrint('TransactionRemoteDataSource: Error syncing transactions: $e');
      rethrow;
    }
  }
}
