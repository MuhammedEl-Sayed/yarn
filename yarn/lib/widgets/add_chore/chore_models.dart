import 'package:flutter/material.dart';

/// Names match the stored `repUnit` strings and `RepititionUnit`.
/// `once` is stored as 'once' and never gets a next due date.
enum Repeat { once, day, week, month, year }

class RoomOption {
  final String id;
  final String label;
  final Color color;

  const RoomOption({
    required this.id,
    required this.label,
    required this.color,
  });
}

class PersonOption {
  final String id;
  final String initial;
  final Color color;

  const PersonOption({
    required this.id,
    required this.initial,
    required this.color,
  });
}

class ChoreDraft {
  /// Null when creating, the task id when editing.
  final String? id;
  final String title;
  final String? roomId;
  final Repeat repeat;

  /// "Every N days/weeks/months/years".
  final int every;

  /// Weekday codes ('M','T','W','TH','F','S','SU'); only for weekly.
  final List<String> repeatsOn;

  /// Day of month 1-31 (31 = last day); only for monthly.
  final int? monthlyOn;
  final String? assignedTo;

  const ChoreDraft({
    this.id,
    required this.title,
    required this.roomId,
    required this.repeat,
    this.every = 1,
    this.repeatsOn = const [],
    this.monthlyOn,
    required this.assignedTo,
  });
}
