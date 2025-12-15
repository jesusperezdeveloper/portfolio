import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';

enum ButtonVariant { primary, secondary, outline, ghost }

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: widget.isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.isDisabled || widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: widget.height ?? 52,
          transform: Matrix4.identity()
            ..setEntry(0, 0, _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0))
            ..setEntry(1, 1, _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0)),
          transformAlignment: Alignment.center,
          decoration: _buildDecoration(isDark),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.icon != null ? AppSpacing.lg : AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getTextColor(isDark),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ] else if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 20,
                    color: _getTextColor(isDark),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(isDark),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(target: _isHovered ? 1 : 0)
        .shimmer(
          duration: 1.seconds,
          color: widget.variant == ButtonVariant.primary
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.transparent,
        );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return BoxDecoration(
          gradient: _isHovered
              ? LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.9),
                    AppColors.accentDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        );

      case ButtonVariant.secondary:
        return BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.secondaryStart.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        );

      case ButtonVariant.outline:
        return BoxDecoration(
          color: _isHovered
              ? AppColors.accent.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: AppColors.accent,
            width: 2,
          ),
        );

      case ButtonVariant.ghost:
        return BoxDecoration(
          color: _isHovered
              ? (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05))
              : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
        );
    }
  }

  Color _getTextColor(bool isDark) {
    if (widget.isDisabled) {
      return isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    }

    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.primaryDark;
      case ButtonVariant.secondary:
        return Colors.white;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return AppColors.accent;
    }
  }
}
