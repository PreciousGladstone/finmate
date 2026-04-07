import 'package:flutter/foundation.dart';

/// API Configuration - Easily swap between different backends
class ApiConfig {
  // Base URLs for different environments
  static const String _baseUrlProduction = 'https://api.finmate.com/v1';
  static const String _baseUrlDevelopment = 'http://localhost:3000/v1';

  /// Get base URL based on environment
  /// Change this to switch backends
  static String get baseUrl {
    if (kDebugMode) {
      return _baseUrlDevelopment; // Use local dev server in debug
    }
    return _baseUrlProduction;
  }

  // API Endpoints
  static const String transactionsEndpoint = '/transactions';
  static const String goalsEndpoint = '/goals';

  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 30);

  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Set a custom base URL (useful for testing or connecting to different backends)
  /// Example: ApiConfig.setCustomBaseUrl('https://staging.api.finmate.com/v1');
  static String? _customBaseUrl;

  static void setCustomBaseUrl(String url) {
    debugPrint('ApiConfig: Setting custom base URL: $url');
    _customBaseUrl = url;
  }

  static void resetBaseUrl() {
    debugPrint('ApiConfig: Resetting to default base URL');
    _customBaseUrl = null;
  }

  static String get activeBaseUrl => _customBaseUrl ?? baseUrl;
}
