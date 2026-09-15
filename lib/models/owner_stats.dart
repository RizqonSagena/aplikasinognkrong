import 'package:json_annotation/json_annotation.dart';

part 'owner_stats.g.dart';

/// Model untuk Statistik Owner
@JsonSerializable()
class OwnerStats {
  final double totalRevenue;
  final double monthlyRevenue;
  final int totalBookings;
  final int monthlyBookings;
  final int pendingReservations;
  final int confirmedReservations;
  final double averageRating;
  final int totalReviews;
  final int totalTongkrongan;
  final int activeTongkrongan;
  final DateTime lastUpdated;

  OwnerStats({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.totalBookings,
    required this.monthlyBookings,
    required this.pendingReservations,
    required this.confirmedReservations,
    required this.averageRating,
    required this.totalReviews,
    required this.totalTongkrongan,
    required this.activeTongkrongan,
    required this.lastUpdated,
  });

  factory OwnerStats.fromJson(Map<String, dynamic> json) =>
      _$OwnerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerStatsToJson(this);
}
