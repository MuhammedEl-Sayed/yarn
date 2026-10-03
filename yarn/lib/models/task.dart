import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yarn/consts/enums.dart';
import 'package:yarn/utils/task_utils.dart';

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

    /// 'once', 'day', 'week', 'month' or 'year'.
    required String repUnit,

    /// "Every N units". Null is treated as 1.
    int? every,

    /// Weekday codes ('M','T','W','TH','F','S','SU'), weekly only.
    @Default(<String>[]) List<String> repeatsOn,

    /// Day of month 1-31 (31 = last day), monthly only. Null = same day as
    /// the previous due date.
    int? monthlyOn,
    DateTime? lastCompleted,
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

  /// Null for one-time chores (and for unknown repeat units).
  DateTime? get nextDueDate {
    final unit = RepititionUnit.values.asNameMap()[repUnit];
    if (unit == null) return null;
    final base = (lastCompleted ?? DateTime.now()).toLocal();
    return TaskUtils().nextDueTime(unit, every, repeatsOn, monthlyOn, base);
  }
}
