// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  createdBy: json['created_by'] as String,
  name: json['name'] as String,
  isActive: json['is_active'] as bool,
  description: json['description'] as String?,
  repUnit: $enumDecode(_$RepititionUnitEnumMap, json['rep_unit']),
  every: (json['every'] as num?)?.toInt(),
  repeatsOn: (json['repeats_on'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  monthlyOn: (json['monthly_on'] as num).toInt(),
  lastCompleted: json['last_completed'] == null
      ? null
      : DateTime.parse(json['last_completed'] as String),
  lastUpdated: DateTime.parse(json['last_updated'] as String),
  assignedTo: (json['assigned_to'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  roomId: json['room_id'] as String?,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'created_by': instance.createdBy,
  'name': instance.name,
  'is_active': instance.isActive,
  'description': instance.description,
  'rep_unit': _$RepititionUnitEnumMap[instance.repUnit]!,
  'every': instance.every,
  'repeats_on': instance.repeatsOn,
  'monthly_on': instance.monthlyOn,
  'last_completed': instance.lastCompleted?.toIso8601String(),
  'last_updated': instance.lastUpdated.toIso8601String(),
  'assigned_to': instance.assignedTo,
  'room_id': instance.roomId,
};

const _$RepititionUnitEnumMap = {
  RepititionUnit.day: 'day',
  RepititionUnit.week: 'week',
  RepititionUnit.month: 'month',
  RepititionUnit.year: 'year',
};
