import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Task({
    required String id,
    required String createdBy,
    required String name,
    @Default(true) bool isActive,
    String? description,
    required String repUnit,
    int? every,
    @Default(<String>[]) List<String> repeatsOn,
    @Default(1) int monthlyOn,
    DateTime? lastCompleted,
    required DateTime lastUpdated,
    @Default(<String>[]) List<String> assignedTo,
    String? roomId,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

extension TaskX on Task {
  /// There is no is_done column, so "done" means completed today.
  bool get isDoneToday {
    final c = lastCompleted?.toLocal();
    if (c == null) return false;
    final n = DateTime.now();
    return c.year == n.year && c.month == n.month && c.day == n.day;
  }
}
