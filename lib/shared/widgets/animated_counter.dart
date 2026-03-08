import 'package:flutter/material.dart';

import 'package:portfolio_jps/core/theme/app_colors.dart';

/// An animated counter widget that counts up from 0 to [targetValue]
/// with a smooth easeOutCubic curve and a subtle scale bounce on completion.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    required this.targetValue,
    super.key,
    this.suffix = '',
    this.prefix = '',
    this.duration = const Duration(milliseconds: 2000),
    this.style,
    this.animate = false,
  });

  /// The final number the counter will reach.
  final int targetValue;

  /// Text displayed after the number (e.g. "+", "años").
  final String suffix;

  /// Text displayed before the number.
  final String prefix;

  /// Total duration of the count-up animation.
  final Duration duration;

  /// Custom text style for the number. Defaults to SpaceGrotesk Bold 48px.
  final TextStyle? style;

  /// When set to true, triggers the count-up animation.
  final bool animate;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late final AnimationController _countController;
  late final Animation<double> _countAnimation;

  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    // Count-up animation
    _countController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _countAnimation = CurvedAnimation(
      parent: _countController,
      curve: Curves.easeOutCubic,
    );

    _countController.addStatusListener(_onCountComplete);

    // Bounce animation on completion
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.05)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_bounceController);

    if (widget.animate) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animate && !oldWidget.animate && !_hasAnimated) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _hasAnimated = true;
    _countController.forward(from: 0);
  }

  void _onCountComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _countController
      ..removeStatusListener(_onCountComplete)
      ..dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultStyle = TextStyle(
      fontFamily: 'SpaceGrotesk',
      fontWeight: FontWeight.bold,
      fontSize: 48,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );

    final numberStyle = widget.style ?? defaultStyle;
    final affixStyle = numberStyle.copyWith(
      fontSize: (numberStyle.fontSize ?? 48) * 0.6,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );

    return AnimatedBuilder(
      animation: Listenable.merge([_countAnimation, _bounceAnimation]),
      builder: (context, child) {
        final currentValue =
            (_countAnimation.value * widget.targetValue).toInt();

        final scale = _bounceController.isAnimating || _bounceController.isCompleted
            ? _bounceAnimation.value
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (widget.prefix.isNotEmpty)
                Text(widget.prefix, style: affixStyle),
              Text('$currentValue', style: numberStyle),
              if (widget.suffix.isNotEmpty)
                Text(widget.suffix, style: affixStyle),
            ],
          ),
        );
      },
    );
  }
}
