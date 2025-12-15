import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';

/// A horizontal carousel widget with page indicators and scale animations.
///
/// Features:
/// - Swipe gestures with PageView physics
/// - Animated page indicators (dots)
/// - Scale effect on non-active items
/// - Peek effect showing adjacent items
/// - Theme-aware colors
class HorizontalCarousel extends StatefulWidget {
  const HorizontalCarousel({
    required this.items,
    this.itemHeight,
    this.viewportFraction = 0.85,
    this.showIndicators = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.inactiveScale = 0.92,
    this.inactiveOpacity = 0.6,
    super.key,
  });

  /// List of widgets to display in the carousel.
  final List<Widget> items;

  /// Fixed height for the carousel items. If null, uses intrinsic height.
  final double? itemHeight;

  /// Fraction of viewport occupied by each item (0.0 to 1.0).
  /// Lower values show more of adjacent items.
  final double viewportFraction;

  /// Whether to show page indicator dots below the carousel.
  final bool showIndicators;

  /// Duration of scale/opacity animations.
  final Duration animationDuration;

  /// Curve for scale/opacity animations.
  final Curve animationCurve;

  /// Scale factor for non-active items (0.0 to 1.0).
  final double inactiveScale;

  /// Opacity for non-active items (0.0 to 1.0).
  final double inactiveOpacity;

  @override
  State<HorizontalCarousel> createState() => _HorizontalCarouselState();
}

class _HorizontalCarouselState extends State<HorizontalCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.itemHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  var value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page ?? 0) - index;
                    value = 1 - value.abs().clamp(0.0, 1.0);
                  }

                  final scale = widget.inactiveScale +
                      (1 - widget.inactiveScale) * value;
                  final opacity = widget.inactiveOpacity +
                      (1 - widget.inactiveOpacity) * value;

                  return Center(
                    child: AnimatedOpacity(
                      duration: widget.animationDuration,
                      curve: widget.animationCurve,
                      opacity: opacity,
                      child: AnimatedScale(
                        duration: widget.animationDuration,
                        curve: widget.animationCurve,
                        scale: scale,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.sm,
                  ),
                  child: widget.items[index],
                ),
              );
            },
          ),
        ),
        if (widget.showIndicators && widget.items.length > 1) ...[
          const SizedBox(height: AppSpacing.md),
          _CarouselIndicators(
            count: widget.items.length,
            currentIndex: _currentPage,
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: widget.animationDuration,
                curve: widget.animationCurve,
              );
            },
          ),
        ],
      ],
    );
  }
}

/// Animated dot indicators for the carousel.
class _CarouselIndicators extends StatelessWidget {
  const _CarouselIndicators({
    required this.count,
    required this.currentIndex,
    required this.onTap,
  });

  final int count;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.accent : AppColors.accentLight;
    final inactiveColor = activeColor.withValues(alpha: 0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return GestureDetector(
          onTap: () => onTap(index),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxs,
              vertical: AppSpacing.sm,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? activeColor : inactiveColor,
                borderRadius: AppSpacing.borderRadiusFull,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
