import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ---------------------------------------------------------------------------
// About Section v2.0
// ---------------------------------------------------------------------------

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: CustomPaint(
        painter: _DotGridPainter(isDark: isDark),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 80 : 120,
            horizontal: Responsive.horizontalPadding(context),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
              child: _AboutContent(isDark: isDark, isMobile: isMobile),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.isDark, required this.isMobile});

  final bool isDark;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        _SectionHeader(isDark: isDark, l10n: l10n),
        SizedBox(height: isMobile ? AppSpacing.xl : AppSpacing.xxl),

        // Main layout: text + avatar
        if (isMobile)
          _buildMobileLayout(context, l10n)
        else
          _buildDesktopLayout(context, l10n),

        // Stats grid
        SizedBox(height: isMobile ? AppSpacing.xl : AppSpacing.xxl),
        _StatsGrid(isDark: isDark, isMobile: isMobile, l10n: l10n),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: description (60%)
        Expanded(
          flex: 6,
          child: _DescriptionParagraphs(isDark: isDark, l10n: l10n),
        ),
        const SizedBox(width: AppSpacing.xxl),
        // Right: avatar placeholder (40%)
        Expanded(
          flex: 4,
          child: Center(child: _AnimatedAvatar(isDark: isDark)),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Center(child: _AnimatedAvatar(isDark: isDark, size: 220)),
        const SizedBox(height: AppSpacing.xl),
        _DescriptionParagraphs(isDark: isDark, l10n: l10n),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section Header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('about_title'),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(begin: -0.1, end: 0, duration: 500.ms),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.translate('about_subtitle'),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.6),
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideX(begin: -0.1, end: 0, duration: 500.ms, delay: 100.ms),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Description Paragraphs — staggered fade-in + slide from left
// ---------------------------------------------------------------------------

class _DescriptionParagraphs extends StatelessWidget {
  const _DescriptionParagraphs({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          height: 1.8,
        );

    final keys = [
      'about_description_1',
      'about_description_2',
      'about_description_3',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.lg),
          Text(l10n.translate(keys[i]), style: textStyle)
              .animate()
              .fadeIn(duration: 600.ms, delay: Duration(milliseconds: i * 200))
              .slideX(
                begin: -0.08,
                end: 0,
                duration: 600.ms,
                delay: Duration(milliseconds: i * 200),
                curve: Curves.easeOutCubic,
              ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Animated Avatar Placeholder — rotating gradient border
// ---------------------------------------------------------------------------

class _AnimatedAvatar extends StatefulWidget {
  const _AnimatedAvatar({required this.isDark, this.size = 280});

  final bool isDark;
  final double size;

  @override
  State<_AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<_AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: SweepGradient(
              transform: GradientRotation(_controller.value * math.pi * 2),
              colors: const [
                AppColors.accent,
                AppColors.secondaryStart,
                AppColors.secondaryEnd,
                AppColors.accent,
              ],
              stops: const [0.0, 0.33, 0.66, 1.0],
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isDark
                ? [
                    AppColors.surfaceDark,
                    AppColors.backgroundDark,
                  ]
                : [
                    AppColors.surfaceLight,
                    AppColors.cardLight,
                  ],
          ),
        ),
        child: Center(
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accent, AppColors.secondaryEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Icon(
              Icons.person_rounded,
              size: widget.size * 0.45,
              color: Colors.white,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: 300.ms)
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          duration: 800.ms,
          delay: 300.ms,
          curve: Curves.easeOutBack,
        );
  }
}

// ---------------------------------------------------------------------------
// Stats Grid — 4 stats with animated counters
// ---------------------------------------------------------------------------

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.isDark,
    required this.isMobile,
    required this.l10n,
  });

  final bool isDark;
  final bool isMobile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
        value: 5,
        prefix: '+',
        label: l10n.translate('about_stats_years'),
      ),
      _StatData(
        value: 10,
        prefix: '+',
        label: l10n.translate('about_stats_projects'),
      ),
      _StatData(
        value: 6,
        prefix: '+',
        label: l10n.translate('about_stats_technologies'),
      ),
      _StatData(
        value: 4,
        prefix: '',
        label: l10n.translate('about_stats_languages'),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _AnimatedStatCard(stat: stats[0], isDark: isDark)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _AnimatedStatCard(stat: stats[1], isDark: isDark)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _AnimatedStatCard(stat: stats[2], isDark: isDark)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _AnimatedStatCard(stat: stats[3], isDark: isDark)),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: _AnimatedStatCard(stat: stats[i], isDark: isDark)),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stat data model
// ---------------------------------------------------------------------------

class _StatData {
  const _StatData({
    required this.value,
    required this.prefix,
    required this.label,
  });

  final int value;
  final String prefix;
  final String label;
}

// ---------------------------------------------------------------------------
// Animated Stat Card — counter triggered by visibility
// ---------------------------------------------------------------------------

class _AnimatedStatCard extends StatefulWidget {
  const _AnimatedStatCard({required this.stat, required this.isDark});

  final _StatData stat;
  final bool isDark;

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.stat.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ),);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_hasTriggered) {
      _hasTriggered = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('stat_${widget.stat.label}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        padding: AppSpacing.paddingAllLg,
        decoration: BoxDecoration(
          color: widget.isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: widget.isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorderLight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                final displayValue =
                    '${widget.stat.prefix}${_animation.value.toInt()}';
                return ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.accent, AppColors.secondaryEnd],
                  ).createShader(bounds),
                  child: Text(
                    displayValue,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.stat.label,
              style: TextStyle(
                fontSize: 14,
                color: widget.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dot Grid Background Painter
// ---------------------------------------------------------------------------

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black)
          .withValues(alpha: isDark ? 0.04 : 0.03)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const radius = 1.2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
