import 'package:finmate/core/errors/exceptions.dart';
import 'package:finmate/core/utils/result.dart';
import 'package:finmate/data/datasources/transaction_local_data_source.dart';
import 'package:finmate/data/models/transaction_model.dart';
import 'package:finmate/domain/entities/transaction.dart';
import 'package:finmate/domain/repositories/transaction_repository.dart';

/// Implementation of TransactionRepository
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<Transaction>>> getAllTransactions() async {
    try {
      final transactions = await localDataSource.getAllTransactions();
      return Result.success(transactions);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<List<Transaction>>> getTransactionsByType(String type) async {
    try {
      final transactions = await localDataSource.getTransactionsByType(type);
      return Result.success(transactions);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<List<Transaction>>> getTransactionsByCategory(String category) async {
    try {
      final transactions = await localDataSource.getTransactionsByCategory(category);
      return Result.success(transactions);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<List<Transaction>>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final transactions = await localDataSource.getTransactionsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
      return Result.success(transactions);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<List<Transaction>>> searchTransactions(String query) async {
    try {
      final transactions = await localDataSource.searchTransactions(query);
      return Result.success(transactions);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<Transaction>> getTransactionById(String id) async {
    try {
      final transaction = await localDataSource.getTransactionById(id);
      return Result.success(transaction);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<Transaction>> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final result = await localDataSource.addTransaction(model);
      return Result.success(result);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<Transaction>> updateTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final result = await localDataSource.updateTransaction(model);
      return Result.success(result);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return Result.success(null);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<void>> deleteAllTransactions() async {
    try {
      await localDataSource.deleteAllTransactions();
      return Result.success(null);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<double>> getTotalIncome() async {
    try {
      final total = await localDataSource.getTotalIncome();
      return Result.success(total);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<double>> getTotalExpense() async {
    try {
      final total = await localDataSource.getTotalExpense();
      return Result.success(total);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }

  @override
  Future<Result<double>> getCurrentBalance() async {
    try {
      final income = await localDataSource.getTotalIncome();
      final expense = await localDataSource.getTotalExpense();
      return Result.success(income - expense);
    } on DatabaseException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }
}
