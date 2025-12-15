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

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    this.onNavItemTap,
    this.scrollController,
    super.key,
  });

  final void Function(int index)? onNavItemTap;
  final ScrollController? scrollController;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isScrolled = false;
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
    final scrolled = (widget.scrollController?.offset ?? 0) > 50;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _isScrolled ? 10 : 0,
          sigmaY: _isScrolled ? 10 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.preferredSize.height,
          decoration: BoxDecoration(
            color: _isScrolled
                ? (isDark
                    ? AppColors.backgroundDark.withValues(alpha: 0.8)
                    : AppColors.backgroundLight.withValues(alpha: 0.8))
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: _isScrolled
                    ? (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05))
                    : Colors.transparent,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
          ),
          child: Row(
            children: [
              // Logo / Name
              _buildLogo(context),
              const Spacer(),
              // Navigation Items (Desktop)
              if (!isMobile) ...[
                Flexible(
                  child: _buildNavItems(context, l10n),
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              // Actions
              _buildActions(context, isMobile),
              // Mobile Menu Button
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
                gradient: AppColors.accentGradient,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: const Center(
                child: Text(
                  'JP',
                  style: TextStyle(
                    color: AppColors.primaryDark,
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

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
            child: GestureDetector(
              onTap: () => widget.onNavItemTap?.call(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isHovered
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                        color: isHovered
                            ? AppColors.accent
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
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
        // Dev Mode Toggle
        if (!isMobile) const DevModeToggle(),
        if (!isMobile) const SizedBox(width: AppSpacing.sm),
        // Language Toggle
        _buildIconButton(
          context,
          icon: Icons.language,
          tooltip: context.isSpanish ? 'English' : 'Español',
          onTap: () => context.read<LocaleCubit>().toggleLocale(),
        ),
        if (!isMobile) const SizedBox(width: AppSpacing.xs),
        // Theme Toggle
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
              return ListTile(
                title: Text(
                  entry.value,
                  style: Theme.of(context).textTheme.titleMedium,
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
