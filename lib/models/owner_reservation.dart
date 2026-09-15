import 'package:json_annotation/json_annotation.dart';

part 'owner_reservation.g.dart';

/// Model untuk Reservasi dari perspektif Owner
@JsonSerializable()
class OwnerReservation {
  final String id;
  final String tongkronganId;
  final String tongkronganName;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final int guestCount;
  final DateTime reservationDate;
  final String timeSlot;
  final String specialRequest;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final double totalPrice;
  final DateTime createdAt;
  final DateTime confirmedAt;
  final DateTime completedAt;

  OwnerReservation({
    required this.id,
    required this.tongkronganId,
    required this.tongkronganName,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.guestCount,
    required this.reservationDate,
    required this.timeSlot,
    required this.specialRequest,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.confirmedAt,
    required this.completedAt,
  });

  factory OwnerReservation.fromJson(Map<String, dynamic> json) =>
      _$OwnerReservationFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerReservationToJson(this);
}
