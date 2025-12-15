import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Palette
  static const Color primaryDark = Color(0xFF1a1a2e);
  static const Color primaryLight = Color(0xFF16213e);
  static const Color accent = Color(0xFF00d4ff);
  static const Color accentDark = Color(0xFF00a8cc);

  // Secondary - Purple Gradient
  static const Color secondaryStart = Color(0xFF6366f1);
  static const Color secondaryEnd = Color(0xFF8b5cf6);

  // Backgrounds
  static const Color backgroundDark = Color(0xFF0f0f23);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF1a1a2e);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF252540);
  static const Color cardLight = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1a1a2e);
  static const Color textSecondaryDark = Color(0xFFa0a0b8);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedDark = Color(0xFF6b6b80);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Special
  static const Color codeBackground = Color(0xFF1e1e3f);
  static const Color terminalGreen = Color(0xFF00ff88);
  static const Color highlightYellow = Color(0xFFffd93d);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [secondaryStart, secondaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF0f0f23),
      Color(0xFF1a1a2e),
      Color(0xFF16213e),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Light theme hero gradient - modern blue to purple gradient
  static const LinearGradient heroGradientLight = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF0F4FF),
      Color(0xFFE8EEFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Accent color adjusted for light backgrounds
  static const Color accentLight = Color(0xFF0095CC);

  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      Color(0x4000d4ff),
      Color(0x0000d4ff),
    ],
    radius: 0.8,
  );

  // Shadows
  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get cardShadowLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get glowShadow => [
        BoxShadow(
          color: accent.withValues(alpha: 0.4),
          blurRadius: 30,
          spreadRadius: 5,
        ),
      ];
}
