import 'package:flutter/foundation.dart';

/// logger utility
class AppLogger {
  static void log(String message) {
    debugPrint('[AppLog] $message');
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('[Error] $message');
    if (error != null) {
      debugPrint('[Error] $error');
    }
    if (stackTrace != null) {
      debugPrint('[StackTrace] $stackTrace');
    }
  }

  static void warning(String message) {
    debugPrint('[Warning] $message');
  }

  static void debug(String message) {
    debugPrint('[Debug] $message');
  }
}
