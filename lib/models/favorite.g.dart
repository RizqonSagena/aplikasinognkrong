// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      id: json['id'] as String,
      userId: json['userId'] as String,
      tongkronganId: json['tongkronganId'] as String,
      tongkronganName: json['tongkronganName'] as String,
      tongkronganImage: json['tongkronganImage'] as String,
      tongkronganRating: (json['tongkronganRating'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tongkronganId': instance.tongkronganId,
      'tongkronganName': instance.tongkronganName,
      'tongkronganImage': instance.tongkronganImage,
      'tongkronganRating': instance.tongkronganRating,
      'createdAt': instance.createdAt.toIso8601String(),
    };
