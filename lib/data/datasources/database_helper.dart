import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

/// SQLite Database Helper for FinMate using sqflite
class DatabaseHelper {
  static const String _dbName = 'finmate.db';
  static const int _dbVersion = 1;

  // Table names
  static const String transactionsTable = 'transactions';
  static const String goalsTable = 'goals';

  // Transaction table columns
  static const String columnId = 'id';
  static const String columnAmount = 'amount';
  static const String columnType = 'type';
  static const String columnCategory = 'category';
  static const String columnDate = 'date';
  static const String columnNotes = 'notes';
  static const String columnCreatedAt = 'createdAt';
  static const String columnUpdatedAt = 'updatedAt';

  // Goals table columns
  static const String columnTitle = 'title';
  static const String columnTargetAmount = 'targetAmount';
  static const String columnCurrentAmount = 'currentAmount';
  static const String columnStartDate = 'startDate';
  static const String columnEndDate = 'endDate';
  static const String columnDescription = 'description';
  static const String columnAchieved = 'achieved';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  /// Get database instance (lazy loading)
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    try {
      debugPrint('Database: Initializing database...');
      final dbPath = await _getDatabasePath();
      debugPrint('Database path: $dbPath');
      
      final db = await openDatabase(
        dbPath,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      
      debugPrint('Database: Successfully initialized');
      return db;
    } catch (e) {
      debugPrint('Database: Error initializing database: $e');
      rethrow;
    }
  }

  /// Get database file path
  Future<String> _getDatabasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return path.join(dir.path, _dbName);
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    try {
      debugPrint('Database: Creating tables...');
      
      // Create transactions table
      await db.execute('''
        CREATE TABLE $transactionsTable (
          $columnId TEXT PRIMARY KEY,
          $columnAmount REAL NOT NULL,
          $columnType TEXT NOT NULL,
          $columnCategory TEXT NOT NULL,
          $columnDate INTEGER NOT NULL,
          $columnNotes TEXT,
          $columnCreatedAt INTEGER NOT NULL,
          $columnUpdatedAt INTEGER
        )
      ''');

      // Create indexes on transactions table
      await db.execute(
        'CREATE INDEX idx_transactions_type ON $transactionsTable($columnType)'
      );
      await db.execute(
        'CREATE INDEX idx_transactions_category ON $transactionsTable($columnCategory)'
      );
      await db.execute(
        'CREATE INDEX idx_transactions_date ON $transactionsTable($columnDate)'
      );

      // Create goals table
      await db.execute('''
        CREATE TABLE $goalsTable (
          $columnId TEXT PRIMARY KEY,
          $columnTitle TEXT NOT NULL,
          $columnTargetAmount REAL NOT NULL,
          $columnCurrentAmount REAL NOT NULL,
          $columnStartDate INTEGER NOT NULL,
          $columnEndDate INTEGER NOT NULL,
          $columnDescription TEXT,
          $columnAchieved INTEGER NOT NULL DEFAULT 0,
          $columnCreatedAt INTEGER NOT NULL,
          $columnUpdatedAt INTEGER
        )
      ''');

      // Create indexes on goals table
      await db.execute(
        'CREATE INDEX idx_goals_achieved ON $goalsTable($columnAchieved)'
      );
      await db.execute(
        'CREATE INDEX idx_goals_endDate ON $goalsTable($columnEndDate)'
      );

      debugPrint('Database: Tables created successfully');
    } catch (e) {
      debugPrint('Database: Error creating tables: $e');
      rethrow;
    }
  }

  /// Handle database upgrade
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Database: Upgrading from version $oldVersion to $newVersion');
    // Add migration logic here if needed
  }

  /// Delete database
  static Future<void> deleteDatabase() async {
    try {
      final dbPath = await _instance._getDatabasePath();
      final file = File(dbPath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Database: Database deleted');
      }
      _instance._database = null;
    } catch (e) {
      debugPrint('Database: Error deleting database: $e');
      rethrow;
    }
  }

  /// Close database
  Future<void> closeDb() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
      debugPrint('Database: Database closed');
    }
  }
}
