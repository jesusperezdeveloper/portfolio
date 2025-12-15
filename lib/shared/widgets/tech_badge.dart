import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';

class TechBadge extends StatefulWidget {
  const TechBadge({
    required this.label,
    this.icon,
    this.color,
    this.size = TechBadgeSize.medium,
    this.onTap,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final TechBadgeSize size;
  final VoidCallback? onTap;

  @override
  State<TechBadge> createState() => _TechBadgeState();
}

enum TechBadgeSize { small, medium, large }

class _TechBadgeState extends State<TechBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = widget.color ?? AppColors.accent;

    final (fontSize, iconSize, paddingH, paddingV) = switch (widget.size) {
      TechBadgeSize.small => (11.0, 12.0, AppSpacing.sm, AppSpacing.xxs),
      TechBadgeSize.medium => (13.0, 16.0, AppSpacing.md, AppSpacing.xs),
      TechBadgeSize.large => (15.0, 20.0, AppSpacing.lg, AppSpacing.sm),
    };

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: paddingH,
            vertical: paddingV,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? color.withValues(alpha: 0.2)
                : color.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: AppSpacing.borderRadiusFull,
            border: Border.all(
              color: _isHovered
                  ? color.withValues(alpha: 0.6)
                  : color.withValues(alpha: 0.3),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: iconSize,
                  color: color,
                ),
                const SizedBox(width: AppSpacing.xxs),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
