import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Room({
    required String id,
    required String name,
    String? createdBy,

    /// Index into `roomColors` (lib/theme/room_palette.dart).
    int? colorIndex,

    /// Key into `roomIcons` (lib/theme/room_palette.dart).
    String? icon,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
