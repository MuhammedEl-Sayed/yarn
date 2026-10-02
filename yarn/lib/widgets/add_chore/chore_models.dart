import 'package:flutter/material.dart';

enum Repeat { once, daily, weekly, custom }

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
  final String title;
  final String? roomId;
  final Repeat repeat;
  final List<String> repeatsOn;
  final String? assignedTo;

  const ChoreDraft({
    required this.title,
    required this.roomId,
    required this.repeat,
    required this.repeatsOn,
    required this.assignedTo,
  });
}
