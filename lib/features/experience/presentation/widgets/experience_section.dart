import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/data/experience_data.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart';
import 'package:portfolio_jps/shared/widgets/horizontal_carousel.dart';
import 'package:portfolio_jps/shared/widgets/section_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final experiences = ExperiencesData.experiences;
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      sectionId: 'experience',
      title: l10n.experienceTitle,
      subtitle: l10n.experienceSubtitle,
      child: isMobile
          ? _buildMobileTimeline(context, experiences)
          : _buildDesktopTimeline(context, experiences),
    );
  }

  Widget _buildDesktopTimeline(
    BuildContext context,
    List<ExperienceData> experiences,
  ) {
    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;
        final isLeft = index.isEven;

        return _TimelineItem(
          experience: experience,
          isLeft: isLeft,
          isFirst: index == 0,
          isLast: index == experiences.length - 1,
          delay: index * 200,
        );
      }).toList(),
    );
  }

  Widget _buildMobileTimeline(
    BuildContext context,
    List<ExperienceData> experiences,
  ) {
    return HorizontalCarousel(
      itemHeight: 320,
      items: experiences.map((experience) {
        return _ExperienceCarouselCard(experience: experience);
      }).toList(),
    );
  }
}

class _TimelineItem extends StatefulWidget {
  const _TimelineItem({
    required this.experience,
    required this.isLeft,
    required this.isFirst,
    required this.isLast,
    required this.delay,
  });

  final ExperienceData experience;
  final bool isLeft;
  final bool isFirst;
  final bool isLast;
  final int delay;

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        children: [
          // Left side content or spacer
          Expanded(
            child: widget.isLeft
                ? _buildContent(context, isDark)
                : const SizedBox(),
          ),
          // Timeline line and dot
          _buildTimelineLine(isDark),
          // Right side content or spacer
          Expanded(
            child: widget.isLeft
                ? const SizedBox()
                : _buildContent(context, isDark),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: widget.delay),
          duration: 500.ms,
        )
        .slideX(
          begin: widget.isLeft ? -0.2 : 0.2,
          end: 0,
          delay: Duration(milliseconds: widget.delay),
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildTimelineLine(bool isDark) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          // Top line
          if (!widget.isFirst)
            Expanded(
              child: Container(
                width: 2,
                color: isDark
                    ? AppColors.accent.withValues(alpha: 0.3)
                    : AppColors.accentDark.withValues(alpha: 0.3),
              ),
            ),
          // Dot
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: widget.experience.isCurrent
                  ? AppColors.accent
                  : (isDark ? AppColors.cardDark : AppColors.cardLight),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent,
                width: 3,
              ),
              boxShadow: widget.experience.isCurrent
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
          // Bottom line
          if (!widget.isLast)
            Expanded(
              child: Container(
                width: 2,
                color: isDark
                    ? AppColors.accent.withValues(alpha: 0.3)
                    : AppColors.accentDark.withValues(alpha: 0.3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return CodePeekWrapper(
      componentCode: ComponentCodes.timelineItem,
      child: MouseRegion(
        cursor: widget.experience.companyUrl != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.experience.companyUrl != null
              ? () => _launchUrl(widget.experience.companyUrl!)
              : null,
          child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(
            left: widget.isLeft ? 0 : AppSpacing.lg,
            right: widget.isLeft ? AppSpacing.lg : 0,
            bottom: AppSpacing.xl,
          ),
          padding: AppSpacing.paddingAllLg,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05)),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date range
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Text(
                  widget.experience.dateRange,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Company
              Text(
                widget.experience.company,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              // Role
              Text(
                widget.experience.role,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Description
              Text(
                widget.experience.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Achievements
              ...widget.experience.achievements.map((achievement) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          achievement,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Compact experience card for mobile carousel.
class _ExperienceCarouselCard extends StatelessWidget {
  const _ExperienceCarouselCard({
    required this.experience,
  });

  final ExperienceData experience;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColors.accentLight;

    return CodePeekWrapper(
      componentCode: ComponentCodes.timelineItem,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.paddingAllMd,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with date and current badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                  child: Text(
                    experience.dateRange,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
                if (experience.isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
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
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Company name
            Text(
              experience.company,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xxs),
            // Role
            Text(
              experience.role,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            // Description
            Expanded(
              child: Text(
                experience.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Achievements preview (first 2)
            ...experience.achievements.take(2).map((achievement) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        achievement,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
