import 'package:json_annotation/json_annotation.dart';

part 'tongkrongan.g.dart';

@JsonSerializable()
class Tongkrongan {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final String category; // coffee, food, bar, etc
  final List<String> amenities; // wifi, parking, ac, dll
  final String openingTime; // "09:00"
  final String closingTime; // "22:00"
  final bool isOpen;
  final int capacity;
  final String priceRange; // "$", "$$", "$$$"
  final double distance; // in km
  final DateTime createdAt;
  final DateTime updatedAt;

  Tongkrongan({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.imageUrls,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.amenities,
    required this.openingTime,
    required this.closingTime,
    required this.isOpen,
    required this.capacity,
    required this.priceRange,
    required this.distance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tongkrongan.fromJson(Map<String, dynamic> json) =>
      _$TongkronganFromJson(json);

  Map<String, dynamic> toJson() => _$TongkronganToJson(this);

  // Helper untuk menampilkan jam operasional
  String get operatingHours => '$openingTime - $closingTime';

  // Helper untuk rating display
  String get ratingDisplay => rating.toStringAsFixed(1);
}
