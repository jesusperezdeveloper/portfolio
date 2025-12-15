import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/data/skills_data.dart';
import 'package:portfolio_jps/shared/widgets/section_wrapper.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      sectionId: 'skills',
      title: l10n.skillsTitle,
      subtitle: l10n.skillsSubtitle,
      child: Column(
        children: [
          // Category Tabs
          _buildCategoryTabs(context, l10n, isDark),
          const SizedBox(height: AppSpacing.xl),
          // Skills Grid
          _buildSkillsGrid(context, isDark, isMobile),
        ],
      ),
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

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _CategoryTab(
              label: l10n.translate(category.nameKey),
              icon: category.icon,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => setState(() => _selectedCategory = index),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillsGrid(BuildContext context, bool isDark, bool isMobile) {
    final category = SkillsData.categories[_selectedCategory];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Wrap(
        key: ValueKey(_selectedCategory),
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        alignment: WrapAlignment.center,
        children: category.skills.asMap().entries.map((entry) {
          final index = entry.key;
          final skill = entry.value;

          return _SkillCard(
            skill: skill,
            isDark: isDark,
            delay: index * 100,
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryTab extends StatefulWidget {
  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<_CategoryTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.accent
                : (_isHovered
                    ? AppColors.accent.withValues(alpha: 0.1)
                    : (widget.isDark
                        ? AppColors.cardDark
                        : AppColors.cardLight)),
            borderRadius: AppSpacing.borderRadiusFull,
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.accent
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
                    ? AppColors.primaryDark
                    : (widget.isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: widget.isSelected
                      ? AppColors.primaryDark
                      : (widget.isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  const _SkillCard({
    required this.skill,
    required this.isDark,
    required this.delay,
  });

  final SkillData skill;
  final bool isDark;
  final int delay;

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.skill.color ?? AppColors.accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        padding: AppSpacing.paddingAllMd,
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: _isHovered
                ? color.withValues(alpha: 0.5)
                : (widget.isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05)),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: _isHovered ? 0.2 : 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                widget.skill.icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Name
            Text(
              widget.skill.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            // Level indicator
            _buildLevelIndicator(color),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: widget.delay),
          duration: 400.ms,
        )
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          delay: Duration(milliseconds: widget.delay),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildLevelIndicator(Color color) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: AppSpacing.borderRadiusFull,
          child: LinearProgressIndicator(
            value: widget.skill.levelValue,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          _levelLabel(widget.skill.level),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _levelLabel(SkillLevel level) {
    return switch (level) {
      SkillLevel.beginner => 'Básico',
      SkillLevel.intermediate => 'Intermedio',
      SkillLevel.advanced => 'Avanzado',
      SkillLevel.expert => 'Experto',
    };
  }
}
