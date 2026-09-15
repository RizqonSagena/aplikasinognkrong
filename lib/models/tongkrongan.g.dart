// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tongkrongan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tongkrongan _$TongkronganFromJson(Map<String, dynamic> json) => Tongkrongan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      category: json['category'] as String,
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      openingTime: json['openingTime'] as String,
      closingTime: json['closingTime'] as String,
      isOpen: json['isOpen'] as bool,
      capacity: (json['capacity'] as num).toInt(),
      priceRange: json['priceRange'] as String,
      distance: (json['distance'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TongkronganToJson(Tongkrongan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
      'imageUrls': instance.imageUrls,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'category': instance.category,
      'amenities': instance.amenities,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
      'isOpen': instance.isOpen,
      'capacity': instance.capacity,
      'priceRange': instance.priceRange,
      'distance': instance.distance,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
