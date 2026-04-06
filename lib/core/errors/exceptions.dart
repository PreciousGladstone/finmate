/// Custom exceptions for the application
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
