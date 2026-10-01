import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Task({
    required String id,
    required String title,
    String? roomId,
    @Default('once') String repeat,
    @Default(<String>[]) List<String> repeatsOn,
    String? assignedTo,
    @Default(3) int effort,
    @Default(false) bool isDone,
    String? createdBy,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
