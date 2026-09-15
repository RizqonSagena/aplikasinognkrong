import 'package:flutter/foundation.dart';

/// Simple logger utility untuk debugging
class Logger {
  static const String _prefix = '🔷 StitchAI';

  /// Log info message
  static void info(String message) {
    if (kDebugMode) {
      print('$_prefix ℹ️  $message');
    }
  }

  /// Log success message
  static void success(String message) {
    if (kDebugMode) {
      print('$_prefix ✅ $message');
    }
  }

  /// Log warning message
  static void warning(String message) {
    if (kDebugMode) {
      print('$_prefix ⚠️  $message');
    }
  }

  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('$_prefix ❌ $message');
      if (error != null) {
        print('   Error: $error');
      }
      if (stackTrace != null) {
        print('   StackTrace: $stackTrace');
      }
    }
  }

  /// Log API request
  static void apiRequest(String method, String endpoint, [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      print('$_prefix 📤 API Request: $method $endpoint');
      if (data != null && data.isNotEmpty) {
        print('   Data: $data');
      }
    }
  }

  /// Log API response
  static void apiResponse(int statusCode, [dynamic data]) {
    if (kDebugMode) {
      final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
      print('$_prefix 📥 API Response: $emoji $statusCode');
      if (data != null) {
        print('   Data: $data');
      }
    }
  }

  /// Log divider
  static void divider() {
    if (kDebugMode) {
      print('$_prefix ═══════════════════════════════════');
    }
  }
}
