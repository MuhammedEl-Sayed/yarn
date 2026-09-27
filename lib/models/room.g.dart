// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: const IconDataConverter().fromJson(
    json['icon'] as Map<String, dynamic>?,
  ),
  imagePath: json['imagePath'] as String?,
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': const IconDataConverter().toJson(instance.icon),
  'imagePath': instance.imagePath,
};
