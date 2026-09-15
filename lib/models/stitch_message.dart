import 'package:json_annotation/json_annotation.dart';

part 'stitch_message.g.dart';

/// Model untuk message dalam conversation dengan Stitch AI
@JsonSerializable()
class StitchMessage {
  final String role; // 'user', 'assistant', atau 'system'
  final String content;
  
  @JsonKey(includeIfNull: false)
  final String? name;
  
  @JsonKey(includeIfNull: false)
  final DateTime? timestamp;

  StitchMessage({
    required this.role,
    required this.content,
    this.name,
    this.timestamp,
  });

  factory StitchMessage.fromJson(Map<String, dynamic> json) =>
      _$StitchMessageFromJson(json);

  Map<String, dynamic> toJson() => _$StitchMessageToJson(this);

  /// Helper untuk membuat user message
  factory StitchMessage.user(String content) {
    return StitchMessage(
      role: 'user',
      content: content,
      timestamp: DateTime.now(),
    );
  }

  /// Helper untuk membuat assistant message
  factory StitchMessage.assistant(String content) {
    return StitchMessage(
      role: 'assistant',
      content: content,
      timestamp: DateTime.now(),
    );
  }

  /// Helper untuk membuat system message
  factory StitchMessage.system(String content) {
    return StitchMessage(
      role: 'system',
      content: content,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() => 'StitchMessage(role: $role, content: $content)';
}
