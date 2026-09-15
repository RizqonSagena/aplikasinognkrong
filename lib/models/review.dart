import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final String id;
  final String tongkronganId;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String title;
  final String comment;
  final List<String> imageUrls;
  final int likes;
  final bool isLikedByUser;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.tongkronganId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.title,
    required this.comment,
    required this.imageUrls,
    required this.likes,
    required this.isLikedByUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
