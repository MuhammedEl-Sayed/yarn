// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  name: json['name'] as String,
  createdBy: json['created_by'] as String,
  assignedTo: json['assigned_to'] as String?,
  icon: const IconDataConverter().fromJson(
    json['icon'] as Map<String, dynamic>?,
  ),
  imagePath: json['image_path'] as String?,
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'created_by': instance.createdBy,
  'assigned_to': instance.assignedTo,
  'icon': const IconDataConverter().toJson(instance.icon),
  'image_path': instance.imagePath,
};
