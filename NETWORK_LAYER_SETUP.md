# Network Layer Implementation Guide

## Overview

The network layer has been set up following **Clean Architecture** principles with flexibility to connect to **any backend API** without code changes.

## Architecture Diagram

```
UI Layer (Pages/Widgets)
    ↓
Providers
    ↓
UseCases
    ↓
Repositories ← Implements Cache-Then-Network Pattern
    ├── Local DataSource (SQLite)
    └── Remote DataSource (HttpClient)
        ↓
    HttpClient (Dio)
        ↓
    Backend API (Any provider)
```

## Components

### 1. **ApiConfig** (`lib/core/config/api_config.dart`)
**Centralized API configuration** - Change backend without touching code:

```dart
// Switch to different backend
ApiConfig.setCustomBaseUrl('https://staging-api.finmate.com/v1');

// Reset to default
ApiConfig.resetBaseUrl();
```

**Features:**
- Environment-based base URLs (dev/production)
- Default headers configuration
- Request timeouts
- Retry configuration

### 2. **HttpClient** (`lib/core/network/http_client.dart`)
**Wrapper around Dio** with:
- ✅ Automatic retries for failed requests
- ✅ Error handling with custom exceptions
- ✅ Request/response logging (debug mode only)
- ✅ Timeout management
- ✅ Custom header support

**Usage:**
```dart
final httpClient = getIt<HttpClient>();
final data = await httpClient.get('/transactions');
final result = await httpClient.post('/transactions', data: {...});
await httpClient.put('/transactions/:id', data: {...});
await httpClient.delete('/transactions/:id');
```

### 3. **Network Exceptions** (`lib/core/errors/network_exception.dart`)
**Consistent error handling:**

- `NoInternetException` - Network connectivity issues
- `ServerException` - Server returned error (4xx, 5xx)
- `TimeoutException` - Request timed out
- `ParseException` - JSON/response parsing failed
- `UnexpectedNetworkException` - Unknown errors

### 4. **Remote DataSources**

#### TransactionRemoteDataSource Interface
```dart
abstract class TransactionRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllTransactions();
  Future<Map<String, dynamic>> getTransactionById(String id);
  Future<Map<String, dynamic>> addTransaction(Map<String, dynamic> transaction);
  Future<Map<String, dynamic>> updateTransaction(String id, Map<String, dynamic> transaction);
  Future<void> deleteTransaction(String id);
  Future<List<Map<String, dynamic>>> syncTransactions(List<Map<String, dynamic>> localTransactions);
}
```

#### Implementation Pattern
Implemented in `TransactionRemoteDataSourceImpl` using `HttpClient`:

```dart
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final HttpClient _httpClient;

  @override
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final response = await _httpClient.get(ApiConfig.transactionsEndpoint);
    return response['data'] as List<Map<String, dynamic>>;
  }
  
  // ... more methods
}
```

**Same pattern for Goals:**
- `GoalRemoteDataSource` (interface)
- `GoalRemoteDataSourceImpl` (implementation)

## How to Integrate with Any Backend

### Step 1: Update API Config

Set your backend URL in `ApiConfig`:

```dart
// lib/core/config/api_config.dart
static const String _baseUrlProduction = 'https://YOUR-API.com/v1';
static const String _baseUrlDevelopment = 'https://YOUR-DEV-API.com/v1';
```

### Step 2: Adjust Response Parsing

If your backend returns different response formats, update the remote datasources:

```dart
// If API returns { "data": [...] }
final transactions = response['data'] as List<dynamic>;

// If API returns { "transactions": [...] }
final transactions = response['transactions'] as List<dynamic>;

// If API returns array directly
final transactions = response is List ? response : [];
```

### Step 3: Add Authentication (Optional)

Add headers to `HttpClient`:

```dart
// In service_locator.dart, after registering HttpClient:
getIt<HttpClient>().setDefaultHeader('Authorization', 'Bearer $token');

// Or per-request:
await httpClient.get(
  '/transactions',
  headers: {'Authorization': 'Bearer $token'}
);
```

### Step 4: Handle Custom Error Responses

If your API returns custom error format:

```dart
// In HttpClient._handleDioException():
if (e.response?.statusCode == 400) {
  final message = e.response?.data['customErrorMessage'] ?? 'Bad request';
  throw ServerException(message: message, statusCode: 400);
}
```

## Cache-Then-Network Pattern

### How It Works

1. **User opens app** → Load from local DB (instant)
2. **Parallel** → Fetch from remote API
3. **Newer data?** → Update local DB
4. **Show updated data** to user

### Implementation in Repositories

Currently, repositories use **local-only** mode. To implement cache-then-network:

```dart
// Example: TransactionRepositoryImpl

@override
Future<Result<List<Transaction>>> getAllTransactions() async {
  try {
    // 1. Get local data (fast, instant display)
    final localTransactions = await _localDataSource.getAllTransactions();
    
    // 2. Fetch remote data in parallel (don't await, run in background)
    _fetchRemoteAndSync(localTransactions);
    
    // 3. Return local data immediately
    return const Right([...]); // Your transactions
  } catch (e) {
    return Left(DatabaseFailure(message: e.toString()));
  }
}

// Background sync
Future<void> _fetchRemoteAndSync(List<Transaction> local) async {
  try {
    final remote = await _remoteDataSource.getAllTransactions();
    // Compare timestamps and update local
    await _localDataSource.syncTransactions(remote);
  } catch (e) {
    // Silently fail - user already has local data
    debugPrint('Sync failed: $e');
  }
}
```

## File Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart .................... API configuration
│   ├── errors/
│   │   └── network_exception.dart ............ Network exceptions
│   └── network/
│       └── http_client.dart .................. Dio wrapper
│
├── data/
│   └── datasources/
│       ├── transaction_remote_data_source.dart .......... Interface
│       ├── transaction_remote_data_source_impl.dart .... Implementation
│       ├── goal_remote_data_source.dart ............... Interface
│       └── goal_remote_data_source_impl.dart ......... Implementation
```

## Testing Different Backends

### Switch Between Dev and Production

```dart
void main() {
  setupServiceLocator();
  
  // Use development API
  ApiConfig.setCustomBaseUrl('http://localhost:3000/v1');
  
  runApp(const MyApp());
}
```

### Mock Backend for Testing

```dart
// Create a MockRemoteDataSource implementing the interface
class MockTransactionRemoteDataSource implements TransactionRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    return [
      {'id': '1', 'amount': 100, 'type': 'Income', ...},
      {'id': '2', 'amount': 50, 'type': 'Expense', ...},
    ];
  }
  // ... implement other methods
}

// In tests, inject the mock:
getIt.unregister<TransactionRemoteDataSource>();
getIt.registerSingleton<TransactionRemoteDataSource>(MockTransactionRemoteDataSource());
```

## Backend API Contract

Your backend should follow this contract:

### GET /transactions
**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "amount": 100.50,
      "type": "Income",
      "category": "Food",
      "date": 1712345678000,
      "notes": "Optional notes",
      "createdAt": 1712345678000,
      "updatedAt": 1712345678000
    }
  ]
}
```

### POST /transactions
**Request:**
```json
{
  "amount": 100.50,
  "type": "Income",
  "category": "Food",
  "date": 1712345678000,
  "notes": "Optional"
}
```

### GET /goals
Similar structure to transactions

### POST /sync Endpoint (Optional)
**For bulk sync with conflict resolution:**
```json
{
  "transactions": [...],
  "timestamp": 1712345678000
}
```

## Next Steps

1. ✅ **Implement Cache-Then-Network** in repositories
2. ✅ **Update providers** to handle sync status
3. ✅ **Add authentication layer** (if needed)
4. ✅ **Implement offline queue** for writes when no internet
5. ✅ **Add data sync UI** (sync indicator, retry button)

## File Changes Summary

**Added Files:**
- ✅ `lib/core/config/api_config.dart`
- ✅ `lib/core/network/http_client.dart`
- ✅ `lib/core/errors/network_exception.dart`
- ✅ `lib/data/datasources/transaction_remote_data_source.dart`
- ✅ `lib/data/datasources/transaction_remote_data_source_impl.dart`
- ✅ `lib/data/datasources/goal_remote_data_source.dart`
- ✅ `lib/data/datasources/goal_remote_data_source_impl.dart`

**Modified Files:**
- ✅ `lib/core/utils/service_locator.dart` (added HttpClient and remote datasources)
- ✅ `pubspec.yaml` (added dio: ^5.3.0)

---

**Ready to connect any backend!** 🚀
