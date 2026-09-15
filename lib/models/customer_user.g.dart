// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerUser _$CustomerUserFromJson(Map<String, dynamic> json) => CustomerUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String,
      bio: json['bio'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      totalBookings: (json['totalBookings'] as num).toInt(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      favoriteIds: (json['favoriteIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomerUserToJson(CustomerUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'totalBookings': instance.totalBookings,
      'totalReviews': instance.totalReviews,
      'averageRating': instance.averageRating,
      'favoriteIds': instance.favoriteIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
