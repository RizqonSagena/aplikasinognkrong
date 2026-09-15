import 'package:json_annotation/json_annotation.dart';

part 'favorite.g.dart';

@JsonSerializable()
class Favorite {
  final String id;
  final String userId;
  final String tongkronganId;
  final String tongkronganName;
  final String tongkronganImage;
  final double tongkronganRating;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.tongkronganId,
    required this.tongkronganName,
    required this.tongkronganImage,
    required this.tongkronganRating,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
