import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/features/hero/presentation/widgets/floating_shapes.dart';
import 'package:portfolio_jps/shared/widgets/animated_button.dart';
import 'package:portfolio_jps/shared/widgets/particle_background.dart';
import 'package:portfolio_jps/shared/widgets/text_scramble.dart';

/// Cinematic hero section with 3-layer parallax, text scramble effect,
/// floating geometric shapes, and staggered entry animations.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    this.onScrollToSection,
    this.scrollOffset = 0,
  });

  final void Function(int index)? onScrollToSection;
  final double scrollOffset;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _showScramble = false;

  @override
  void initState() {
    super.initState();
    // Delay scramble start for dramatic effect
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _showScramble = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: screenHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Layer 0: Background gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.heroGradient
                    : AppColors.heroGradientLight,
              ),
            ),
          ),

          // Layer 1 (0.3x parallax): Particle field
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, widget.scrollOffset * 0.3),
              child: const ParticleBackground(),
            ),
          ),

          // Layer 2 (0.6x parallax): Floating geometric shapes
          if (!isMobile)
            Positioned.fill(
              child: FloatingShapes(
                scrollOffset: widget.scrollOffset,
              ),
            ),

          // Radial glow behind content area
          if (isDark)
            Positioned(
              left: isMobile
                  ? MediaQuery.of(context).size.width * 0.2
                  : MediaQuery.of(context).size.width * 0.15,
              top: screenHeight * 0.3,
              child: Container(
                width: 500,
                height: 500,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.glowCyan,
                      Colors.transparent,
                    ],
                    radius: 0.6,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 1200.ms),
            ),

          // Layer 3 (1.0x): Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxContentWidth,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    // Availability Badge with pulse rings
                    _AvailabilityBadge(l10n: l10n)
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .slideY(begin: -0.3, end: 0),

                    const SizedBox(height: AppSpacing.lg),

                    // Greeting
                    Text(
                      l10n.heroGreeting,
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: isDark
                                    ? AppColors.accent
                                    : AppColors.accentLight,
                                fontWeight: FontWeight.w500,
                              ),
                      textAlign:
                          isMobile ? TextAlign.center : TextAlign.start,
                    )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: AppSpacing.xs),

                    // Name with scramble effect
                    TextScramble(
                      text: l10n.heroName,
                      animate: _showScramble,
                      style: context.responsive(
                        mobile:
                            Theme.of(context).textTheme.displayMedium,
                        tablet:
                            Theme.of(context).textTheme.displayLarge,
                        desktop: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                              fontSize: 80,
                              letterSpacing: -3,
                            ),
                      )?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Role with typing effect
                    SizedBox(
                      height: 40,
                      child: DefaultTextStyle(
                        style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ) ??
                            const TextStyle(),
                        textAlign:
                            isMobile ? TextAlign.center : TextAlign.start,
                        child: AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(seconds: 3),
                          animatedTexts: [
                            TypewriterAnimatedText(
                              l10n.heroRole,
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Flutter Specialist',
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Clean Architecture Advocate',
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Mobile Craftsman',
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Performance Obsessed',
                              speed: const Duration(milliseconds: 80),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 2500.ms, duration: 600.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // Tagline
                    SizedBox(
                      width: isMobile ? double.infinity : 600,
                      child: Text(
                        l10n.heroTagline,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              height: 1.7,
                            ),
                        textAlign:
                            isMobile ? TextAlign.center : TextAlign.start,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1800.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: AppSpacing.xxl),

                    // CTA Buttons with materialize effect
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      alignment: isMobile
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        AnimatedButton(
                          text: l10n.heroCtaContact,
                          onPressed: () =>
                              widget.onScrollToSection?.call(5),
                          icon: Icons.send,
                        )
                            .animate()
                            .fadeIn(delay: 2200.ms, duration: 500.ms)
                            .scaleXY(
                              begin: 0.8,
                              end: 1,
                              delay: 2200.ms,
                              duration: 500.ms,
                              curve: Curves.easeOutBack,
                            )
                            .blurXY(
                              begin: 5,
                              end: 0,
                              delay: 2200.ms,
                              duration: 400.ms,
                            ),
                        AnimatedButton(
                          text: l10n.heroCtaProjects,
                          variant: ButtonVariant.outline,
                          onPressed: () =>
                              widget.onScrollToSection?.call(2),
                          icon: Icons.work_outline,
                        )
                            .animate()
                            .fadeIn(delay: 2400.ms, duration: 500.ms)
                            .scaleXY(
                              begin: 0.8,
                              end: 1,
                              delay: 2400.ms,
                              duration: 500.ms,
                              curve: Curves.easeOutBack,
                            )
                            .blurXY(
                              begin: 5,
                              end: 0,
                              delay: 2400.ms,
                              duration: 400.ms,
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                    size: 28,
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .slideY(
                        begin: 0,
                        end: 0.4,
                        duration: 1200.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .slideY(
                        begin: 0.4,
                        end: 0,
                        duration: 1200.ms,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 4),
                  Container(
                    width: 1.5,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight)
                              .withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .fadeIn(duration: 1200.ms)
                      .then()
                      .fadeOut(duration: 1200.ms),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 3.seconds, duration: 600.ms),
        ],
      ),
    );
  }
}

/// Availability badge with animated pulse rings.
class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot with rings
          SizedBox(
            width: 20,
            height: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ring 3 (outermost)
                _PulseRing(delay: 0.ms, size: 20),
                // Ring 2
                _PulseRing(delay: 400.ms, size: 16),
                // Ring 1
                _PulseRing(delay: 800.ms, size: 12),
                // Core dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            l10n.heroAvailable,
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.delay, required this.size});

  final Duration delay;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .fadeIn(delay: delay, duration: 800.ms)
        .scaleXY(begin: 0.5, end: 1, delay: delay, duration: 1500.ms)
        .then()
        .fadeOut(duration: 800.ms);
  }
}
