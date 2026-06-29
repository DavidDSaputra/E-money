import 'package:flutter/material.dart';

class AppColors {
  // Primary Purple
  static const Color primary = Color(0xFF6C3DE8);
  static const Color primaryLight = Color(0xFF9C72F5);
  static const Color primaryDark = Color(0xFF4A1FBF);
  static const Color primarySurface = Color(0xFFF0EAFF);
  static const Color primaryBorder = Color(0xFFD4BBFF);

  // Semantic
  static const Color green = Color(0xFF10B981);
  static const Color greenSurface = Color(0xFFECFDF5);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberSurface = Color(0xFFFFFBEB);
  static const Color red = Color(0xFFEF4444);
  static const Color redSurface = Color(0xFFFEF2F2);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color violetSurface = Color(0xFFF5F3FF);

  // Neutral
  static const Color ink = Color(0xFF0F172A);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color line = Color(0xFFE2E8F0);
  static const Color line2 = Color(0xFFF1F5F9);
  static const Color bg = Color(0xFFF8F7FF);
  static const Color white = Color(0xFFFFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A1FBF), Color(0xFF6C3DE8)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D1690), Color(0xFF5C2EBE)],
  );

  static List<BoxShadow> shadowCard = [
    const BoxShadow(
      color: Color(0x146C3DE8),
      blurRadius: 24,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowSoft = [
    const BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowPrimary = [
    const BoxShadow(
      color: Color(0x3D6C3DE8),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static Map<String, List<Color>> tones = {
    'blue': [primarySurface, primary],
    'green': [greenSurface, green],
    'amber': [amberSurface, amber],
    'red': [redSurface, red],
    'violet': [violetSurface, violet],
    'slate': [bg, slate600],
  };

  static List<Color> tone(String name) => tones[name] ?? tones['blue']!;
}
