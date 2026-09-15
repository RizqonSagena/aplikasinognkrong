import 'package:json_annotation/json_annotation.dart';

part 'customer_user.g.dart';

@JsonSerializable()
class CustomerUser {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String avatar;
  final String bio;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final int totalBookings;
  final int totalReviews;
  final double averageRating;
  final List<String> favoriteIds; // List of favorite tongkrongan IDs
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.avatar,
    required this.bio,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.totalBookings,
    required this.totalReviews,
    required this.averageRating,
    required this.favoriteIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerUser.fromJson(Map<String, dynamic> json) =>
      _$CustomerUserFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerUserToJson(this);

  // Helper untuk check apakah tongkrongan favorit
  bool isFavorite(String tongkronganId) => favoriteIds.contains(tongkronganId);
}
