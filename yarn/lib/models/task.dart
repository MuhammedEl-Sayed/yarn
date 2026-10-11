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

  bool get isDueToday {
    if (isDoneToday) return true;
    if (repUnit == 'once') return lastCompleted == null;
    if (lastCompleted == null) return _isDueFirstTime;

    final next = nextDueDate;
    if (next == null) return true; // unknown unit: don't hide it
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    // Compare dates, not times, so chores show all day rather than from 7am.
    return !DateTime(next.year, next.month, next.day).isAfter(today);
  }

  bool get _isDueFirstTime {
    final now = DateTime.now();
    switch (repUnit) {
      case 'week':
        return repeatsOn.isEmpty ||
            repeatsOn.any(
              (c) => TaskUtils.dayToInt[c.toUpperCase()] == now.weekday,
            );
      case 'month':
        final lastDay = DateTime(now.year, now.month + 1, 0).day;
        final want = (monthlyOn ?? now.day).clamp(1, lastDay).toInt();
        return now.day >= want;
      default:
        return true; // day, year
    }
  }

  bool get isCompletedThisCycle {
    if (lastCompleted == null || repUnit == 'once') return false;
    final next = nextDueDate;
    if (next == null) return false;
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    return DateTime(next.year, next.month, next.day).isAfter(today);
  }
}
