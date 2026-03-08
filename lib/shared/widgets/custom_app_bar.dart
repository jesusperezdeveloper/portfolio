import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/localization/locale_cubit.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/theme/theme_cubit.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart';

/// v2.0 AppBar with glassmorphism transition, gradient underline nav items,
/// and smooth scroll-driven opacity changes.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    this.onNavItemTap,
    this.scrollController,
    this.activeSection = 0,
    super.key,
  });

  final void Function(int index)? onNavItemTap;
  final ScrollController? scrollController;
  final int activeSection;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {
  double _scrollProgress = 0; // 0 = top, 1 = scrolled
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final offset = widget.scrollController?.offset ?? 0;
    final progress = (offset / 150).clamp(0.0, 1.0);
    if ((progress - _scrollProgress).abs() > 0.01) {
      setState(() => _scrollProgress = progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final blurAmount = _scrollProgress * 15;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: widget.preferredSize.height,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.backgroundDark
                    .withValues(alpha: _scrollProgress * 0.85)
                : AppColors.backgroundLight
                    .withValues(alpha: _scrollProgress * 0.9),
            border: Border(
              bottom: BorderSide(
                color: _scrollProgress > 0.5
                    ? (isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04))
                    : Colors.transparent,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
          ),
          child: Row(
            children: [
              _buildLogo(context),
              const Spacer(),
              if (!isMobile) ...[
                Flexible(child: _buildNavItems(context, l10n)),
                const SizedBox(width: AppSpacing.lg),
              ],
              _buildActions(context, isMobile),
              if (isMobile)
                IconButton(
                  onPressed: () => _showMobileMenu(context, l10n),
                  icon: const Icon(Icons.menu),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onNavItemTap?.call(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: AppColors.tripleAccentGradient,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: const Center(
                child: Text(
                  'JP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (!Responsive.isMobile(context)) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Jesús Pérez',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavItems(BuildContext context, AppLocalizations l10n) {
    final items = [
      l10n.navHome,
      l10n.navAbout,
      l10n.navProjects,
      l10n.navExperience,
      l10n.navSkills,
      l10n.navContact,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isHovered = _hoveredIndex == index;
          final isActive = widget.activeSection == index;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
            child: GestureDetector(
              onTap: () => widget.onNavItemTap?.call(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: isActive || isHovered
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? AppColors.accent
                                    : isHovered
                                        ? Colors.white
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: 0.6),
                              ) ??
                          const TextStyle(),
                      child: Text(title),
                    ),
                    const SizedBox(height: 4),
                    // Gradient underline — grows from center
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      width: isActive
                          ? 24
                          : isHovered
                              ? 16
                              : 0,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: isActive || isHovered
                            ? AppColors.tripleAccentGradient
                            : null,
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile) const DevModeToggle(),
        if (!isMobile) const SizedBox(width: AppSpacing.sm),
        _buildIconButton(
          context,
          icon: Icons.language,
          tooltip: context.isSpanish ? 'English' : 'Español',
          onTap: () => context.read<LocaleCubit>().toggleLocale(),
        ),
        if (!isMobile) const SizedBox(width: AppSpacing.xs),
        _buildIconButton(
          context,
          icon: context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          tooltip: context.isDarkMode ? 'Light mode' : 'Dark mode',
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderRadiusFull,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(icon, size: 22),
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context, AppLocalizations l10n) {
    final items = [
      l10n.navHome,
      l10n.navAbout,
      l10n.navProjects,
      l10n.navExperience,
      l10n.navSkills,
      l10n.navContact,
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...items.asMap().entries.map((entry) {
              final isActive = widget.activeSection == entry.key;
              return ListTile(
                leading: isActive
                    ? Container(
                        width: 4,
                        height: 24,
                        decoration: const BoxDecoration(
                          gradient: AppColors.tripleAccentGradient,
                          borderRadius: AppSpacing.borderRadiusFull,
                        ),
                      )
                    : const SizedBox(width: 4),
                title: Text(
                  entry.value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isActive ? AppColors.accent : null,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onNavItemTap?.call(entry.key);
                },
              );
            }),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
