import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';

class GlassCard extends StatefulWidget {
  const GlassCard({
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderOpacity = 0.2,
    this.enableHover = true,
    this.onTap,
    super.key,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final bool enableHover;
  final VoidCallback? onTap;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = widget.borderRadius ?? AppSpacing.borderRadiusLg;

    return MouseRegion(
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: widget.enableHover ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blur,
                sigmaY: widget.blur,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(
                          alpha: _isHovered
                              ? widget.opacity + 0.05
                              : widget.opacity,
                        )
                      : Colors.white.withValues(
                          alpha: _isHovered ? 0.9 : 0.8,
                        ),
                  borderRadius: radius,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(
                            alpha: _isHovered
                                ? widget.borderOpacity + 0.1
                                : widget.borderOpacity,
                          )
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                padding: widget.padding ?? AppSpacing.paddingAllLg,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
