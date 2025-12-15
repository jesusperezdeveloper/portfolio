import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';

abstract class AppTypography {
  // Font Families
  static String get headingFontFamily => 'SpaceGrotesk';
  static String get bodyFontFamily => GoogleFonts.inter().fontFamily!;
  static String get codeFontFamily => 'JetBrainsMono';

  // Heading Styles - Dark Theme
  static TextStyle get displayLargeDark => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
        height: 1.1,
        letterSpacing: -2,
      );

  static TextStyle get displayMediumDark => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 56,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
        height: 1.15,
        letterSpacing: -1.5,
      );

  static TextStyle get displaySmallDark => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 44,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
        height: 1.2,
        letterSpacing: -1,
      );

  static TextStyle get headlineLargeDark => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: 1.25,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMediumDark => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: 1.3,
      );

  static TextStyle get headlineSmallDark => TextStyle(
        fontFamily: headingFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: 1.35,
      );

  // Title Styles - Dark Theme
  static TextStyle get titleLargeDark => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: 1.4,
      );

  static TextStyle get titleMediumDark => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: 1.45,
      );

  static TextStyle get titleSmallDark => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: 1.5,
      );

  // Body Styles - Dark Theme
  static TextStyle get bodyLargeDark => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondaryDark,
        height: 1.6,
      );

  static TextStyle get bodyMediumDark => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondaryDark,
        height: 1.6,
      );

  static TextStyle get bodySmallDark => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondaryDark,
        height: 1.6,
      );

  // Label Styles - Dark Theme
  static TextStyle get labelLargeDark => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: 1.4,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMediumDark => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDark,
        height: 1.4,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmallDark => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMutedDark,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // Code Style
  static TextStyle get codeDark => TextStyle(
        fontFamily: codeFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.terminalGreen,
        height: 1.5,
      );

  static TextStyle get codeSmallDark => TextStyle(
        fontFamily: codeFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.terminalGreen,
        height: 1.5,
      );

  // Heading Styles - Light Theme
  static TextStyle get displayLargeLight => displayLargeDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get displayMediumLight => displayMediumDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get displaySmallLight => displaySmallDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get headlineLargeLight => headlineLargeDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get headlineMediumLight => headlineMediumDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get headlineSmallLight => headlineSmallDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  // Title Styles - Light Theme
  static TextStyle get titleLargeLight => titleLargeDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get titleMediumLight => titleMediumDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get titleSmallLight => titleSmallDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  // Body Styles - Light Theme
  static TextStyle get bodyLargeLight => bodyLargeDark.copyWith(
        color: AppColors.textSecondaryLight,
      );

  static TextStyle get bodyMediumLight => bodyMediumDark.copyWith(
        color: AppColors.textSecondaryLight,
      );

  static TextStyle get bodySmallLight => bodySmallDark.copyWith(
        color: AppColors.textSecondaryLight,
      );

  // Label Styles - Light Theme
  static TextStyle get labelLargeLight => labelLargeDark.copyWith(
        color: AppColors.textPrimaryLight,
      );

  static TextStyle get labelMediumLight => labelMediumDark.copyWith(
        color: AppColors.textSecondaryLight,
      );

  static TextStyle get labelSmallLight => labelSmallDark.copyWith(
        color: AppColors.textMutedLight,
      );

  // Special Styles
  static TextStyle get accentText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
        height: 1.5,
      );

  static TextStyle get gradientCapable => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  // Responsive font size helper
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return mobile;
    if (width < 1200) return tablet;
    return desktop;
  }
}
