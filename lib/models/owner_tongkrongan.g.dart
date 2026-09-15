// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_tongkrongan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerTongkrongan _$OwnerTongkronganFromJson(Map<String, dynamic> json) =>
    OwnerTongkrongan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      totalBookings: json['totalBookings'] as int,
      monthlyBookings: json['monthlyBookings'] as int,
      activeReservations: json['activeReservations'] as int,
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      operatingHours: json['operatingHours'] as String,
      capacity: json['capacity'] as int,
      revenue: (json['revenue'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OwnerTongkronganToJson(OwnerTongkrongan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'city': instance.city,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'totalBookings': instance.totalBookings,
      'monthlyBookings': instance.monthlyBookings,
      'activeReservations': instance.activeReservations,
      'status': instance.status,
      'imageUrl': instance.imageUrl,
      'address': instance.address,
      'phone': instance.phone,
      'operatingHours': instance.operatingHours,
      'capacity': instance.capacity,
      'revenue': instance.revenue,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
