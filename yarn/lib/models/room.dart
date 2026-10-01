import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'icon_data_converter.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Room({
    required String id,
    required String name,
    required String createdBy,
    String? assignedTo,
    @IconDataConverter() IconData? icon,
    String? imagePath,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
