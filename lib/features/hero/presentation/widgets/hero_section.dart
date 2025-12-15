import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/widgets/animated_button.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart';
import 'package:portfolio_jps/shared/widgets/particle_background.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    this.onScrollToSection,
  });

  /// Callback to scroll to a specific section by index.
  /// Index 1 = Projects, Index 4 = Contact
  final void Function(int index)? onScrollToSection;

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
          // Background gradient for light theme
          if (!isDark)
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradientLight,
                ),
              ),
            ),
          // Particle Background
          const Positioned.fill(
            child: CodePeekWrapper(
              componentCode: ComponentCodes.particleBackground,
              child: ParticleBackground(),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.5,
                  colors: isDark
                      ? [
                          Colors.transparent,
                          AppColors.backgroundDark.withValues(alpha: 0.8),
                        ]
                      : [
                          Colors.transparent,
                          AppColors.backgroundLight.withValues(alpha: 0.3),
                        ],
                ),
              ),
            ),
          ),
          // Content
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
                  crossAxisAlignment:
                      isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    // Availability Badge
                    CodePeekWrapper(
                      componentCode: ComponentCodes.availabilityBadge,
                      child: _buildAvailabilityBadge(context, l10n),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .slideY(begin: -0.3, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    // Greeting
                    Text(
                      l10n.heroGreeting,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDark ? AppColors.accent : AppColors.accentLight,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                    const SizedBox(height: AppSpacing.sm),
                    // Name
                    Text(
                      l10n.heroName,
                      style: context.responsive(
                        mobile: Theme.of(context).textTheme.displayMedium,
                        tablet: Theme.of(context).textTheme.displayLarge,
                        desktop: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 80,
                            ),
                      )?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),
                    const SizedBox(height: AppSpacing.md),
                    // Role with typing effect
                    SizedBox(
                      height: 40,
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ) ??
                            const TextStyle(),
                        textAlign: isMobile ? TextAlign.center : TextAlign.start,
                        child: AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(seconds: 3),
                          animatedTexts: [
                            TypewriterAnimatedText(
                              l10n.heroRole,
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Flutter Expert',
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Mobile Developer',
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Clean Architecture',
                              speed: const Duration(milliseconds: 80),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1500.ms, duration: 600.ms),
                    const SizedBox(height: AppSpacing.lg),
                    // Tagline
                    SizedBox(
                      width: isMobile ? double.infinity : 600,
                      child: Text(
                        l10n.heroTagline,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              height: 1.6,
                            ),
                        textAlign: isMobile ? TextAlign.center : TextAlign.start,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1800.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: AppSpacing.xxl),
                    // CTA Buttons
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                      children: [
                        CodePeekWrapper(
                          componentCode: ComponentCodes.animatedButton,
                          child: AnimatedButton(
                            text: l10n.heroCtaContact,
                            onPressed: () => onScrollToSection?.call(4),
                            icon: Icons.send,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 2200.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        CodePeekWrapper(
                          componentCode: ComponentCodes.animatedButton,
                          child: AnimatedButton(
                            text: l10n.heroCtaProjects,
                            variant: ButtonVariant.outline,
                            onPressed: () => onScrollToSection?.call(1),
                            icon: Icons.work_outline,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 2400.ms, duration: 600.ms),
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
              child: _buildScrollIndicator(isDark)
                  .animate(onPlay: (controller) => controller.repeat())
                  .slideY(
                    begin: 0,
                    end: 0.3,
                    duration: 1.seconds,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 1.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
          )
              .animate()
              .fadeIn(delay: 3.seconds, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildAvailabilityBadge(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 1.seconds)
              .then()
              .fadeOut(duration: 1.seconds),
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

  Widget _buildScrollIndicator(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.keyboard_arrow_down,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          size: 32,
        ),
      ],
    );
  }
}
