import 'package:flutter/foundation.dart';
import '../models/stitch_message.dart';
import '../models/stitch_response.dart';
import 'stitch_api_service.dart';

/// Provider untuk manage chat state dengan Stitch AI
class StitchChatProvider with ChangeNotifier {
  final StitchApiService _apiService;
  
  List<StitchMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  StitchChatProvider({StitchApiService? apiService})
      : _apiService = apiService ?? StitchApiService();

  // Getters
  List<StitchMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMessages => _messages.isNotEmpty;

  /// Send user message dan dapatkan response dari AI
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Clear error
    _error = null;

    // Add user message
    final userMessage = StitchMessage.user(content);
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      // Send ke Stitch AI
      final response = await _apiService.sendConversation(_messages);

      // Add assistant response
      if (response.content != null) {
        final assistantMessage = StitchMessage.assistant(response.content!);
        _messages.add(assistantMessage);
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error sending message: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send message dengan custom configuration
  Future<StitchResponse?> sendMessageAdvanced({
    required String content,
    double? temperature,
    int? maxTokens,
  }) async {
    if (content.trim().isEmpty) return null;

    _error = null;
    final userMessage = StitchMessage.user(content);
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.sendConversation(
        _messages,
        temperature: temperature,
        maxTokens: maxTokens,
      );

      if (response.content != null) {
        final assistantMessage = StitchMessage.assistant(response.content!);
        _messages.add(assistantMessage);
      }

      _error = null;
      return response;
    } catch (e) {
      _error = e.toString();
      print('Error sending message: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear semua messages
  void clearMessages() {
    _messages.clear();
    _error = null;
    notifyListeners();
  }

  /// Remove message tertentu
  void removeMessage(int index) {
    if (index >= 0 && index < _messages.length) {
      _messages.removeAt(index);
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Test koneksi ke API
  Future<bool> testConnection() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.testConnection();
      if (!result) {
        _error = 'Connection test failed';
      }
      return result;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
