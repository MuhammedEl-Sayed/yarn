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

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime get _today => _dateOnly(DateTime.now());

/// Every screen decides what's due, done and upcoming from these getters, so
/// Today, Rooms and the room page always agree.
///
/// Only `lastCompleted` is stored, so for schedules pinned to days (weekly on
/// set weekdays, monthly on a set day) a completion counts toward whichever
/// scheduled day it's nearest. Doing Monday's chore on Saturday covers that
/// Monday, so it doesn't come back two days later. Doing it on Wednesday
/// covers the Monday you missed.
extension TaskX on Task {
  RepititionUnit? get _unit => RepititionUnit.values.asNameMap()[repUnit];

  bool get isDoneToday {
    final c = lastCompleted?.toLocal();
    return c != null && _dateOnly(c) == _today;
  }

  /// Weekly on set weekdays or monthly on a set day.
  bool get _isPinned =>
      (_unit == RepititionUnit.week && _weekdays.isNotEmpty) ||
      (_unit == RepititionUnit.month && monthlyOn != null);

  List<int> get _weekdays => repeatsOn
      .map((c) => TaskUtils.dayToInt[c.toUpperCase()])
      .whereType<int>()
      .toList();

  bool _isScheduledOn(DateTime day) {
    if (_unit == RepititionUnit.week) return _weekdays.contains(day.weekday);
    final lastDay = DateTime(day.year, day.month + 1, 0).day;
    return day.day == monthlyOn!.clamp(1, lastDay);
  }

  /// First scheduled day on or after [day], for pinned schedules.
  DateTime _scheduledOnOrAfter(DateTime day) {
    for (var i = 0; i < 62; i++) {
      final d = DateTime(day.year, day.month, day.day + i);
      if (_isScheduledOn(d)) return d;
    }
    return day;
  }

  /// Last scheduled day on or before [day], for pinned schedules.
  DateTime _scheduledOnOrBefore(DateTime day) {
    for (var i = 0; i < 62; i++) {
      final d = DateTime(day.year, day.month, day.day - i);
      if (_isScheduledOn(d)) return d;
    }
    return day;
  }

  /// The date this chore is next due, at midnight. Null once a one-time chore
  /// is done, and for unknown repeat units.
  DateTime? get dueDate {
    final unit = _unit;
    final completed = lastCompleted?.toLocal();

    if (repUnit == 'once') return completed == null ? _today : null;
    if (unit == null) return null;

    // Never done: due on its first scheduled day from today.
    if (completed == null) {
      return _isPinned ? _scheduledOnOrAfter(_today) : _today;
    }

    var base = _dateOnly(completed);
    if (_isPinned) {
      final before = _scheduledOnOrBefore(base);
      final after = _scheduledOnOrAfter(base.add(const Duration(days: 1)));
      // Done closer to the upcoming scheduled day than the last one: count it
      // as that upcoming day's.
      if (after.difference(base) < base.difference(before)) base = after;
    }
    return _dateOnly(
      TaskUtils().nextDueTime(unit, every, repeatsOn, monthlyOn, base),
    );
  }

  /// Done for its current cycle: done today, a one-time chore that's been
  /// done, or a repeating chore that isn't due again until after today.
  bool get isDone {
    if (lastCompleted == null) return false;
    if (isDoneToday) return true;
    final due = dueDate;
    return due == null || due.isAfter(_today);
  }

  /// Due today or overdue, and not done yet.
  bool get isDue {
    if (isDone) return false;
    final due = dueDate;
    return due != null && !due.isAfter(_today);
  }


  /// "Every 2 weeks · Mon, Thu", "Monthly on the 15th", "Once".
  String get repeatLabel {
    final n = (every == null || every! < 1) ? 1 : every!;
    String unitLabel(String single, String adverb) =>
        n == 1 ? adverb : 'Every $n ${single}s';

    switch (_unit) {
      case RepititionUnit.day:
        return unitLabel('day', 'Daily');
      case RepititionUnit.week:
        final base = unitLabel('week', 'Weekly');
        if (_weekdays.isEmpty) return base;
        final days = (_weekdays.toSet().toList()..sort())
            .map((d) => TaskUtils.shortDayNames[d - 1])
            .join(', ');
        return '$base · $days';
      case RepititionUnit.month:
        final base = unitLabel('month', 'Monthly');
        final day = monthlyOn;
        if (day == null) return base;
        return day >= 31 ? '$base on the last day' : '$base on the ${_ordinal(day)}';
      case RepititionUnit.year:
        return unitLabel('year', 'Yearly');
      case null:
        return repUnit == 'once' ? 'Once' : '';
    }
  }
}

String _ordinal(int n) {
  if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
  return switch (n % 10) {
    1 => '${n}st',
    2 => '${n}nd',
    3 => '${n}rd',
    _ => '${n}th',
  };
}
