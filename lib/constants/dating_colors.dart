// theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatingColors {
  static const Color primaryGreen = Color(0xFFB2D12E);
  static const Color darkGreen = Color(0xFF92AB26);
  static const Color lightpink = Color(0xFFEB507F);
  static const Color accentTeal = Color(0xFF00BCD4);
  static const Color black = Color(0xFF000000);

  // Background Colors
  static const Color lightBlue = Color(0xFFE8F4FD);
  static const Color lightGreen = Color(0xFFE8F5E8);
  static const Color white = Color(0xFFFAFAFA);

  static const Color brown = Color(0xFF483737);

  // Status Colors
  static const Color successGreen = Color(0xFF34A853);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFDC3545);

  // Text Colors
  static const Color primaryText = Color(0xFF2C3E50);
  static const Color secondaryText = Color(0xFF6C757D);
  static const Color lightText = Color(0xFF95A5A6);

  // Card and Surface Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF8F9FA);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkSecondaryText = Color(0xFFB0B0B0);
}

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  void toggleTheme() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state);
  }

  void setTheme(bool isDark) async {
    state = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(
      0xFFB2D12E,
      <int, Color>{
        50: DatingColors.primaryGreen.withOpacity(0.1),
        100: DatingColors.primaryGreen.withOpacity(0.2),
        200: DatingColors.primaryGreen.withOpacity(0.3),
        300: DatingColors.primaryGreen.withOpacity(0.4),
        400: DatingColors.primaryGreen.withOpacity(0.5),
        500: DatingColors.primaryGreen,
        600: DatingColors.primaryGreen.withOpacity(0.7),
        700: DatingColors.primaryGreen.withOpacity(0.8),
        800: DatingColors.primaryGreen.withOpacity(0.9),
        900: DatingColors.darkGreen,
      },
    ),
    scaffoldBackgroundColor: DatingColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: DatingColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DatingColors.primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: DatingColors.primaryText),
      headlineMedium: TextStyle(color: DatingColors.primaryText),
      headlineSmall: TextStyle(color: DatingColors.primaryText),
      bodyLarge: TextStyle(color: DatingColors.primaryText),
      bodyMedium: TextStyle(color: DatingColors.secondaryText),
      bodySmall: TextStyle(color: DatingColors.lightText),
    ),
    colorScheme: const ColorScheme.light(
      primary: DatingColors.primaryGreen,
      secondary: DatingColors.lightpink,
      surface: DatingColors.cardBackground,
      background: DatingColors.white,
      error: DatingColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: DatingColors.primaryText,
      onBackground: DatingColors.primaryText,
      onError: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(
      0xFFB2D12E,
      <int, Color>{
        50: DatingColors.primaryGreen.withOpacity(0.1),
        100: DatingColors.primaryGreen.withOpacity(0.2),
        200: DatingColors.primaryGreen.withOpacity(0.3),
        300: DatingColors.primaryGreen.withOpacity(0.4),
        400: DatingColors.primaryGreen.withOpacity(0.5),
        500: DatingColors.primaryGreen,
        600: DatingColors.primaryGreen.withOpacity(0.7),
        700: DatingColors.primaryGreen.withOpacity(0.8),
        800: DatingColors.primaryGreen.withOpacity(0.9),
        900: DatingColors.darkGreen,
      },
    ),
    scaffoldBackgroundColor: DatingColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: DatingColors.darkSurface,
      foregroundColor: DatingColors.darkText,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DatingColors.primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: DatingColors.darkText),
      headlineMedium: TextStyle(color: DatingColors.darkText),
      headlineSmall: TextStyle(color: DatingColors.darkText),
      bodyLarge: TextStyle(color: DatingColors.darkText),
      bodyMedium: TextStyle(color: DatingColors.darkSecondaryText),
      bodySmall: TextStyle(color: DatingColors.lightText),
    ),
    colorScheme: const ColorScheme.dark(
      primary: DatingColors.primaryGreen,
      secondary: DatingColors.lightpink,
      surface: DatingColors.darkCard,
      background: DatingColors.darkBackground,
      error: DatingColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: DatingColors.darkText,
      onBackground: DatingColors.darkText,
      onError: Colors.white,
    ),
  );
}