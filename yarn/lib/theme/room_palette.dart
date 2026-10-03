import 'package:flutter/material.dart';

/// Yarn colors a room can use. A room stores its index into this list.
const roomColors = [
  Color(0xFFE5A58E), // terracotta
  Color(0xFFB9C7AE), // sage
  Color(0xFFEBCB8B), // gold
  Color(0xFF7C9CC4), // blue
  Color(0xFFC9A0B8), // plum
];

/// Icons a room can use. A room stores the key.
const roomIcons = <String, IconData>{
  'bath': Icons.bathtub_outlined,
  'bed': Icons.bed_outlined,
  'kitchen': Icons.kitchen_outlined,
  'laundry': Icons.local_laundry_service_outlined,
  'living': Icons.weekend_outlined,
  'pets': Icons.pets,
  'outside': Icons.yard_outlined,
};

/// [stored] is Room.colorIndex; [fallback] is the room's list position, used
/// for rooms created before colors were saved.
Color roomColorAt(int? stored, int fallback) =>
    roomColors[(stored ?? fallback) % roomColors.length];

IconData roomIconFor(String? key) => roomIcons[key] ?? Icons.home_outlined;
