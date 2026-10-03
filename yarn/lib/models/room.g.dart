// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  name: json['name'] as String,
  createdBy: json['created_by'] as String?,
  colorIndex: (json['color_index'] as num?)?.toInt(),
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'created_by': instance.createdBy,
  'color_index': instance.colorIndex,
  'icon': instance.icon,
};
