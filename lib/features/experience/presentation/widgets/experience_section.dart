import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/data/experience_data.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Cinematic vertical timeline section for professional experience.
///
/// Desktop: centered vertical line with alternating left/right cards.
/// Mobile: line on the left, all cards on the right.
class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _sectionVisible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verticalPadding = isMobile ? 80.0 : 120.0;

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05 && !_sectionVisible) {
          setState(() => _sectionVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: Responsive.horizontalPadding(context),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: l10n.experienceTitle,
                  subtitle: l10n.experienceSubtitle,
                  isVisible: _sectionVisible,
                  isDark: isDark,
                ),
                SizedBox(
                  height: Responsive.value(
                    context,
                    mobile: AppSpacing.lg,
                    tablet: AppSpacing.xl,
                    desktop: AppSpacing.xxl,
                  ),
                ),
                if (_sectionVisible)
                  _ExperienceTimeline(isMobile: isMobile, isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header with animated title + subtitle
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.isVisible,
    required this.isDark,
  });

  final String title;
  final String subtitle;
  final bool isVisible;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Opacity(
        opacity: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),),
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(begin: -0.1, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.6),
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                duration: 500.ms,
                delay: 100.ms,
                curve: Curves.easeOutCubic,
              ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline layout — orchestrates the vertical line + cards
// ---------------------------------------------------------------------------

class _ExperienceTimeline extends StatelessWidget {
  const _ExperienceTimeline({
    required this.isMobile,
    required this.isDark,
  });

  final bool isMobile;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final experiences = ExperiencesData.experiences;

    return Column(
      children: List.generate(experiences.length, (index) {
        final experience = experiences[index];
        final isLeft = index.isEven;
        final isFirst = index == 0;
        final isLast = index == experiences.length - 1;
        final staggerDelay = index * 150;

        if (isMobile) {
          return _MobileTimelineItem(
            experience: experience,
            isFirst: isFirst,
            isLast: isLast,
            isDark: isDark,
            staggerDelay: staggerDelay,
          );
        }

        return _DesktopTimelineItem(
          experience: experience,
          isLeft: isLeft,
          isFirst: isFirst,
          isLast: isLast,
          isDark: isDark,
          staggerDelay: staggerDelay,
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop: alternating left-right timeline item
// ---------------------------------------------------------------------------

class _DesktopTimelineItem extends StatelessWidget {
  const _DesktopTimelineItem({
    required this.experience,
    required this.isLeft,
    required this.isFirst,
    required this.isLast,
    required this.isDark,
    required this.staggerDelay,
  });

  final ExperienceData experience;
  final bool isLeft;
  final bool isFirst;
  final bool isLast;
  final bool isDark;
  final int staggerDelay;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left content or spacer
          Expanded(
            child: isLeft
                ? _buildCardWrapper(context)
                : const SizedBox.shrink(),
          ),
          // Central timeline column
          _TimelineNode(
            isFirst: isFirst,
            isLast: isLast,
            isDark: isDark,
            staggerDelay: staggerDelay,
          ),
          // Right content or spacer
          Expanded(
            child: isLeft
                ? const SizedBox.shrink()
                : _buildCardWrapper(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isLeft ? 0 : AppSpacing.lg,
        right: isLeft ? AppSpacing.lg : 0,
        bottom: AppSpacing.xl,
      ),
      child: _ExperienceCard(
        experience: experience,
        isDark: isDark,
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: staggerDelay),
          duration: 500.ms,
        )
        .slideX(
          begin: isLeft ? -0.08 : 0.08,
          end: 0,
          delay: Duration(milliseconds: staggerDelay),
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

// ---------------------------------------------------------------------------
// Mobile: line on the left, card on the right
// ---------------------------------------------------------------------------

class _MobileTimelineItem extends StatelessWidget {
  const _MobileTimelineItem({
    required this.experience,
    required this.isFirst,
    required this.isLast,
    required this.isDark,
    required this.staggerDelay,
  });

  final ExperienceData experience;
  final bool isFirst;
  final bool isLast;
  final bool isDark;
  final int staggerDelay;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline on the left (24px from edge)
          _TimelineNode(
            isFirst: isFirst,
            isLast: isLast,
            isDark: isDark,
            staggerDelay: staggerDelay,
            nodeSize: 12,
            lineWidth: 40,
          ),
          // Card on the right
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.lg,
              ),
              child: _ExperienceCard(
                experience: experience,
                isDark: isDark,
                compact: true,
              ),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: staggerDelay),
                  duration: 500.ms,
                )
                .slideX(
                  begin: 0.08,
                  end: 0,
                  delay: Duration(milliseconds: staggerDelay),
                  duration: 500.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline node: vertical line segment + glowing circle
// ---------------------------------------------------------------------------

class _TimelineNode extends StatefulWidget {
  const _TimelineNode({
    required this.isFirst,
    required this.isLast,
    required this.isDark,
    required this.staggerDelay,
    this.nodeSize = 16,
    this.lineWidth = 60,
  });

  final bool isFirst;
  final bool isLast;
  final bool isDark;
  final int staggerDelay;
  final double nodeSize;
  final double lineWidth;

  @override
  State<_TimelineNode> createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<_TimelineNode> {
  bool _glowing = false;

  @override
  void initState() {
    super.initState();
    // Trigger glow after the stagger delay
    Future.delayed(Duration(milliseconds: widget.staggerDelay + 200), () {
      if (mounted) {
        setState(() => _glowing = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor =
        widget.isDark ? AppColors.accent : AppColors.accentLight;
    final lineColor = accentColor.withValues(alpha: 0.25);

    return SizedBox(
      width: widget.lineWidth,
      child: Column(
        children: [
          // Top line segment
          if (!widget.isFirst)
            Expanded(
              child: Center(
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        lineColor,
                        accentColor.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        accentColor.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Circle node
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            width: widget.nodeSize,
            height: widget.nodeSize,
            decoration: BoxDecoration(
              color: widget.isDark
                  ? const Color(0xFF14142b)
                  : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor,
                width: 2,
              ),
              boxShadow: _glowing
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),

          // Bottom line segment
          if (!widget.isLast)
            Expanded(
              child: Center(
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        accentColor.withValues(alpha: 0.5),
                        lineColor,
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        accentColor.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Experience card: glass-style with hover effect
// ---------------------------------------------------------------------------

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({
    required this.experience,
    required this.isDark,
    this.compact = false,
  });

  final ExperienceData experience;
  final bool isDark;
  final bool compact;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accentColor =
        widget.isDark ? AppColors.accent : AppColors.accentLight;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: widget.compact ? AppSpacing.paddingAllMd : AppSpacing.paddingAllLg,
        decoration: BoxDecoration(
          color: widget.isDark
              ? const Color(0xFF14142b)
              : Colors.white,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: _isHovered
                ? accentColor.withValues(alpha: 0.4)
                : (widget.isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.06)),
          ),
          boxShadow: widget.isDark
              ? (_isHovered
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null)
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isHovered ? 0.1 : 0.05),
                    blurRadius: _isHovered ? 24 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company name
            Text(
              widget.experience.company,
              style: TextStyle(
                fontSize: widget.compact ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: widget.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),

            // Role
            Text(
              widget.experience.role,
              style: TextStyle(
                fontSize: widget.compact ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Date range badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.experience.isCurrent) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    widget.experience.dateRange,
                    style: TextStyle(
                      fontSize: widget.compact ? 11 : 14,
                      fontWeight: FontWeight.w500,
                      color: widget.isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Description
            Text(
              widget.experience.description,
              style: TextStyle(
                fontSize: widget.compact ? 13 : 14,
                height: 1.6,
                color: widget.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Achievements bullet list
            ...widget.experience.achievements.map((achievement) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: widget.compact ? 14 : 16,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        achievement,
                        style: TextStyle(
                          fontSize: widget.compact ? 12 : 13,
                          height: 1.5,
                          color: widget.isDark
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
    );
  }
}
