import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final String id;
  final String userId;
  final String tongkronganId;
  final String tongkronganName;
  final DateTime bookingDate;
  final String bookingTime; // "14:00"
  final int numberOfPeople;
  final String notes;
  final String status; // pending, confirmed, completed, cancelled
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.tongkronganId,
    required this.tongkronganName,
    required this.bookingDate,
    required this.bookingTime,
    required this.numberOfPeople,
    required this.notes,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);

  // Helper untuk menampilkan status
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Terkonfirmasi';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  // Helper untuk warna status
  int get statusColor {
    switch (status) {
      case 'pending':
        return 0xFFFFA500; // Orange
      case 'confirmed':
        return 0xFF4CAF50; // Green
      case 'completed':
        return 0xFF2196F3; // Blue
      case 'cancelled':
        return 0xFFF44336; // Red
      default:
        return 0xFF9E9E9E; // Gray
    }
  }
}
