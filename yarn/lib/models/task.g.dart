// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  title: json['title'] as String,
  roomId: json['room_id'] as String?,
  repeat: json['repeat'] as String? ?? 'once',
  repeatsOn:
      (json['repeats_on'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  assignedTo: json['assigned_to'] as String?,
  effort: (json['effort'] as num?)?.toInt() ?? 3,
  isDone: json['is_done'] as bool? ?? false,
  createdBy: json['created_by'] as String?,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'room_id': instance.roomId,
  'repeat': instance.repeat,
  'repeats_on': instance.repeatsOn,
  'assigned_to': instance.assignedTo,
  'effort': instance.effort,
  'is_done': instance.isDone,
  'created_by': instance.createdBy,
};
