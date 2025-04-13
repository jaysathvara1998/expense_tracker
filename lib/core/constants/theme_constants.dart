// lib/core/constants/theme_constants.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConstants {
  // Light Theme Colors
  static const Color lightPrimaryColor = Color(0xFF6200EE);
  static const Color lightPrimaryVariantColor = Color(0xFF3700B3);
  static const Color lightSecondaryColor = Color(0xFF03DAC6);
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color lightErrorColor = Color(0xFFB00020);
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightOnPrimaryColor = Color(0xFFFFFFFF);
  static const Color lightOnSecondaryColor = Color(0xFF000000);
  static const Color lightOnBackgroundColor = Color(0xFF000000);
  static const Color lightOnSurfaceColor = Color(0xFF000000);
  static const Color lightOnErrorColor = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFFBB86FC);
  static const Color darkPrimaryVariantColor = Color(0xFF3700B3);
  static const Color darkSecondaryColor = Color(0xFF03DAC6);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkErrorColor = Color(0xFFCF6679);
  static const Color darkSurfaceColor = Color(0xFF121212);
  static const Color darkOnPrimaryColor = Color(0xFF000000);
  static const Color darkOnSecondaryColor = Color(0xFF000000);
  static const Color darkOnBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceColor = Color(0xFFFFFFFF);
  static const Color darkOnErrorColor = Color(0xFF000000);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    colorScheme: const ColorScheme.light(
      primary: lightPrimaryColor,
      primaryContainer: lightPrimaryVariantColor,
      secondary: lightSecondaryColor,
      error: lightErrorColor,
      surface: lightSurfaceColor,
      onPrimary: lightOnPrimaryColor,
      onSecondary: lightOnSecondaryColor,
      onSurface: lightOnSurfaceColor,
      onError: lightOnErrorColor,
    ),
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: lightPrimaryColor,
      foregroundColor: lightOnPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightOnPrimaryColor,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightPrimaryColor.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightPrimaryColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightErrorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: lightOnPrimaryColor,
        backgroundColor: lightPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightOnPrimaryColor,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: lightPrimaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightPrimaryColor,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: lightSurfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightPrimaryColor,
      foregroundColor: lightOnPrimaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightSurfaceColor,
      selectedItemColor: lightPrimaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 0.5,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      primaryContainer: darkPrimaryVariantColor,
      secondary: darkSecondaryColor,
      background: darkBackgroundColor,
      error: darkErrorColor,
      surface: darkSurfaceColor,
      onPrimary: darkOnPrimaryColor,
      onSecondary: darkOnSecondaryColor,
      onBackground: darkOnBackgroundColor,
      onSurface: darkOnSurfaceColor,
      onError: darkOnErrorColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkOnSurfaceColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkOnSurfaceColor,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkPrimaryColor.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkPrimaryColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkErrorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      fillColor: Colors.grey[800],
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: darkOnPrimaryColor,
        backgroundColor: darkPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkOnPrimaryColor,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: darkPrimaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkPrimaryColor,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryColor,
      foregroundColor: darkOnPrimaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      selectedItemColor: darkPrimaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 0.5,
    ),
  );
}
