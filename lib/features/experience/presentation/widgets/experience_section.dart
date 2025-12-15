import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/data/experience_data.dart';
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
    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;

        return _MobileTimelineItem(
          experience: experience,
          isFirst: index == 0,
          isLast: index == experiences.length - 1,
          delay: index * 200,
        );
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
    return MouseRegion(
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
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _MobileTimelineItem extends StatelessWidget {
  const _MobileTimelineItem({
    required this.experience,
    required this.isFirst,
    required this.isLast,
    required this.delay,
  });

  final ExperienceData experience;
  final bool isFirst;
  final bool isLast;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: experience.isCurrent
                        ? AppColors.accent
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: AppSpacing.paddingAllMd,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.dateRange,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    experience.company,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    experience.role,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.accent,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    experience.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 500.ms,
        )
        .slideX(
          begin: 0.2,
          end: 0,
          delay: Duration(milliseconds: delay),
          duration: 500.ms,
        );
  }
}
