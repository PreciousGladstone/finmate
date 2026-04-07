import 'package:finmate/core/errors/network_exception.dart';

/// Abstract interface for remote transaction operations
/// Implement this to connect to any backend
abstract class TransactionRemoteDataSource {
  /// Fetch all transactions from remote
  Future<List<Map<String, dynamic>>> getAllTransactions();

  /// Fetch transaction by ID from remote
  Future<Map<String, dynamic>> getTransactionById(String id);

  /// Add transaction to remote
  Future<Map<String, dynamic>> addTransaction(Map<String, dynamic> transaction);

  /// Update transaction on remote
  Future<Map<String, dynamic>> updateTransaction(
    String id,
    Map<String, dynamic> transaction,
  );

  /// Delete transaction from remote
  Future<void> deleteTransaction(String id);

  /// Sync local transactions with remote (for conflict resolution)
  Future<List<Map<String, dynamic>>> syncTransactions(
    List<Map<String, dynamic>> localTransactions,
  );
}
