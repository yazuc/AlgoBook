import 'package:flutter/material.dart';

// VS Code Dark Theme Colors
const vscodeDarkBackground = Color(0xFF1E1E1E);
const vscodeDarkPrimary = Color(0xFF608B4E);
const vscodeDarkSecondary = Color(0xFF4EC9B0);
const vscodeDarkAccent = Color(0xFFC586C0);

// VS Code Light Theme Colors
const vscodeLightBackground = Color(0xFFFFFFFF);
const vscodeLightPrimary = Color(0xFF007ACC);
const vscodeLightSecondary = Color(0xFF333333);
const vscodeLightAccent = Color(0xFF6A372D);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: vscodeDarkPrimary,
  colorScheme: const ColorScheme.dark(
    primary: vscodeDarkPrimary,
    secondary: vscodeDarkSecondary,
    background: vscodeDarkBackground,
    surface: Color(0xFF252526),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: vscodeDarkBackground,
  canvasColor: const Color(0xFF252526), // Sidebar, etc.
  cardColor: const Color(0xFF2D2D2D),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF333333),
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  buttonTheme: const ButtonThemeData(
    buttonColor: vscodeDarkPrimary,
    textTheme: ButtonTextTheme.primary,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: const TextStyle(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: vscodeDarkPrimary),
      ),
    ),
  ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: vscodeLightPrimary,
  colorScheme: const ColorScheme.light(
    primary: vscodeLightPrimary,
    secondary: vscodeLightSecondary,
    background: vscodeLightBackground,
    surface: Color(0xFFF3F3F3),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: vscodeLightBackground,
  canvasColor: const Color(0xFFF3F3F3), // Sidebar, etc.
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF3F3F3),
    foregroundColor: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  buttonTheme: const ButtonThemeData(
    buttonColor: vscodeLightPrimary,
    textTheme: ButtonTextTheme.primary,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: const TextStyle(color: Colors.black),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: vscodeLightPrimary),
      ),
    ),
  ),
);
