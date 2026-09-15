import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi untuk Stitch AI
class AppConfig {
  // Singleton pattern
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  /// API Key dari Stitch AI
  String get stitchApiKey => dotenv.env['STITCH_API_KEY'] ?? '';

  /// Base URL untuk Stitch AI API
  String get stitchApiUrl => dotenv.env['STITCH_API_URL'] ?? 'https://api.stitch.tech/v1';

  /// Agent ID dari Stitch AI
  String get stitchAgentId => dotenv.env['STITCH_AGENT_ID'] ?? '';

  /// Validasi apakah semua konfigurasi sudah diset
  bool get isConfigured {
    return stitchApiKey.isNotEmpty && 
           stitchApiUrl.isNotEmpty && 
           stitchAgentId.isNotEmpty;
  }

  /// Headers untuk API request
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $stitchApiKey',
  };

  /// Print status konfigurasi (untuk debugging)
  void printStatus() {
    print('=== Stitch AI Configuration ===');
    print('API URL: $stitchApiUrl');
    print('Agent ID: $stitchAgentId');
    print('API Key: ${stitchApiKey.isNotEmpty ? "✓ Set" : "✗ Not Set"}');
    print('Configured: ${isConfigured ? "✓ Yes" : "✗ No"}');
    print('==============================');
  }
}
