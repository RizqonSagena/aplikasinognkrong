import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/stitch_request.dart';
import '../models/stitch_response.dart';
import '../models/stitch_error.dart';
import '../models/stitch_message.dart';

/// Service untuk komunikasi dengan Stitch AI API
class StitchApiService {
  final AppConfig _config = AppConfig();
  final http.Client _client;

  StitchApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Endpoint untuk chat completion
  String get _chatEndpoint => '${_config.stitchApiUrl}/chat/completions';

  /// Send message ke Stitch AI dan dapatkan response
  /// 
  /// [request] - StitchRequest object dengan configuration
  /// Returns: StitchResponse object
  /// Throws: StitchException jika ada error
  Future<StitchResponse> sendMessage(StitchRequest request) async {
    // Validasi konfigurasi
    if (!_config.isConfigured) {
      throw StitchException(
        message: 'Stitch AI belum dikonfigurasi. Periksa file .env Anda.',
      );
    }

    try {
      final response = await _client.post(
        Uri.parse(_chatEndpoint),
        headers: _config.headers,
        body: jsonEncode(request.toJson()),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is StitchException) rethrow;
      throw StitchException(
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Send simple text message ke Stitch AI
  /// 
  /// [message] - Text message dari user
  /// [agentId] - Optional agent ID (default menggunakan dari config)
  /// Returns: String response dari AI
  Future<String> sendSimpleMessage(
    String message, {
    String? agentId,
  }) async {
    final request = StitchRequest.simple(
      agentId: agentId ?? _config.stitchAgentId,
      userMessage: message,
    );

    final response = await sendMessage(request);
    return response.content ?? '';
  }

  /// Send conversation dengan multiple messages
  /// 
  /// [messages] - List of StitchMessage objects
  /// [agentId] - Optional agent ID (default menggunakan dari config)
  /// Returns: StitchResponse object
  Future<StitchResponse> sendConversation(
    List<StitchMessage> messages, {
    String? agentId,
    double? temperature,
    int? maxTokens,
  }) async {
    final request = StitchRequest(
      agentId: agentId ?? _config.stitchAgentId,
      messages: messages,
      temperature: temperature,
      maxTokens: maxTokens,
    );

    return await sendMessage(request);
  }

  /// Handle HTTP response dan convert ke StitchResponse atau throw error
  StitchResponse _handleResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);

    // Success response (200-299)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final jsonData = jsonDecode(body) as Map<String, dynamic>;
        return StitchResponse.fromJson(jsonData);
      } catch (e) {
        throw StitchException(
          message: 'Failed to parse response: ${e.toString()}',
          statusCode: response.statusCode,
        );
      }
    }

    // Error response
    try {
      final jsonData = jsonDecode(body) as Map<String, dynamic>;
      final error = jsonData['error'] != null
          ? StitchError.fromJson(jsonData['error'])
          : null;

      throw StitchException(
        message: error?.message ?? 'Request failed',
        statusCode: response.statusCode,
        error: error,
      );
    } catch (e) {
      if (e is StitchException) rethrow;
      
      throw StitchException(
        message: 'HTTP ${response.statusCode}: $body',
        statusCode: response.statusCode,
      );
    }
  }

  /// Test koneksi ke Stitch AI API
  /// 
  /// Returns: true jika berhasil connect
  Future<bool> testConnection() async {
    try {
      await sendSimpleMessage('Hello');
      return true;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  /// Cleanup resources
  void dispose() {
    _client.close();
  }
}
