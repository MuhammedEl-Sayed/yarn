import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);

    final textTheme = GoogleFonts.nunitoTextTheme(base.textTheme)
        .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink)
        .copyWith(
          displayLarge: AppText.display(40),
          displayMedium: AppText.display(34),
          displaySmall: AppText.display(30),
          headlineLarge: AppText.display(32),
          headlineMedium: AppText.display(26),
          headlineSmall: AppText.display(22),
        );

    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.accent)
        .copyWith(
          primary: AppColors.accent,
          onPrimary: Colors.white,
          secondary: AppColors.gold,
          surface: AppColors.cream,
          onSurface: AppColors.ink,
          outline: AppColors.line,
        );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppText.display(22),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cream,
        modalBackgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 4,
        extendedTextStyle: AppText.body(16, weight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: AppText.body(17, weight: FontWeight.w800),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.accent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(
          AppText.body(12, weight: FontWeight.w800),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: AppColors.gold,
        inactiveTrackColor: AppColors.line.withValues(alpha: 0.6),
        thumbColor: AppColors.gold,
        overlayColor: AppColors.gold.withValues(alpha: 0.15),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.accent,
      ),
    );
  }
}
