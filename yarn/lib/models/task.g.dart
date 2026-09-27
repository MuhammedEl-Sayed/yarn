// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  createdBy: json['createdBy'] as String,
  name: json['name'] as String,
  isActive: json['isActive'] as bool,
  description: json['description'] as String?,
  repUnit: $enumDecode(_$RepititionUnitEnumMap, json['repUnit']),
  every: (json['every'] as num?)?.toInt(),
  repeatsOn: (json['repeatsOn'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  monthlyOn: (json['monthlyOn'] as num).toInt(),
  lastCompleted: json['lastCompleted'] == null
      ? null
      : DateTime.parse(json['lastCompleted'] as String),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  assignedTo: (json['assignedTo'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  roomId: json['roomId'] as String?,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'createdBy': instance.createdBy,
  'name': instance.name,
  'isActive': instance.isActive,
  'description': instance.description,
  'repUnit': _$RepititionUnitEnumMap[instance.repUnit]!,
  'every': instance.every,
  'repeatsOn': instance.repeatsOn,
  'monthlyOn': instance.monthlyOn,
  'lastCompleted': instance.lastCompleted?.toIso8601String(),
  'lastUpdated': instance.lastUpdated.toIso8601String(),
  'assignedTo': instance.assignedTo,
  'roomId': instance.roomId,
};

const _$RepititionUnitEnumMap = {
  RepititionUnit.day: 'day',
  RepititionUnit.week: 'week',
  RepititionUnit.month: 'month',
};
