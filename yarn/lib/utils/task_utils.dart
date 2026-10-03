import 'package:yarn/consts/enums.dart';

class TaskUtils {
  /// Weekday code -> DateTime.weekday (Mon = 1 ... Sun = 7).
  static const Map<String, int> dayToInt = {
    'M': 1,
    'T': 2,
    'W': 3,
    'TH': 4,
    'F': 5,
    'S': 6,
    'SU': 7,
  };

  /// Every chore is due at this hour.
  static const int dueHour = 7;

  /// Adds calendar days (DST-safe), landing at [dueHour].
  static DateTime _addDays(DateTime d, int days) =>
      DateTime(d.year, d.month, d.day + days, dueHour);

  /// Adds months, clamping the day to the target month's length
  /// (so day 31 means "last day"), landing at [dueHour].
  static DateTime _addMonths(DateTime d, int months, {int? day}) {
    final target = DateTime(d.year, d.month + months);
    final lastDay = DateTime(target.year, target.month + 1, 0).day;
    final wanted = day ?? d.day;
    return DateTime(
      target.year,
      target.month,
      wanted > lastDay ? lastDay : wanted,
      dueHour,
    );
  }

  DateTime nextDueTime(
    RepititionUnit rep,
    int? repeatsEvery,
    List<String>? repeatsOn,
    int? monthlyOn,
    DateTime previousDate,
  ) {
    final interval = (repeatsEvery == null || repeatsEvery < 1)
        ? 1
        : repeatsEvery;

    switch (rep) {
      case RepititionUnit.day:
        return _addDays(previousDate, interval);

      case RepititionUnit.week:
        if (repeatsOn == null || repeatsOn.isEmpty) {
          return _addDays(previousDate, 7 * interval);
        }
        final days =
            repeatsOn
                .map((d) => dayToInt[d.toUpperCase()])
                .whereType<int>()
                .toList()
              ..sort();
        if (days.isEmpty) {
          return _addDays(previousDate, 7 * interval);
        }
        final curr = previousDate.weekday;
        for (final d in days) {
          if (d > curr) return _addDays(previousDate, d - curr);
        }
        // Wrap to the first selected day, `interval` weeks ahead.
        return _addDays(previousDate, 7 * interval - curr + days.first);

      case RepititionUnit.month:
        return _addMonths(previousDate, interval, day: monthlyOn);

      case RepititionUnit.year:
        return _addMonths(previousDate, 12 * interval);
    }
  }
}
