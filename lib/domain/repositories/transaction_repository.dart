import 'package:finmate/core/utils/result.dart';
import 'package:finmate/domain/entities/transaction.dart';

/// Repository interface for transaction operations
abstract class TransactionRepository {
  /// Get all transactions
  Future<Result<List<Transaction>>> getAllTransactions();

  /// Get transactions by type (Income/Expense)
  Future<Result<List<Transaction>>> getTransactionsByType(String type);

  /// Get transactions by category
  Future<Result<List<Transaction>>> getTransactionsByCategory(String category);

  /// Get transactions within date range
  Future<Result<List<Transaction>>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Search transactions by notes
  Future<Result<List<Transaction>>> searchTransactions(String query);

  /// Get a single transaction by ID
  Future<Result<Transaction>> getTransactionById(String id);

  /// Add a new transaction
  Future<Result<Transaction>> addTransaction(Transaction transaction);

  /// Update an existing transaction
  Future<Result<Transaction>> updateTransaction(Transaction transaction);

  /// Delete a transaction
  Future<Result<void>> deleteTransaction(String id);

  /// Delete all transactions
  Future<Result<void>> deleteAllTransactions();

  /// Get total income
  Future<Result<double>> getTotalIncome();

  /// Get total expense
  Future<Result<double>> getTotalExpense();

  /// Get current balance
  Future<Result<double>> getCurrentBalance();
}
