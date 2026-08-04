import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color _primaryColor = const Color(0xFFE91E63);
Color _secondaryColor = const Color(0xFFFF4081);

ThemeData light({Color? primaryColor, Color? secondaryColor}) => ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: primaryColor ?? _primaryColor,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: const Color(0xFF9E9E9E),
  splashColor: Colors.transparent,
  cardColor: Colors.white,

  scaffoldBackgroundColor: const Color(0xFFF8F9FA),

  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Color(0xFF1F2937)),
    bodyMedium: TextStyle(color: primaryColor ?? _primaryColor),
    bodySmall: const TextStyle(color: Color(0xFF6B7280)),

    titleMedium: const TextStyle(color: Color(0xFF374151)),
  ),

  colorScheme: ColorScheme.light(
    primary: primaryColor ?? _primaryColor,
    secondary: secondaryColor ?? _secondaryColor,
    tertiary: const Color(0xFFFFB703),
    tertiaryContainer: const Color(0xFFFFE0EB),
    onTertiaryContainer: const Color(0xFF10B981),
    onPrimary: const Color(0xFFFFFFFF),
    surface: const Color(0xFFFFFFFF),
    onSecondary: const Color(0xFFFFFFFF),
    error: const Color(0xFFEF4444),
    onSecondaryContainer: const Color(0xFFFFF0F5),
    outline: const Color(0xFFE5E7EB),
    onTertiary: const Color(0xFFFFF5F8),
    shadow: const Color(0x1A000000),

    primaryContainer: const Color(0xFFFCE4EC),
    secondaryContainer: const Color(0xFFF3F4F6),
  ),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);