import 'package:json_annotation/json_annotation.dart';

part 'stitch_error.g.dart';

/// Model untuk error response dari Stitch AI API
@JsonSerializable()
class StitchError {
  final String message;
  final String type;
  
  @JsonKey(includeIfNull: false)
  final String? code;
  
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? details;

  StitchError({
    required this.message,
    required this.type,
    this.code,
    this.details,
  });

  factory StitchError.fromJson(Map<String, dynamic> json) =>
      _$StitchErrorFromJson(json);

  Map<String, dynamic> toJson() => _$StitchErrorToJson(this);

  @override
  String toString() => 'StitchError(type: $type, message: $message)';
}

/// Exception class untuk Stitch AI errors
class StitchException implements Exception {
  final String message;
  final int? statusCode;
  final StitchError? error;

  StitchException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() {
    if (error != null) {
      return 'StitchException: ${error!.message} (${error!.type})';
    }
    return 'StitchException: $message ${statusCode != null ? "(Status: $statusCode)" : ""}';
  }
}
