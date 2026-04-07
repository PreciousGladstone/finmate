import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:finmate/core/config/api_config.dart';
import 'package:finmate/core/errors/network_exception.dart';

/// HTTP Client wrapper around Dio
/// Handles all HTTP operations with proper error handling and retry logic
class HttpClient {
  late final Dio _dio;

  HttpClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.activeBaseUrl,
        connectTimeout: ApiConfig.requestTimeout,
        receiveTimeout: ApiConfig.requestTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
        ),
      );
    }

    // Add retry interceptor
    _dio.interceptors.add(_RetryInterceptor());

    debugPrint('HttpClient: Initialized with base URL: ${ApiConfig.activeBaseUrl}');
  }

  /// GET request
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('HttpClient: GET $path');
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(headers),
      );
      debugPrint('HttpClient: GET $path - Success (${response.statusCode})');
      return response.data ?? {};
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnexpectedNetworkException(
        message: 'Unexpected error: $e',
        originalError: e,
      );
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('HttpClient: POST $path');
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers),
      );
      debugPrint('HttpClient: POST $path - Success (${response.statusCode})');
      return response.data ?? {};
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnexpectedNetworkException(
        message: 'Unexpected error: $e',
        originalError: e,
      );
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('HttpClient: PUT $path');
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers),
      );
      debugPrint('HttpClient: PUT $path - Success (${response.statusCode})');
      return response.data ?? {};
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnexpectedNetworkException(
        message: 'Unexpected error: $e',
        originalError: e,
      );
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('HttpClient: DELETE $path');
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers),
      );
      debugPrint('HttpClient: DELETE $path - Success (${response.statusCode})');
      return response.data ?? {};
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnexpectedNetworkException(
        message: 'Unexpected error: $e',
        originalError: e,
      );
    }
  }

  /// Build request options with custom headers
  Options _buildOptions(Map<String, String>? customHeaders) {
    final options = Options(headers: ApiConfig.defaultHeaders);
    if (customHeaders != null) {
      options.headers?.addAll(customHeaders);
    }
    return options;
  }

  /// Handle Dio exceptions and convert to custom exceptions
  NetworkException _handleDioException(DioException e) {
    debugPrint('HttpClient: DioException - ${e.type} ${e.message}');

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.connectionError:
        return NoInternetException();

      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.data['message'] ?? 'Server error',
          statusCode: e.response?.statusCode ?? 500,
          originalError: e,
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnexpectedNetworkException(
          message: e.message ?? 'Unknown error occurred',
          originalError: e,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
          originalError: e,
        );
    }
  }

  /// Update base URL at runtime
  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
    debugPrint('HttpClient: Base URL changed to $url');
  }
}

/// Retry interceptor - Automatically retries failed requests
class _RetryInterceptor extends Interceptor {
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        debugPrint(
          'HttpClient: Retrying request (${err.requestOptions.path})',
        );
        await Future.delayed(ApiConfig.retryDelay);
        final response = await Dio().request<dynamic>(
          err.requestOptions.path,
          options: err.requestOptions,
        );
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  /// Determine if request should be retried
  bool _shouldRetry(DioException error) {
    // Retry on network errors and server errors (5xx)
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }

    if (error.response?.statusCode != null) {
      return error.response!.statusCode! >= 500;
    }

    return false;
  }
}
