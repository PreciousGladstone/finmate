import 'package:finmate/core/utils/result.dart';
import 'package:finmate/domain/entities/transaction.dart';
import 'package:finmate/domain/repositories/transaction_repository.dart';

/// Use case to get all transactions
class GetAllTransactionsUseCase {
  final TransactionRepository repository;

  GetAllTransactionsUseCase({required this.repository});

  Future<Result<List<Transaction>>> call() => repository.getAllTransactions();
}

/// Use case to get transactions by type
class GetTransactionsByTypeUseCase {
  final TransactionRepository repository;

  GetTransactionsByTypeUseCase({required this.repository});

  Future<Result<List<Transaction>>> call(String type) =>
      repository.getTransactionsByType(type);
}

/// Use case to get transactions within date range
class GetTransactionsByDateRangeUseCase {
  final TransactionRepository repository;

  GetTransactionsByDateRangeUseCase({required this.repository});

  Future<Result<List<Transaction>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      repository.getTransactionsByDateRange(startDate: startDate, endDate: endDate);
}

/// Use case to get transactions by category
class GetTransactionsByCategoryUseCase {
  final TransactionRepository repository;

  GetTransactionsByCategoryUseCase({required this.repository});

  Future<Result<List<Transaction>>> call(String category) =>
      repository.getTransactionsByCategory(category);
}

/// Use case to search transactions
class SearchTransactionsUseCase {
  final TransactionRepository repository;

  SearchTransactionsUseCase({required this.repository});

  Future<Result<List<Transaction>>> call(String query) =>
      repository.searchTransactions(query);
}

/// Use case to add a transaction
class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase({required this.repository});

  Future<Result<Transaction>> call(Transaction transaction) =>
      repository.addTransaction(transaction);
}

/// Use case to update a transaction
class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase({required this.repository});

  Future<Result<Transaction>> call(Transaction transaction) =>
      repository.updateTransaction(transaction);
}

/// Use case to delete a transaction
class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase({required this.repository});

  Future<Result<void>> call(String id) => repository.deleteTransaction(id);
}

/// Use case to get current balance
class GetCurrentBalanceUseCase {
  final TransactionRepository repository;

  GetCurrentBalanceUseCase({required this.repository});

  Future<Result<double>> call() => repository.getCurrentBalance();
}

/// Use case to get total income
class GetTotalIncomeUseCase {
  final TransactionRepository repository;

  GetTotalIncomeUseCase({required this.repository});

  Future<Result<double>> call() => repository.getTotalIncome();
}

/// Use case to get total expense
class GetTotalExpenseUseCase {
  final TransactionRepository repository;

  GetTotalExpenseUseCase({required this.repository});

  Future<Result<double>> call() => repository.getTotalExpense();
}
