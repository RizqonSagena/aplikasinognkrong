import 'package:json_annotation/json_annotation.dart';

part 'owner_tongkrongan.g.dart';

/// Model untuk Tongkrongan dari perspektif Owner
@JsonSerializable()
class OwnerTongkrongan {
  final String id;
  final String name;
  final String description;
  final String category;
  final String city;
  final double rating;
  final int reviewCount;
  final int totalBookings;
  final int monthlyBookings;
  final int activeReservations;
  final String status; // 'active', 'inactive', 'pending'
  final String imageUrl;
  final String address;
  final String phone;
  final String operatingHours;
  final int capacity;
  final double revenue; // Monthly revenue
  final DateTime createdAt;
  final DateTime updatedAt;

  OwnerTongkrongan({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.totalBookings,
    required this.monthlyBookings,
    required this.activeReservations,
    required this.status,
    required this.imageUrl,
    required this.address,
    required this.phone,
    required this.operatingHours,
    required this.capacity,
    required this.revenue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OwnerTongkrongan.fromJson(Map<String, dynamic> json) =>
      _$OwnerTongkronganFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerTongkronganToJson(this);
}
