/// Network-related exceptions
class NetworkException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  NetworkException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'NetworkException: $message (code: $code)';
}

/// Thrown when the connection is lost
class NoInternetException extends NetworkException {
  NoInternetException()
      : super(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        );
}

/// Thrown when the server returns an error response
class ServerException extends NetworkException {
  final int statusCode;

  ServerException({
    required String message,
    required this.statusCode,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? statusCode.toString(),
          originalError: originalError,
        );
}

/// Thrown when the request times out
class TimeoutException extends NetworkException {
  TimeoutException()
      : super(
          message: 'Request timeout',
          code: 'TIMEOUT',
        );
}

/// Thrown when there's a parsing error
class ParseException extends NetworkException {
  ParseException({
    required String message,
    dynamic originalError,
  }) : super(
          message: message,
          code: 'PARSE_ERROR',
          originalError: originalError,
        );
}

/// Thrown for unexpected errors
class UnexpectedNetworkException extends NetworkException {
  UnexpectedNetworkException({
    required String message,
    dynamic originalError,
  }) : super(
          message: message,
          code: 'UNEXPECTED_ERROR',
          originalError: originalError,
        );
}
