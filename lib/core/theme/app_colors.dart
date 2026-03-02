import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Swiggy/Zomato warm palette
  static const Color primary = Color(0xFFFC8019);
  static const Color primaryDark = Color(0xFFE8740F);
  static const Color primaryLight = Color(0xFFFFA54C);
  static const Color secondary = Color(0xFFE23744);

  // Background
  static const Color scaffoldBg = Color(0xFFF2F3F5);
  static const Color cardBg = Colors.white;
  static const Color surfaceDark = Color(0xFF171A29);
  static const Color headerBg = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1C1C2B);
  static const Color textSecondary = Color(0xFF686B78);
  static const Color textLight = Color(0xFF93959F);
  static const Color textOnPrimary = Colors.white;

  // Accent
  static const Color green = Color(0xFF48C479);
  static const Color starYellow = Color(0xFFFFC714);
  static const Color tagBg = Color(0xFFF0F0F5);

  // Status
  static const Color error = Color(0xFFE23744);
  static const Color success = Color(0xFF48C479);

  // Shimmer
  static const Color shimmerBase = Color(0xFFE8E8E8);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFC8019), Color(0xFFFF9B44)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xBB000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x00000000), Color(0x99000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
