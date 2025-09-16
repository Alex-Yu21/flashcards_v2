import 'package:flutter/material.dart';

class AppColors {
  static const seed = Color.fromARGB(255, 35, 12, 138);

  static const _bgLight = Color.fromARGB(255, 240, 240, 242);
  static const _mutedLight = Color.fromARGB(255, 149, 149, 170);
  static const _cardLight = Colors.white;

  static const _bgDark = Color(0xFF11131A);
  static const _mutedDark = Color(0xFFB0B3C0);
  static const _cardDark = Color(0xFF1B1E27);

  static ColorScheme apply(
    ColorScheme base, {
    required Brightness brightness,
    String? custom,
  }) {
    switch (custom) {
      case 'rose':
        return _rose(base, brightness);
      case 'forest':
        return _forest(base, brightness);
      case 'ocean':
        return _ocean(base, brightness);
      default:
        return _system(base, brightness);
    }
  }

  static ColorScheme _system(ColorScheme base, Brightness b) {
    final isDark = b == Brightness.dark;
    return base.copyWith(
      surface: isDark ? _bgDark : _bgLight,
      onSurfaceVariant: isDark ? _mutedDark : _mutedLight,
      surfaceContainerLowest: isDark ? _cardDark : _cardLight,
      surfaceContainerLow: isDark ? _cardDark : _cardLight,
    );
  }

  static ColorScheme _rose(ColorScheme base, Brightness b) {
    final isDark = b == Brightness.dark;
    return base.copyWith(
      // primary: isDark ? _rosePrimaryDark : _rosePrimaryLight,
      // secondary: isDark ? _roseSecondaryDark : _roseSecondaryLight,
      // surface: isDark ? _bgDark : _bgLight,
      // surfaceContainerLowest: isDark ? _cardDark : _cardLight,
      // onSurfaceVariant: isDark ? _mutedDark : _mutedLight,
    );
  }

  static ColorScheme _forest(ColorScheme base, Brightness b) {
    final isDark = b == Brightness.dark;
    return base.copyWith(
      // primary: isDark ? _forestPrimaryDark : _forestPrimaryLight,
      // secondary: isDark ? _forestSecondaryDark : _forestSecondaryLight,
      // surface: isDark ? _bgDark : _bgLight,
      // surfaceContainerLowest: isDark ? _cardDark : _cardLight,
      // onSurfaceVariant: isDark ? _mutedDark : _mutedLight,
    );
  }

  static ColorScheme _ocean(ColorScheme base, Brightness b) {
    final isDark = b == Brightness.dark;
    return base.copyWith(
      // primary: isDark ? _oceanPrimaryDark : _oceanPrimaryLight,
      // secondary: isDark ? _oceanSecondaryDark : _oceanSecondaryLight,
      // surface: isDark ? _bgDark : _bgLight,
      // surfaceContainerLowest: isDark ? _cardDark : _cardLight,
      // onSurfaceVariant: isDark ? _mutedDark : _mutedLight,
    );
  }
}
