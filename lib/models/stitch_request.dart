import 'package:json_annotation/json_annotation.dart';
import 'stitch_message.dart';

part 'stitch_request.g.dart';

/// Model untuk request ke Stitch AI API
@JsonSerializable(explicitToJson: true)
class StitchRequest {
  @JsonKey(name: 'agent_id')
  final String agentId;
  
  final List<StitchMessage> messages;
  
  @JsonKey(includeIfNull: false)
  final bool? stream;
  
  @JsonKey(includeIfNull: false)
  final double? temperature;
  
  @JsonKey(name: 'max_tokens', includeIfNull: false)
  final int? maxTokens;
  
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? metadata;

  StitchRequest({
    required this.agentId,
    required this.messages,
    this.stream = false,
    this.temperature,
    this.maxTokens,
    this.metadata,
  });

  factory StitchRequest.fromJson(Map<String, dynamic> json) =>
      _$StitchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StitchRequestToJson(this);

  /// Helper untuk membuat request sederhana dengan satu user message
  factory StitchRequest.simple({
    required String agentId,
    required String userMessage,
    bool stream = false,
  }) {
    return StitchRequest(
      agentId: agentId,
      messages: [StitchMessage.user(userMessage)],
      stream: stream,
    );
  }

  @override
  String toString() => 'StitchRequest(agentId: $agentId, messages: ${messages.length})';
}
