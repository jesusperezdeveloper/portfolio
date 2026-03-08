import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/data/skills_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  int _selectedCategory = 0;
  String? _hoveredSkillName;
  bool _isVisible = false;

  /// Accent color per category for the active tab indicator.
  static const List<Color> _categoryAccentColors = [
    Color(0xFF0175C2), // Languages - Dart blue
    Color(0xFF02569B), // Frameworks - Flutter blue
    Color(0xFFF24E1E), // Tools - Figma orange
    Color(0xFF4285F4), // Cloud - Google blue
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verticalPadding = Responsive.value<double>(
      context,
      mobile: 80,
      desktop: 120,
    );
    final horizontalPadding = Responsive.horizontalPadding(context);

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                _buildSectionHeader(context, l10n, isDark),
                SizedBox(
                  height: Responsive.value<double>(
                    context,
                    mobile: AppSpacing.lg,
                    tablet: AppSpacing.xl,
                    desktop: AppSpacing.xxl,
                  ),
                ),
                // Category tabs
                _buildCategoryTabs(context, l10n, isDark),
                const SizedBox(height: AppSpacing.xl),
                // Skills grid with animated switcher
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildSkillsGrid(context, isDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    if (!_isVisible) {
      return Opacity(
        opacity: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.skillsTitle,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.skillsSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.skillsTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(
              begin: -0.1,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.skillsSubtitle,
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

  Widget _buildCategoryTabs(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: SkillsData.categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = _selectedCategory == index;
          final accentColor = _categoryAccentColors[index];

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _CategoryTab(
              label: l10n.translate(category.nameKey),
              icon: category.icon,
              isSelected: isSelected,
              isDark: isDark,
              accentColor: accentColor,
              onTap: () => setState(() {
                _selectedCategory = index;
                _hoveredSkillName = null;
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillsGrid(BuildContext context, bool isDark) {
    final category = SkillsData.categories[_selectedCategory];
    final columns = Responsive.value<int>(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
    const spacing = AppSpacing.md;
    final isDesktop = Responsive.isDesktop(context);

    return LayoutBuilder(
      key: ValueKey(_selectedCategory),
      builder: (context, constraints) {
        final totalSpacing = spacing * (columns - 1);
        final cardWidth =
            (constraints.maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: category.skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;

            // Determine opacity based on hover state
            var opacity = 1.0;
            if (isDesktop && _hoveredSkillName != null) {
              opacity = _hoveredSkillName == skill.name ? 1.0 : 0.4;
            }

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: opacity,
              child: SizedBox(
                width: cardWidth,
                child: _SkillCard(
                  skill: skill,
                  isDark: isDark,
                  staggerDelay: index * 80,
                  isVisible: _isVisible,
                  onHoverChanged: isDesktop
                      ? (isHovered) {
                          setState(() {
                            _hoveredSkillName =
                                isHovered ? skill.name : null;
                          });
                        }
                      : null,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// =============================================================================
// Category Tab
// =============================================================================

class _CategoryTab extends StatefulWidget {
  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<_CategoryTab>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.accentColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? activeColor.withValues(alpha: 0.15)
                    : (_isHovered
                        ? activeColor.withValues(alpha: 0.08)
                        : (widget.isDark
                            ? AppColors.cardDark
                            : AppColors.cardLight)),
                borderRadius: AppSpacing.borderRadiusFull,
                border: Border.all(
                  color: widget.isSelected
                      ? activeColor.withValues(alpha: 0.5)
                      : (widget.isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 18,
                    color: widget.isSelected
                        ? activeColor
                        : (widget.isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: widget.isSelected
                          ? activeColor
                          : (widget.isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Sliding pill indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: widget.isSelected ? 32 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Skill Card
// =============================================================================

class _SkillCard extends StatefulWidget {
  const _SkillCard({
    required this.skill,
    required this.isDark,
    required this.staggerDelay,
    required this.isVisible,
    this.onHoverChanged,
  });

  final SkillData skill;
  final bool isDark;
  final int staggerDelay;
  final bool isVisible;
  final ValueChanged<bool>? onHoverChanged;

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _hasAnimatedBar = false;
  bool _showShimmer = false;

  late final AnimationController _barController;
  late final Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _barAnimation = CurvedAnimation(
      parent: _barController,
      curve: Curves.easeOutCubic,
    );

    _barController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _showShimmer = true);
        // Hide shimmer after one sweep (~1s)
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            setState(() => _showShimmer = false);
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SkillCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger bar animation when section becomes visible
    if (widget.isVisible && !_hasAnimatedBar) {
      _hasAnimatedBar = true;
      Future.delayed(Duration(milliseconds: widget.staggerDelay + 200), () {
        if (mounted) {
          _barController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger on first build if already visible
    if (widget.isVisible && !_hasAnimatedBar) {
      _hasAnimatedBar = true;
      Future.delayed(Duration(milliseconds: widget.staggerDelay + 200), () {
        if (mounted) {
          _barController.forward();
        }
      });
    }

    final color = widget.skill.color ?? AppColors.accent;
    final levelLabel = _levelLabel(widget.skill.level);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHoverChanged?.call(true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onHoverChanged?.call(false);
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: AppSpacing.paddingAllMd,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: _isHovered
                  ? color.withValues(alpha: 0.6)
                  : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06)),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Icon container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: _isHovered ? 0.2 : 0.1),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  widget.skill.icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Name, level, and progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.skill.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          levelLabel,
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Animated progress bar
                    _buildProgressBar(color),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: widget.staggerDelay),
          duration: 400.ms,
        )
        .slideY(
          begin: 0.15,
          end: 0,
          delay: Duration(milliseconds: widget.staggerDelay),
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildProgressBar(Color color) {
    const double barHeight = 6;

    return SizedBox(
      height: barHeight,
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusFull,
        child: Stack(
          children: [
            // Background track
            Container(
              width: double.infinity,
              height: barHeight,
              color: color.withValues(alpha: 0.1),
            ),
            // Animated fill with gradient
            AnimatedBuilder(
              animation: _barAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor:
                      widget.skill.levelValue * _barAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.7),
                          color,
                        ],
                      ),
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                  ),
                );
              },
            ),
            // Shimmer overlay (one sweep after fill)
            if (_showShimmer)
              Positioned.fill(
                child: Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: Colors.white.withValues(alpha: 0.4),
                  period: const Duration(milliseconds: 1000),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _levelLabel(SkillLevel level) {
    final l10n = AppLocalizations.of(context);
    final isSpanish = l10n.locale.languageCode == 'es';

    return switch (level) {
      SkillLevel.beginner => isSpanish ? 'Basico' : 'Basic',
      SkillLevel.intermediate =>
        isSpanish ? 'Intermedio' : 'Intermediate',
      SkillLevel.advanced => isSpanish ? 'Avanzado' : 'Advanced',
      SkillLevel.expert => isSpanish ? 'Experto' : 'Expert',
    };
  }
}
