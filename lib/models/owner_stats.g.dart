// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerStats _$OwnerStatsFromJson(Map<String, dynamic> json) => OwnerStats(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      totalBookings: json['totalBookings'] as int,
      monthlyBookings: json['monthlyBookings'] as int,
      pendingReservations: json['pendingReservations'] as int,
      confirmedReservations: json['confirmedReservations'] as int,
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      totalTongkrongan: json['totalTongkrongan'] as int,
      activeTongkrongan: json['activeTongkrongan'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$OwnerStatsToJson(OwnerStats instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'monthlyRevenue': instance.monthlyRevenue,
      'totalBookings': instance.totalBookings,
      'monthlyBookings': instance.monthlyBookings,
      'pendingReservations': instance.pendingReservations,
      'confirmedReservations': instance.confirmedReservations,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'totalTongkrongan': instance.totalTongkrongan,
      'activeTongkrongan': instance.activeTongkrongan,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
