import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yarn/theme/app_colors.dart';

class AppText {
  /// Serif heading face ("Today's chores").
  static TextStyle display(double size) => GoogleFonts.fraunces(
    fontSize: size,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    height: 1.1,
  );

  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.ink,
  }) => GoogleFonts.nunito(fontSize: size, fontWeight: weight, color: color);
}
