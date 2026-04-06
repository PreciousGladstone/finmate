import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/core/utils/service_locator.dart';
import 'package:finmate/domain/entities/transaction.dart';
import 'package:finmate/domain/usecases/transaction_usecases.dart';
import 'package:finmate/core/utils/app_logger.dart';

/// State class for transaction operations
class TransactionState {
  final List<Transaction> transactions;
  final double balance;
  final double income;
  final double expense;

  const TransactionState({
    required this.transactions,
    required this.balance,
    required this.income,
    required this.expense,
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    double? balance,
    double? income,
    double? expense,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      balance: balance ?? this.balance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }
}

/// Riverpod AsyncNotifier for managing transaction state
class TransactionNotifier extends AsyncNotifier<TransactionState> {
  late final GetAllTransactionsUseCase _getAllTransactionsUseCase;
  late final AddTransactionUseCase _addTransactionUseCase;
  late final UpdateTransactionUseCase _updateTransactionUseCase;
  late final DeleteTransactionUseCase _deleteTransactionUseCase;
  late final GetCurrentBalanceUseCase _getCurrentBalanceUseCase;
  late final GetTotalIncomeUseCase _getTotalIncomeUseCase;
  late final GetTotalExpenseUseCase _getTotalExpenseUseCase;

  /// Initialize use cases - called once
  void _initializeUseCases() {
    _getAllTransactionsUseCase = getIt<GetAllTransactionsUseCase>();
    _addTransactionUseCase = getIt<AddTransactionUseCase>();
    _updateTransactionUseCase = getIt<UpdateTransactionUseCase>();
    _deleteTransactionUseCase = getIt<DeleteTransactionUseCase>();
    _getCurrentBalanceUseCase = getIt<GetCurrentBalanceUseCase>();
    _getTotalIncomeUseCase = getIt<GetTotalIncomeUseCase>();
    _getTotalExpenseUseCase = getIt<GetTotalExpenseUseCase>();
  }

  @override
  Future<TransactionState> build() async {
    // Lazy initialization: return empty state without loading data
    debugPrint('TransactionProvider: Initialized (lazy)');
    _initializeUseCases();
    return const TransactionState(
      transactions: [],
      balance: 0,
      income: 0,
      expense: 0,
    );
  }

  /// Fetch all transactions and update summary stats
  Future<void> _loadTransactionsFromDb() async {
    try {
      debugPrint('TransactionProvider: Loading transactions...');
      AppLogger.log('Starting _loadTransactions');

      // Get all transactions
      final result = await _getAllTransactionsUseCase();
      AppLogger.log('getAllTransactions completed');

      List<Transaction> transactions = [];
      double balance = 0;
      double income = 0;
      double expense = 0;

      result.fold(
        onSuccess: (txns) {
          transactions = txns;
          // Sort by date (newest first)
          transactions.sort((a, b) => b.date.compareTo(a.date));
          AppLogger.log('Loaded ${transactions.length} transactions');
        },
        onFailure: (f) => AppLogger.error('Failed to load transactions: $f'),
      );

      // Fetch balance stats
      final balanceResult = await _getCurrentBalanceUseCase();
      final incomeResult = await _getTotalIncomeUseCase();
      final expenseResult = await _getTotalExpenseUseCase();

      balanceResult.fold(
        onSuccess: (b) => balance = b,
        onFailure: (f) => AppLogger.error('Failed to load balance: $f'),
      );

      incomeResult.fold(
        onSuccess: (i) => income = i,
        onFailure: (f) => AppLogger.error('Failed to load income: $f'),
      );

      expenseResult.fold(
        onSuccess: (e) => expense = e,
        onFailure: (f) => AppLogger.error('Failed to load expense: $f'),
      );

      state = AsyncValue.data(
        TransactionState(
          transactions: transactions,
          balance: balance,
          income: income,
          expense: expense,
        ),
      );
      debugPrint('TransactionProvider: Loaded successfully');
    } catch (e, st) {
      debugPrint('TransactionProvider: Error: $e');
      AppLogger.error('Error loading transactions', e, st);
      state = AsyncValue.error(e, st);
    }
  }

  /// Public method to refresh transactions (called from UI)
  Future<void> loadTransactions() async {
    state = const AsyncValue.loading();
    await _loadTransactionsFromDb();
  }

  /// Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final result = await _addTransactionUseCase(transaction);
      result.fold(
        onSuccess: (_) async {
          // Reload transactions after adding
          await loadTransactions();
        },
        onFailure: (failure) {
          AppLogger.error('Failed to add transaction', failure);
          state = AsyncValue.error(failure, StackTrace.current);
        },
      );
    } catch (e, st) {
      AppLogger.error('Error adding transaction', e, st);
      state = AsyncValue.error(e, st);
    }
  }

  /// Update a transaction
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final result = await _updateTransactionUseCase(transaction);
      result.fold(
        onSuccess: (_) async {
          // Reload transactions after updating
          await loadTransactions();
        },
        onFailure: (failure) {
          AppLogger.error('Failed to update transaction', failure);
          state = AsyncValue.error(failure, StackTrace.current);
        },
      );
    } catch (e, st) {
      AppLogger.error('Error updating transaction', e, st);
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String id) async {
    try {
      final result = await _deleteTransactionUseCase(id);
      result.fold(
        onSuccess: (_) async {
          // Reload transactions after deleting
          await loadTransactions();
        },
        onFailure: (failure) {
          AppLogger.error('Failed to delete transaction', failure);
          state = AsyncValue.error(failure, StackTrace.current);
        },
      );
    } catch (e, st) {
      AppLogger.error('Error deleting transaction', e, st);
      state = AsyncValue.error(e, st);
    }
  }
}

/// Riverpod provider for transaction state
final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, TransactionState>(
  () => TransactionNotifier(),
);
