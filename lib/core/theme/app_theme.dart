import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/theme/app_typography.dart';

abstract class AppTheme {
  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          onPrimary: AppColors.primaryDark,
          secondary: AppColors.secondaryStart,
          onSecondary: Colors.white,
          surface: AppColors.surfaceDark,
          error: AppColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardColor: AppColors.cardDark,
        dividerColor: AppColors.textMutedDark.withValues(alpha: 0.2),

        // AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.titleLargeDark,
          iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        ),

        // Text Theme
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLargeDark,
          displayMedium: AppTypography.displayMediumDark,
          displaySmall: AppTypography.displaySmallDark,
          headlineLarge: AppTypography.headlineLargeDark,
          headlineMedium: AppTypography.headlineMediumDark,
          headlineSmall: AppTypography.headlineSmallDark,
          titleLarge: AppTypography.titleLargeDark,
          titleMedium: AppTypography.titleMediumDark,
          titleSmall: AppTypography.titleSmallDark,
          bodyLarge: AppTypography.bodyLargeDark,
          bodyMedium: AppTypography.bodyMediumDark,
          bodySmall: AppTypography.bodySmallDark,
          labelLarge: AppTypography.labelLargeDark,
          labelMedium: AppTypography.labelMediumDark,
          labelSmall: AppTypography.labelSmallDark,
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardDark,
          contentPadding: AppSpacing.paddingAllMd,
          border: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.textMutedDark.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.accent,
              width: 2,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.error,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2,
            ),
          ),
          labelStyle: AppTypography.bodyMediumDark,
          hintStyle: AppTypography.bodyMediumDark.copyWith(
            color: AppColors.textMutedDark,
          ),
          errorStyle: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.error,
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            side: const BorderSide(color: AppColors.accent),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Icon Theme
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryDark,
          size: 24,
        ),

        // Card Theme
        cardTheme: const CardThemeData(
          color: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
          ),
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.cardDark,
          labelStyle: AppTypography.labelMediumDark,
          side: BorderSide(color: AppColors.textMutedDark.withValues(alpha: 0.3)),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
        ),

        // Tooltip Theme
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: AppSpacing.borderRadiusSm,
            border: Border.all(
              color: AppColors.textMutedDark.withValues(alpha: 0.2),
            ),
          ),
          textStyle: AppTypography.bodySmallDark.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),

        // Scrollbar Theme
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(
            AppColors.textMutedDark.withValues(alpha: 0.5),
          ),
          trackColor: WidgetStateProperty.all(
            AppColors.textMutedDark.withValues(alpha: 0.1),
          ),
          radius: const Radius.circular(4),
          thickness: WidgetStateProperty.all(8),
        ),
      );

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.accentDark,
          secondary: AppColors.secondaryStart,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimaryLight,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        cardColor: AppColors.cardLight,
        dividerColor: AppColors.textMutedLight.withValues(alpha: 0.2),

        // AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.titleLargeLight,
          iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        ),

        // Text Theme
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLargeLight,
          displayMedium: AppTypography.displayMediumLight,
          displaySmall: AppTypography.displaySmallLight,
          headlineLarge: AppTypography.headlineLargeLight,
          headlineMedium: AppTypography.headlineMediumLight,
          headlineSmall: AppTypography.headlineSmallLight,
          titleLarge: AppTypography.titleLargeLight,
          titleMedium: AppTypography.titleMediumLight,
          titleSmall: AppTypography.titleSmallLight,
          bodyLarge: AppTypography.bodyLargeLight,
          bodyMedium: AppTypography.bodyMediumLight,
          bodySmall: AppTypography.bodySmallLight,
          labelLarge: AppTypography.labelLargeLight,
          labelMedium: AppTypography.labelMediumLight,
          labelSmall: AppTypography.labelSmallLight,
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardLight,
          contentPadding: AppSpacing.paddingAllMd,
          border: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.textMutedLight.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.accentDark,
              width: 2,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.error,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2,
            ),
          ),
          labelStyle: AppTypography.bodyMediumLight,
          hintStyle: AppTypography.bodyMediumLight.copyWith(
            color: AppColors.textMutedLight,
          ),
          errorStyle: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.error,
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            elevation: 0,
          ),
        ),

        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accentDark,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            side: const BorderSide(color: AppColors.accentDark),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentDark,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Icon Theme
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryLight,
          size: 24,
        ),

        // Card Theme
        cardTheme: const CardThemeData(
          color: AppColors.cardLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
          ),
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.cardLight,
          labelStyle: AppTypography.labelMediumLight,
          side: BorderSide(color: AppColors.textMutedLight.withValues(alpha: 0.3)),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
        ),

        // Tooltip Theme
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppSpacing.borderRadiusSm,
            border: Border.all(
              color: AppColors.textMutedLight.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          textStyle: AppTypography.bodySmallLight.copyWith(
            color: AppColors.textPrimaryLight,
          ),
        ),

        // Scrollbar Theme
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(
            AppColors.textMutedLight.withValues(alpha: 0.5),
          ),
          trackColor: WidgetStateProperty.all(
            AppColors.textMutedLight.withValues(alpha: 0.1),
          ),
          radius: const Radius.circular(4),
          thickness: WidgetStateProperty.all(8),
        ),
      );
}
