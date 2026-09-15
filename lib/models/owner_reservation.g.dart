// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerReservation _$OwnerReservationFromJson(Map<String, dynamic> json) =>
    OwnerReservation(
      id: json['id'] as String,
      tongkronganId: json['tongkronganId'] as String,
      tongkronganName: json['tongkronganName'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerEmail: json['customerEmail'] as String,
      guestCount: json['guestCount'] as int,
      reservationDate: DateTime.parse(json['reservationDate'] as String),
      timeSlot: json['timeSlot'] as String,
      specialRequest: json['specialRequest'] as String? ?? '',
      status: json['status'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: DateTime.parse(json['confirmedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$OwnerReservationToJson(OwnerReservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tongkronganId': instance.tongkronganId,
      'tongkronganName': instance.tongkronganName,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerEmail': instance.customerEmail,
      'guestCount': instance.guestCount,
      'reservationDate': instance.reservationDate.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'specialRequest': instance.specialRequest,
      'status': instance.status,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
    };
