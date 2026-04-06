import 'package:flutter/foundation.dart';
import 'package:finmate/core/errors/exceptions.dart' as app_exceptions;
import 'package:finmate/core/utils/app_logger.dart';
import 'package:finmate/data/models/transaction_model.dart';
import 'package:finmate/data/datasources/database_helper.dart';

/// Abstract class for transaction local data source
abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getTransactionsByType(String type);
  Future<List<TransactionModel>> getTransactionsByCategory(String category);
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<List<TransactionModel>> searchTransactions(String query);
  Future<TransactionModel> getTransactionById(String id);
  Future<TransactionModel> addTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> deleteAllTransactions();
  Future<double> getTotalIncome();
  Future<double> getTotalExpense();
}

/// Implementation of transaction local data source using sqflite
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseHelper databaseHelper;

  TransactionLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      debugPrint('TransactionLocalDataSource: getAllTransactions starting...');
      final db = await databaseHelper.database;
      final result = await db.query(DatabaseHelper.transactionsTable);
      debugPrint('TransactionLocalDataSource: query completed, found ${result.length} transactions');
      return result.map((row) => TransactionModel.fromDb(row)).toList();
    } catch (e) {
      AppLogger.error('Error getting all transactions', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get transactions');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.transactionsTable,
        where: '${DatabaseHelper.columnType} = ?',
        whereArgs: [type],
      );
      return result.map((row) => TransactionModel.fromDb(row)).toList();
    } catch (e) {
      AppLogger.error('Error getting transactions by type: $type', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get transactions by type');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.transactionsTable,
        where: '${DatabaseHelper.columnCategory} = ?',
        whereArgs: [category],
      );
      return result.map((row) => TransactionModel.fromDb(row)).toList();
    } catch (e) {
      AppLogger.error('Error getting transactions by category: $category', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get transactions by category');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final db = await databaseHelper.database;
      final startMs = startDate.millisecondsSinceEpoch;
      final endMs = endDate.millisecondsSinceEpoch;
      
      final result = await db.query(
        DatabaseHelper.transactionsTable,
        where: '${DatabaseHelper.columnDate} BETWEEN ? AND ?',
        whereArgs: [startMs, endMs],
        orderBy: '${DatabaseHelper.columnDate} DESC',
      );
      return result.map((row) => TransactionModel.fromDb(row)).toList();
    } catch (e) {
      AppLogger.error('Error getting transactions by date range', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get transactions by date range');
    }
  }

  @override
  Future<List<TransactionModel>> searchTransactions(String query) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.transactionsTable,
        where: '${DatabaseHelper.columnNotes} LIKE ? OR ${DatabaseHelper.columnCategory} LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: '${DatabaseHelper.columnDate} DESC',
      );
      return result.map((row) => TransactionModel.fromDb(row)).toList();
    } catch (e) {
      AppLogger.error('Error searching transactions: $query', e);
      throw app_exceptions.DatabaseException(message: 'Failed to search transactions');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.transactionsTable,
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id],
      );
      
      if (result.isEmpty) {
        throw app_exceptions.DatabaseException(message: 'Transaction not found');
      }
      return TransactionModel.fromDb(result.first);
    } catch (e) {
      AppLogger.error('Error getting transaction by id: $id', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get transaction');
    }
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(
        DatabaseHelper.transactionsTable,
        transaction.toDb(),
      );
      return transaction;
    } catch (e) {
      debugPrint('TransactionLocalDataSource: Error adding transaction: $e');
      AppLogger.error('Error adding transaction', e);
      throw app_exceptions.DatabaseException(message: 'Failed to add transaction');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    try {
      final db = await databaseHelper.database;
      final success = await db.update(
        DatabaseHelper.transactionsTable,
        transaction.toDb(),
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [transaction.id],
      );
      if (success == 0) {
        throw app_exceptions.DatabaseException(message: 'Failed to update transaction');
      }
      return transaction;
    } catch (e) {
      AppLogger.error('Error updating transaction', e);
      throw app_exceptions.DatabaseException(message: 'Failed to update transaction');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        DatabaseHelper.transactionsTable,
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      AppLogger.error('Error deleting transaction: $id', e);
      throw app_exceptions.DatabaseException(message: 'Failed to delete transaction');
    }
  }

  @override
  Future<void> deleteAllTransactions() async {
    try {
      final db = await databaseHelper.database;
      await db.delete(DatabaseHelper.transactionsTable);
    } catch (e) {
      AppLogger.error('Error deleting all transactions', e);
      throw app_exceptions.DatabaseException(message: 'Failed to delete all transactions');
    }
  }

  @override
  Future<double> getTotalIncome() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COALESCE(SUM(${DatabaseHelper.columnAmount}), 0) as total FROM ${DatabaseHelper.transactionsTable} WHERE ${DatabaseHelper.columnType} = ?',
        ['Income'],
      );
      final total = result.isNotEmpty ? (result.first['total'] as num?)?.toDouble() ?? 0.0 : 0.0;
      return total;
    } catch (e) {
      AppLogger.error('Error getting total income', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get total income');
    }
  }

  @override
  Future<double> getTotalExpense() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COALESCE(SUM(${DatabaseHelper.columnAmount}), 0) as total FROM ${DatabaseHelper.transactionsTable} WHERE ${DatabaseHelper.columnType} = ?',
        ['Expense'],
      );
      final total = result.isNotEmpty ? (result.first['total'] as num?)?.toDouble() ?? 0.0 : 0.0;
      return total;
    } catch (e) {
      AppLogger.error('Error getting total expense', e);
      throw app_exceptions.DatabaseException(message: 'Failed to get total expense');
    }
  }
}
