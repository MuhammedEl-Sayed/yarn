import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yarn/consts/enums.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Task({
    required String id,
    required String createdBy,
    required String name,
    required bool isActive,
    String? description,
    required RepititionUnit repUnit,

    // Every how many, i.e every two weeks
    int? every,

    // Repeats on what days in the week
    List<String>? repeatsOn,

    // Monthly on
    required int monthlyOn,

    DateTime? lastCompleted,
    required DateTime lastUpdated,

    List<String>? assignedTo,
    String? roomId,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
