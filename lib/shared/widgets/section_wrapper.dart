import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SectionWrapper extends StatefulWidget {
  const SectionWrapper({
    required this.child,
    required this.sectionId,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.padding,
    this.maxWidth,
    this.enableAnimation = true,
    this.animationDelay = Duration.zero,
    super.key,
  });

  final Widget child;
  final String sectionId;
  final String? title;
  final String? subtitle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final bool enableAnimation;
  final Duration animationDelay;

  @override
  State<SectionWrapper> createState() => _SectionWrapperState();
}

class _SectionWrapperState extends State<SectionWrapper> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? AppSpacing.sectionPadding(context);
    final effectiveMaxWidth = widget.maxWidth ?? AppSpacing.maxContentWidth;

    return VisibilityDetector(
      key: Key(widget.sectionId),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: widget.backgroundColor,
        padding: effectivePadding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null) ...[
                  _buildSectionHeader(context),
                  SizedBox(
                    height: context.responsive(
                      mobile: AppSpacing.lg,
                      tablet: AppSpacing.xl,
                      desktop: AppSpacing.xxl,
                    ),
                  ),
                ],
                if (widget.enableAnimation)
                  _isVisible
                      ? widget.child
                          .animate()
                          .fadeIn(
                            duration: 600.ms,
                            delay: widget.animationDelay,
                          )
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            duration: 600.ms,
                            delay: widget.animationDelay,
                            curve: Curves.easeOutCubic,
                          )
                      : Opacity(opacity: 0, child: widget.child)
                else
                  widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.enableAnimation && _isVisible)
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: widget.animationDelay)
              .slideX(
                begin: -0.1,
                end: 0,
                duration: 500.ms,
                delay: widget.animationDelay,
                curve: Curves.easeOutCubic,
              )
        else
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          if (widget.enableAnimation && _isVisible)
            Text(
              widget.subtitle!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: widget.animationDelay + 100.ms)
                .slideX(
                  begin: -0.1,
                  end: 0,
                  duration: 500.ms,
                  delay: widget.animationDelay + 100.ms,
                  curve: Curves.easeOutCubic,
                )
          else
            Text(
              widget.subtitle!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
            ),
        ],
      ],
    );
  }
}
