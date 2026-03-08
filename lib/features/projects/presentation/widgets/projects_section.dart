import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/data/projects_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  late final PageController _pageController;
  int _currentPage = 1;
  bool _hasAnimated = false;

  List<ProjectData> get _projects => ProjectsData.featuredProjects;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.35,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return VisibilityDetector(
      key: const Key('projects-section-visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_hasAnimated) {
          setState(() => _hasAnimated = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        padding: EdgeInsets.symmetric(
          vertical: Responsive.value(
            context,
            mobile: 80,
            tablet: 100,
            desktop: 120,
          ),
        ),
        child: Column(
          children: [
            // Section Header
            _buildSectionHeader(context, isDark),
            SizedBox(
              height: Responsive.value<double>(
                context,
                mobile: 48,
                desktop: 64,
              ),
            ),
            // Carousel / Cards
            if (isMobile)
              _buildMobileCarousel(context, isDark)
            else
              _buildDesktopCarousel(context, isDark),
            const SizedBox(height: 40),
            // Dot Indicators
            _buildDotIndicators(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // "FEATURED WORK" label
        if (_hasAnimated)
          Text(
            'FEATURED WORK',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
              color: isDark ? AppColors.accent : AppColors.accentLight,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .slideY(begin: -0.3, end: 0),
        const SizedBox(height: 16),
        // Title
        if (_hasAnimated)
          Text(
            l10n.projectsTitle,
            style: TextStyle(
              fontSize: Responsive.value<double>(
                context,
                mobile: 36,
                desktop: 48,
              ),
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              height: 1.2,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 20),
        // Gradient separator line
        if (_hasAnimated)
          Container(
            width: 80,
            height: 3,
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusFull,
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.accent, AppColors.secondaryEnd]
                    : [AppColors.accentLight, AppColors.secondaryStart],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .scaleX(begin: 0, end: 1, alignment: Alignment.center),
      ],
    );
  }

  Widget _buildMobileCarousel(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.85).clamp(300.0, 380.0);

    return SizedBox(
      height: 540,
      child: PageView.builder(
        controller: PageController(
          initialPage: _currentPage,
          viewportFraction: 0.88,
        ),
        onPageChanged: _onPageChanged,
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          final isActive = index == _currentPage;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: isActive ? 1.0 : 0.6,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 400),
              scale: isActive ? 1.0 : 0.95,
              child: _ProjectCard(
                project: project,
                title: l10n.translate(project.titleKey),
                description: l10n.translate(project.descriptionKey),
                isActive: isActive,
                isDark: isDark,
                width: cardWidth,
                onViewLive: project.liveUrl != null
                    ? () => _launchUrl(project.liveUrl!)
                    : null,
                onViewCode: project.codeUrl != null
                    ? () => _launchUrl(project.codeUrl!)
                    : null,
                hasAnimated: _hasAnimated,
                animationDelay: index * 150,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopCarousel(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 540,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0;
              if (_pageController.position.haveDimensions) {
                value = (index - (_pageController.page ?? _currentPage.toDouble()))
                    .clamp(-1.0, 1.0);
              }

              final isActive = value.abs() < 0.5;
              final scale = 1.0 - (value.abs() * 0.05);
              final opacity = (1.0 - (value.abs() * 0.4)).clamp(0.0, 1.0);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: _ProjectCard(
                    project: project,
                    title: l10n.translate(project.titleKey),
                    description: l10n.translate(project.descriptionKey),
                    isActive: isActive,
                    isDark: isDark,
                    width: 380,
                    onViewLive: project.liveUrl != null
                        ? () => _launchUrl(project.liveUrl!)
                        : null,
                    onViewCode: project.codeUrl != null
                        ? () => _launchUrl(project.codeUrl!)
                        : null,
                    hasAnimated: _hasAnimated,
                    animationDelay: index * 150,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDotIndicators(bool isDark) {
    if (!_hasAnimated) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_projects.length, (index) {
        final isActive = index == _currentPage;
        return GestureDetector(
          onTap: () => _goToPage(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 32 : 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusFull,
              color: isActive
                  ? (isDark ? AppColors.accent : AppColors.accentLight)
                  : (isDark
                      ? AppColors.textMutedDark.withValues(alpha: 0.3)
                      : AppColors.textMutedLight.withValues(alpha: 0.3)),
            ),
          ),
        );
      }),
    ).animate().fadeIn(duration: 500.ms, delay: 600.ms);
  }
}

// ---------------------------------------------------------------------------
// _ProjectCard
// ---------------------------------------------------------------------------
class _ProjectCard extends StatefulWidget {
  const _ProjectCard({
    required this.project,
    required this.title,
    required this.description,
    required this.isActive,
    required this.isDark,
    required this.width,
    required this.hasAnimated,
    required this.animationDelay,
    this.onViewLive,
    this.onViewCode,
  });

  final ProjectData project;
  final String title;
  final String description;
  final bool isActive;
  final bool isDark;
  final double width;
  final bool hasAnimated;
  final int animationDelay;
  final VoidCallback? onViewLive;
  final VoidCallback? onViewCode;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;
  double _mouseX = 0;
  double _mouseY = 0;

  // Gradient colors per project
  static const _projectGradients = [
    [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF42A5F5)],
    [Color(0xFF4A148C), Color(0xFF6A1B9A), Color(0xFFAB47BC)],
    [Color(0xFFB71C1C), Color(0xFFD32F2F), Color(0xFFEF5350)],
  ];

  List<Color> get _gradientColors {
    final idx = ProjectsData.featuredProjects.indexOf(widget.project);
    if (idx >= 0 && idx < _projectGradients.length) {
      return _projectGradients[idx];
    }
    return _projectGradients[0];
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasAnimated) {
      return Opacity(opacity: 0, child: _buildCard());
    }

    return _buildCard()
        .animate()
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: widget.animationDelay + 300),
        )
        .slideY(
          begin: 0.15,
          end: 0,
          duration: 600.ms,
          delay: Duration(milliseconds: widget.animationDelay + 300),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildCard() {
    // Compute tilt angles based on mouse position
    final rotateX = _isHovered ? (_mouseY - 0.5) * -15 * (math.pi / 180) : 0.0;
    final rotateY = _isHovered ? (_mouseX - 0.5) * 15 * (math.pi / 180) : 0.0;

    final accentColor =
        widget.isDark ? AppColors.accent : AppColors.accentLight;

    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _mouseX = 0.5;
          _mouseY = 0.5;
        }),
        onHover: (event) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final local = box.globalToLocal(event.position);
            setState(() {
              _mouseX = (local.dx / box.size.width).clamp(0.0, 1.0);
              _mouseY = (local.dy / box.size.height).clamp(0.0, 1.0);
            });
          }
        },
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          offset: Offset(0, _isHovered ? -0.02 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: widget.width,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(rotateX)
              ..rotateY(rotateY),
            transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: widget.isActive
                  ? accentColor.withValues(alpha: 0.6)
                  : (_isHovered
                      ? accentColor.withValues(alpha: 0.3)
                      : (widget.isDark
                          ? AppColors.cardBorderDark
                          : AppColors.cardBorderLight)),
              width: widget.isActive ? 1.5 : 1,
            ),
            boxShadow: [
              if (widget.isActive)
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.25),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              if (_isHovered && !widget.isActive)
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 24,
                  spreadRadius: 1,
                ),
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: widget.isDark ? 0.4 : 0.08,
                ),
                blurRadius: _isHovered ? 24 : 16,
                offset: Offset(0, _isHovered ? 12 : 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageArea(accentColor),
                Expanded(child: _buildContent(accentColor)),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea(Color accentColor) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Project icon / initial
          Center(
            child: Text(
              widget.title.isNotEmpty ? widget.title[0] : '',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          // Role badge pill
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: AppSpacing.borderRadiusFull,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                widget.project.role,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Color accentColor) {
    final techStack = widget.project.techStack.take(4).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: widget.isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 14,
              color: widget.isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // Tech stack badges
          _buildTechBadges(techStack, accentColor),
          const Spacer(),
          // Action buttons
          _buildActionButtons(accentColor),
        ],
      ),
    );
  }

  Widget _buildTechBadges(List<String> techStack, Color accentColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: techStack.asMap().entries.map((entry) {
        final index = entry.key;
        final tech = entry.value;

        Widget badge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: widget.isDark
                ? accentColor.withValues(alpha: 0.1)
                : accentColor.withValues(alpha: 0.08),
            borderRadius: AppSpacing.borderRadiusFull,
            border: Border.all(
              color: accentColor.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            tech,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accentColor,
              letterSpacing: 0.3,
            ),
          ),
        );

        // Stagger pop-in on hover
        if (_isHovered && widget.hasAnimated) {
          badge = badge
              .animate(
                key: ValueKey('tech-$tech-hover'),
              )
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 300.ms,
                delay: Duration(milliseconds: index * 60),
                curve: Curves.easeOutBack,
              );
        }

        return badge;
      }).toList(),
    );
  }

  Widget _buildActionButtons(Color accentColor) {
    return Row(
      children: [
        if (widget.onViewLive != null)
          Expanded(
            child: _ActionButton(
              label: 'View Live',
              icon: Icons.launch_rounded,
              isPrimary: true,
              accentColor: accentColor,
              isDark: widget.isDark,
              onTap: widget.onViewLive!,
            ),
          ),
        if (widget.onViewLive != null && widget.onViewCode != null)
          const SizedBox(width: 10),
        if (widget.onViewCode != null)
          Expanded(
            child: _ActionButton(
              label: 'View Code',
              icon: Icons.code_rounded,
              isPrimary: false,
              accentColor: accentColor,
              isDark: widget.isDark,
              onTap: widget.onViewCode!,
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _ActionButton
// ---------------------------------------------------------------------------
class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.accentColor,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered
                    ? widget.accentColor
                    : widget.accentColor.withValues(alpha: 0.15))
                : (_isHovered
                    ? (widget.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05))
                    : Colors.transparent),
            borderRadius: AppSpacing.borderRadiusSm,
            border: Border.all(
              color: widget.isPrimary
                  ? widget.accentColor.withValues(alpha: _isHovered ? 1.0 : 0.4)
                  : (widget.isDark
                      ? AppColors.cardBorderDark
                      : AppColors.cardBorderLight),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: widget.isPrimary
                    ? (_isHovered
                        ? Colors.white
                        : widget.accentColor)
                    : (widget.isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isPrimary
                        ? (_isHovered
                            ? Colors.white
                            : widget.accentColor)
                        : (widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
