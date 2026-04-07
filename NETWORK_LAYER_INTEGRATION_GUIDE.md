# FinMate Network Layer Integration Architecture Guide

## Overview
This guide documents the current data layer architecture and provides recommendations for integrating a remote network layer while maintaining the existing clean architecture pattern.

---

## 1. Current Data Layer Structure

### 1.1 Directory Organization
```
lib/
├── data/
│   ├── datasources/           # Data layer abstractions
│   │   ├── database_helper.dart
│   │   ├── transaction_local_data_source.dart
│   │   └── goal_local_data_source.dart
│   ├── models/                # Data models with JSON serialization
│   │   ├── transaction_model.dart
│   │   └── goal_model.dart
│   ├── repositories/          # Repository implementations
│   │   ├── transaction_repository_impl.dart
│   │   └── goal_repository_impl.dart
│   └── database/
├── domain/
│   ├── entities/              # Business logic models
│   │   ├── transaction.dart
│   │   └── goal.dart
│   ├── repositories/          # Repository interfaces
│   │   ├── transaction_repository.dart
│   │   └── goal_repository.dart
│   └── usecases/              # Business logic use cases
│       ├── transaction_usecases.dart
│       └── goal_usecases.dart
└── core/
    ├── constants/
    └── utils/
        ├── result.dart        # Result<T> type for error handling
        └── service_locator.dart
```

---

## 2. Datasource Interfaces & Implementations

### 2.1 TransactionLocalDataSource

#### **Abstract Interface**
```dart
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
```

#### **Key Implementation Details**
- **Location**: `lib/data/datasources/transaction_local_data_source.dart`
- **Class**: `TransactionLocalDataSourceImpl`
- **Dependencies**: `DatabaseHelper` (singleton)
- **Error Handling**: Throws `DatabaseException` from `core/errors/exceptions.dart`
- **Logging**: Uses `AppLogger.error()` and `debugPrint()`
- **Return Type**: Direct models (not wrapped in Result)

#### **Key Methods Pattern**:
```dart
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
    AppLogger.error('Error adding transaction', e);
    throw app_exceptions.DatabaseException(message: 'Failed to add transaction');
  }
}
```

### 2.2 GoalLocalDataSource

#### **Abstract Interface**
```dart
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
```

#### **Key Implementation Details**
- **Location**: `lib/data/datasources/goal_local_data_source.dart`
- **Class**: `GoalLocalDataSourceImpl`
- **Dependencies**: `DatabaseHelper` (singleton)
- **Error Handling**: Throws `DatabaseException`
- **Pattern**: Nearly identical to TransactionLocalDataSource

---

## 3. Model Structure & JSON Serialization

### 3.1 TransactionModel

#### **Key Features**:
- **Inheritance**: Extends `Transaction` entity
- **JSON Methods**: `fromJson()` / `toJson()`
- **Database Methods**: `fromDb()` / `toDb()`
- **Entity Conversion**: `fromEntity()` for Entity → Model conversion
- **DateTime Handling**: Milliseconds since epoch conversion

#### **Complete Example**:
```dart
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,           // UUID string
    required super.amount,       // double
    required super.type,         // 'Income' or 'Expense'
    required super.category,     // Category string
    required super.date,         // DateTime
    super.notes,                 // nullable String
    required super.createdAt,    // DateTime
    super.updatedAt,             // nullable DateTime
  });

  // Create from Entity
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      // ... copy all fields
    );
  }

  // Create from JSON/API Response
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      category: json['category'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      notes: json['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Database conversion (same as JSON)
  Map<String, dynamic> toDb() => toJson();
  factory TransactionModel.fromDb(Map<String, dynamic> json) =>
      TransactionModel.fromJson(json);
}
```

### 3.2 GoalModel
- **Same pattern** as TransactionModel
- **Difference**: `achieved` stored as int (1/0) in DB, converted to bool
- **Key logic**: `progressPercentage`, `remainingAmount`, `daysRemaining` calculations

---

## 4. Repository Pattern

### 4.1 Repository Interface (Domain Layer)

**File**: `lib/domain/repositories/transaction_repository.dart`

```dart
abstract class TransactionRepository {
  Future<Result<List<Transaction>>> getAllTransactions();
  Future<Result<List<Transaction>>> getTransactionsByType(String type);
  Future<Result<List<Transaction>>> getTransactionsByCategory(String category);
  Future<Result<List<Transaction>>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<Result<List<Transaction>>> searchTransactions(String query);
  Future<Result<Transaction>> getTransactionById(String id);
  Future<Result<Transaction>> addTransaction(Transaction transaction);
  Future<Result<Transaction>> updateTransaction(Transaction transaction);
  Future<Result<void>> deleteTransaction(String id);
  Future<Result<void>> deleteAllTransactions();
  Future<Result<double>> getTotalIncome();
  Future<Result<double>> getTotalExpense();
  Future<Result<double>> getCurrentBalance();
}
```

**Key Pattern**: Returns `Result<T>` (not raw data)

### 4.2 Repository Implementation (Data Layer)

**File**: `lib/data/repositories/transaction_repository_impl.dart`

```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<Transaction>>> getAllTransactions() async {
    try {
      final transactions = await localDataSource.getAllTransactions();
      return Result.success(transactions);  // ✓ Wrap in Result
    } on DatabaseException catch (e) {
      return Result.failure(e.message);     // ✓ Handle known exception
    } catch (e) {
      return Result.failure('Unknown error occurred');  // ✓ Handle unknown
    }
  }
}
```

**Key Pattern**:
1. **Call datasource** (throws exceptions)
2. **Catch DatabaseException** → wrap in Result.failure()
3. **Catch generic Exception** → wrap in Result.failure()
4. **Success case** → wrap in Result.success()

### 4.3 Result<T> Type

**File**: `lib/core/utils/result.dart`

```dart
sealed class Result<T> {
  factory Result.success(T data) => Success(data);
  factory Result.failure(dynamic failure) => _FailureResult<T>(failure);

  R map<R>({
    required R Function(Success<T> success) onSuccess,
    required R Function(dynamic failure) onFailure,
  }) { /* ... */ }

  V fold<V>({
    required V Function(T data) onSuccess,
    required V Function(dynamic failure) onFailure,
  }) { /* ... */ }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class _FailureResult<T> extends Result<T> {
  final dynamic failure;
  const _FailureResult(this.failure);
}
```

**Usage in Repository**:
```dart
final result = await repository.getAllTransactions();
result.fold(
  onSuccess: (transactions) => print('Got ${transactions.length} transactions'),
  onFailure: (error) => print('Error: $error'),
);
```

---

## 5. Service Locator Setup

**File**: `lib/core/utils/service_locator.dart`

### 5.1 Current Setup Pattern

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1. Register Database (lowest level)
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper());

  // 2. Register Datasources (depend on database)
  getIt.registerSingleton<TransactionLocalDataSource>(
    TransactionLocalDataSourceImpl(databaseHelper: getIt<DatabaseHelper>()),
  );

  // 3. Register Repositories (depend on datasources)
  getIt.registerSingleton<TransactionRepository>(
    TransactionRepositoryImpl(localDataSource: getIt<TransactionLocalDataSource>()),
  );

  // 4. Register Use Cases (depend on repositories)
  getIt.registerSingleton<GetAllTransactionsUseCase>(
    GetAllTransactionsUseCase(repository: getIt<TransactionRepository>()),
  );
}
```

### 5.2 Dependency Chain
```
DatabaseHelper (database)
    ↓
TransactionLocalDataSource (local datasource)
    ↓
TransactionRepository (repository interface impl)
    ↓
TransactionUseCase* (business logic)
```

### 5.3 Usage in UI
```dart
// In Riverpod provider or UI
final repository = getIt<TransactionRepository>();
final result = await repository.getAllTransactions();
```

---

## 6. Exception Handling

**File**: `lib/core/errors/exceptions.dart`

```dart
abstract class AppException implements Exception {
  final String message;
  const AppException({required this.message});
}

class DatabaseException extends AppException {
  const DatabaseException({required super.message});
}

class CacheException extends AppException {
  const CacheException({required super.message});
}

class ValidationException extends AppException {
  const ValidationException({required super.message});
}
```

**Current Limitations**:
- ❌ No `NetworkException` defined yet
- ❌ Only `DatabaseException` used in repositories
- ✓ Pattern established for extensibility

---

## 7. Where to Place Constants & API Configuration

### 7.1 Current Constants Location
**File**: `lib/core/constants/app_constants.dart`

```dart
class AppStrings { /* UI strings */ }
class AppConstants {
  static const int dbVersion = 1;
  static const String dbName = 'finmate.db';
  // ...
}
class TransactionCategory { /* categories */ }
```

### 7.2 Recommended API Configuration Locations

#### **Option 1: New config file**
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://api.finmate.com';
  static const String apiVersion = '/v1';
  static const int connectTimeout = 30000; // ms
  static const int receiveTimeout = 15000; // ms
}
```

#### **Option 2: Extend app_constants.dart**
```dart
// lib/core/constants/app_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.finmate.com';
  static const String apiVersion = '/v1';
  // ...
}
```

#### **Option 3: Environment-based config**
```dart
// lib/core/config/environment.dart
enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment currentEnvironment = Environment.development;
  
  static String get apiBaseUrl {
    switch (currentEnvironment) {
      case Environment.production:
        return 'https://api.finmate.com';
      case Environment.staging:
        return 'https://staging-api.finmate.com';
      case Environment.development:
        return 'http://localhost:8000';
    }
  }
}
```

**Recommendation**: Use **Option 2** (extend app_constants) for simplicity, move to Option 3 if needs grow.

---

## 8. Database Helper Reference

**File**: `lib/data/datasources/database_helper.dart`

### Key Constants
```dart
static const String _dbName = 'finmate.db';
static const int _dbVersion = 1;

static const String transactionsTable = 'transactions';
static const String goalsTable = 'goals';

// Column names (standard pattern)
static const String columnId = 'id';
static const String columnAmount = 'amount';
static const String columnType = 'type';
// ... etc
```

### Singleton Pattern
```dart
static final DatabaseHelper _instance = DatabaseHelper._internal();

Database? _database;

factory DatabaseHelper() {
  return _instance;
}

DatabaseHelper._internal();

Future<Database> get database async {
  _database ??= await _initDatabase();
  return _database!;
}
```

---

## 9. Recommended Remote Datasource Structure

### 9.1 Pattern for New Remote Datasources

**File**: `lib/data/datasources/transaction_remote_data_source.dart`

```dart
/// Abstract interface for transaction remote data source
abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> syncTransactions({
    required DateTime lastSyncTime,
  });
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<List<TransactionModel>> getRemoteTransactions();
}

/// Implementation using HTTP client
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final HttpClient httpClient;  // Could be http, dio, or custom
  final String baseUrl;

  TransactionRemoteDataSourceImpl({
    required this.httpClient,
    required this.baseUrl,
  });

  @override
  Future<List<TransactionModel>> getRemoteTransactions() async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/transactions'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw NetworkException(message: 'Unauthorized');
      } else {
        throw NetworkException(message: 'Failed to fetch transactions');
      }
    } catch (e) {
      AppLogger.error('Error fetching transactions from remote', e);
      throw NetworkException(message: 'Network error occurred');
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(transaction.toJson()),
      );

      if (response.statusCode == 201) {
        return TransactionModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw NetworkException(message: 'Failed to create transaction');
      }
    } catch (e) {
      AppLogger.error('Error creating transaction', e);
      throw NetworkException(message: 'Network error occurred');
    }
  }
}
```

### 9.2 How to Integrate Remote Datasource

#### **Step 1**: Add to exceptions
```dart
// lib/core/errors/exceptions.dart
class NetworkException extends AppException {
  const NetworkException({required super.message});
}
```

#### **Step 2**: Update Repository Implementation
```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;  // Add this

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,  // Inject
  });

  // Strategy 1: Try remote first, fallback to local
  @override
  Future<Result<List<Transaction>>> getAllTransactions() async {
    try {
      final transactions = await remoteDataSource.getRemoteTransactions();
      // Save to local cache
      for (var transaction in transactions) {
        await localDataSource.addTransaction(transaction);
      }
      return Result.success(transactions);
    } on NetworkException catch (e) {
      // Fallback to local
      final cached = await localDataSource.getAllTransactions();
      return cached.isEmpty 
          ? Result.failure(e.message)
          : Result.success(cached);
    }
  }

  // Strategy 2: Sync and merge
  @override
  Future<Result<Transaction>> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final local = await localDataSource.addTransaction(model);
      // Try to sync to remote
      try {
        await remoteDataSource.createTransaction(model);
      } catch (e) {
        // Queue for later sync
      }
      return Result.success(local);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unknown error occurred');
    }
  }
}
```

#### **Step 3**: Register in Service Locator
```dart
// lib/core/utils/service_locator.dart
void setupServiceLocator() {
  // ... existing code ...

  // HTTP Client
  getIt.registerSingleton<HttpClient>(
    HttpClient(),
  );

  // Remote Datasources
  getIt.registerSingleton<TransactionRemoteDataSource>(
    TransactionRemoteDataSourceImpl(
      httpClient: getIt<HttpClient>(),
      baseUrl: ApiConfig.baseUrl,
    ),
  );

  // Updated Repository with both local and remote
  getIt.registerSingleton<TransactionRepository>(
    TransactionRepositoryImpl(
      localDataSource: getIt<TransactionLocalDataSource>(),
      remoteDataSource: getIt<TransactionRemoteDataSource>(),
    ),
  );

  // ... rest of setup ...
}
```

---

## 10. Summary: Integration Checklist

### To integrate a network layer, follow these steps:

- [ ] **Add NetworkException** to `lib/core/errors/exceptions.dart`
- [ ] **Add API Config** to `lib/core/constants/app_constants.dart` or new `lib/core/config/api_config.dart`
- [ ] **Create Remote Datasources**:
  - [ ] `lib/data/datasources/transaction_remote_data_source.dart`
  - [ ] `lib/data/datasources/goal_remote_data_source.dart`
- [ ] **Update Repository Implementations** to accept both local and remote datasources
- [ ] **Register HTTP Client and Remote Datasources** in `setupServiceLocator()`
- [ ] **Implement sync strategy**: 
  - [ ] Remote-first with local fallback?
  - [ ] Local-first with background sync?
  - [ ] Bidirectional sync?
- [ ] **Add offline handling** in repository layer
- [ ] **Update models** if API response format differs from local format

### Key Files to Reference
- ✓ `lib/data/datasources/transaction_local_data_source.dart` - Pattern template
- ✓ `lib/data/repositories/transaction_repository_impl.dart` - Repository pattern
- ✓ `lib/core/utils/result.dart` - Error handling type
- ✓ `lib/core/utils/service_locator.dart` - DI setup
- ✓ `lib/domain/repositories/transaction_repository.dart` - Interface contract

