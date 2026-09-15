import 'package:flutter/material.dart';

/// Color tokens dari Stitch AI design - Tongkrongan Admin Portal
/// Material 3 color system dengan warm terracotta palette
class AdminColors {
  AdminColors._();

  // Primary - Warm Terracotta/Burnt Orange
  static const Color primary = Color(0xFFa33900);
  static const Color onPrimary = Color(0xFFffffff);
  static const Color primaryContainer = Color(0xFFca4b07);
  static const Color onPrimaryContainer = Color(0xFFfffbff);
  static const Color primaryFixed = Color(0xFFffdbce);
  static const Color primaryFixedDim = Color(0xFFffb599);
  static const Color onPrimaryFixed = Color(0xFF370e00);
  static const Color onPrimaryFixedVariant = Color(0xFF7f2b00);
  static const Color inversePrimary = Color(0xFFffb599);
  static const Color surfaceTint = Color(0xFFa73a00);

  // Secondary - Warm Amber/Gold
  static const Color secondary = Color(0xFF875200);
  static const Color onSecondary = Color(0xFFffffff);
  static const Color secondaryContainer = Color(0xFFfdb257);
  static const Color onSecondaryContainer = Color(0xFF724400);
  static const Color secondaryFixed = Color(0xFFffddba);
  static const Color secondaryFixedDim = Color(0xFFffb866);
  static const Color onSecondaryFixed = Color(0xFF2b1700);
  static const Color onSecondaryFixedVariant = Color(0xFF673d00);

  // Tertiary - Teal/Green
  static const Color tertiary = Color(0xFF006857);
  static const Color onTertiary = Color(0xFFffffff);
  static const Color tertiaryContainer = Color(0xFF28826f);
  static const Color onTertiaryContainer = Color(0xFFf4fffa);
  static const Color tertiaryFixed = Color(0xFF9df3db);
  static const Color tertiaryFixedDim = Color(0xFF81d6c0);
  static const Color onTertiaryFixed = Color(0xFF002019);
  static const Color onTertiaryFixedVariant = Color(0xFF005143);

  // Error
  static const Color error = Color(0xFFba1a1a);
  static const Color onError = Color(0xFFffffff);
  static const Color errorContainer = Color(0xFFffdad6);
  static const Color onErrorContainer = Color(0xFF93000a);

  // Surface - LIGHT THEME
  static const Color surface = Color(0xFFFAF8F3);
  static const Color surfaceBright = Color(0xFFFAF8F3);
  static const Color surfaceDim = Color(0xFFE8E4DB);
  static const Color surfaceVariant = Color(0xFFF0EDE4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFCF9F0);
  static const Color surfaceContainer = Color(0xFFF5F1E8);
  static const Color surfaceContainerHigh = Color(0xFFEEEAE1);
  static const Color surfaceContainerHighest = Color(0xFFE8E4DB);
  static const Color onSurface = Color(0xFF2B2520);
  static const Color onSurfaceVariant = Color(0xFF594139);
  static const Color inverseSurface = Color(0xFF303036);
  static const Color inverseOnSurface = Color(0xFFf2eff8);

  // Outline
  static const Color outline = Color(0xFF8d7167);
  static const Color outlineVariant = Color(0xFFe1bfb4);

  // Background - LIGHT CREAM
  static const Color background = Color(0xFFFAF8F3);
  static const Color onBackground = Color(0xFF2B2520);

  /// ThemeData untuk Admin Portal
  static ThemeData get theme => ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    ),
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    scaffoldBackgroundColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceContainerLowest,
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
    ),
  );
}
