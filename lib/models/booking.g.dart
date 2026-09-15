// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      tongkronganId: json['tongkronganId'] as String,
      tongkronganName: json['tongkronganName'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      bookingTime: json['bookingTime'] as String,
      numberOfPeople: (json['numberOfPeople'] as num).toInt(),
      notes: json['notes'] as String,
      status: json['status'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tongkronganId': instance.tongkronganId,
      'tongkronganName': instance.tongkronganName,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'bookingTime': instance.bookingTime,
      'numberOfPeople': instance.numberOfPeople,
      'notes': instance.notes,
      'status': instance.status,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
