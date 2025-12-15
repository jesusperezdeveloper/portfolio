import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';

enum ButtonVariant { primary, secondary, outline, ghost }

/// A modern animated button with multiple variants.
///
/// Supports primary (gradient), secondary (purple), outline (bordered),
/// and ghost (transparent) variants with smooth hover animations.
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
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
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
          transform: _buildTransform(),
          transformAlignment: Alignment.center,
          decoration: _buildDecoration(isDark),
          child: _buildContent(isDark),
        ),
      ),
    );
  }

  Matrix4 _buildTransform() {
    // Only apply scale transform to primary and secondary variants
    if (widget.variant == ButtonVariant.outline ||
        widget.variant == ButtonVariant.ghost) {
      return Matrix4.identity();
    }

    const pressedScale = 0.96;
    const hoverScale = 1.02;
    const normalScale = 1.0;
    final scale = _isPressed ? pressedScale : (_isHovered ? hoverScale : normalScale);
    return Matrix4.diagonal3Values(scale, scale, normalScale);
  }

  Widget _buildContent(bool isDark) {
    final textColor = _getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isLoading) ...[
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ] else if (widget.icon != null) ...[
            Icon(
              widget.icon,
              size: 18,
              color: textColor,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: _isHovered
                ? [
                    AppColors.accent.withValues(alpha: 0.85),
                    AppColors.accentDark.withValues(alpha: 0.95),
                  ]
                : [AppColors.accent, AppColors.accentDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: _isHovered ? 0.5 : 0.25),
              blurRadius: _isHovered ? 24 : 12,
              offset: Offset(0, _isHovered ? 8 : 4),
              spreadRadius: _isHovered ? 2 : 0,
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
        // Solid dark background to ensure text renders correctly on Flutter Web
        return BoxDecoration(
          color: _isHovered
              ? AppColors.primaryDark.withValues(alpha: 0.98)
              : AppColors.primaryDark.withValues(alpha: 0.95),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: _isHovered
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.8),
            width: 1.5,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        );

      case ButtonVariant.ghost:
        return BoxDecoration(
          color: _isHovered
              ? (isDark
                  ? Colors.white.withValues(alpha: 0.08)
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
