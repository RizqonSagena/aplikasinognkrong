import 'package:json_annotation/json_annotation.dart';
import 'stitch_message.dart';

part 'stitch_response.g.dart';

/// Model untuk response dari Stitch AI API
@JsonSerializable(explicitToJson: true)
class StitchResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  
  final List<StitchChoice> choices;
  
  @JsonKey(includeIfNull: false)
  final StitchUsage? usage;
  
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? metadata;

  StitchResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    this.usage,
    this.metadata,
  });

  factory StitchResponse.fromJson(Map<String, dynamic> json) =>
      _$StitchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StitchResponseToJson(this);

  /// Helper untuk mendapatkan content dari response pertama
  String? get content {
    if (choices.isEmpty) return null;
    return choices.first.message.content;
  }

  /// Helper untuk mendapatkan finish reason
  String? get finishReason {
    if (choices.isEmpty) return null;
    return choices.first.finishReason;
  }

  @override
  String toString() => 'StitchResponse(id: $id, choices: ${choices.length})';
}

/// Model untuk choice dalam response
@JsonSerializable(explicitToJson: true)
class StitchChoice {
  final int index;
  final StitchMessage message;
  
  @JsonKey(name: 'finish_reason', includeIfNull: false)
  final String? finishReason;

  StitchChoice({
    required this.index,
    required this.message,
    this.finishReason,
  });

  factory StitchChoice.fromJson(Map<String, dynamic> json) =>
      _$StitchChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$StitchChoiceToJson(this);
}

/// Model untuk usage information
@JsonSerializable()
class StitchUsage {
  @JsonKey(name: 'prompt_tokens')
  final int promptTokens;
  
  @JsonKey(name: 'completion_tokens')
  final int completionTokens;
  
  @JsonKey(name: 'total_tokens')
  final int totalTokens;

  StitchUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory StitchUsage.fromJson(Map<String, dynamic> json) =>
      _$StitchUsageFromJson(json);

  Map<String, dynamic> toJson() => _$StitchUsageToJson(this);

  @override
  String toString() => 'StitchUsage(total: $totalTokens tokens)';
}
