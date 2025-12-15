import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';

class ProjectCard3D extends StatefulWidget {
  const ProjectCard3D({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.techStack,
    this.role,
    this.onTap,
    this.onViewLive,
    this.onViewCode,
    this.width = 380,
    this.height,
    super.key,
  });

  final String title;
  final String description;
  final String imageUrl;
  final List<String> techStack;
  final String? role;
  final VoidCallback? onTap;
  final VoidCallback? onViewLive;
  final VoidCallback? onViewCode;
  final double width;
  final double? height;

  @override
  State<ProjectCard3D> createState() => _ProjectCard3DState();
}

class _ProjectCard3DState extends State<ProjectCard3D> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  static const double _defaultHeight = 480;

  double get _effectiveHeight => widget.height ?? _defaultHeight;

  double get _rotateX {
    if (!_isHovered) return 0;
    final centerY = _effectiveHeight / 2;
    return ((_mousePosition.dy - centerY) / centerY) * -0.1;
  }

  double get _rotateY {
    if (!_isHovered) return 0;
    final centerX = widget.width / 2;
    return ((_mousePosition.dx - centerX) / centerX) * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _mousePosition = Offset.zero;
      }),
      onHover: (event) {
        setState(() {
          _mousePosition = event.localPosition;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: _effectiveHeight,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(_rotateX)
            ..rotateY(_rotateY)
            ..setEntry(0, 0, _isHovered ? 1.02 : 1.0)
            ..setEntry(1, 1, _isHovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusXl,
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? AppColors.accent.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                  blurRadius: _isHovered ? 40 : 20,
                  offset: Offset(0, _isHovered ? 20 : 10),
                  spreadRadius: _isHovered ? 5 : 0,
                ),
              ],
              border: Border.all(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.5)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05)),
                width: _isHovered ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: AppSpacing.borderRadiusXl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section - altura fija para consistencia
                  SizedBox(
                    height: 200,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image placeholder o Network Image
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryDark,
                                AppColors.primaryLight,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: widget.imageUrl.isNotEmpty
                              ? Image.network(
                                  widget.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _buildImagePlaceholder(),
                                )
                              : _buildImagePlaceholder(),
                        ),
                        // Gradient overlay
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // Role badge
                        if (widget.role != null)
                          Positioned(
                            top: AppSpacing.md,
                            left: AppSpacing.md,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.9),
                                borderRadius: AppSpacing.borderRadiusFull,
                              ),
                              child: Text(
                                widget.role!,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        // Hover actions
                        if (_isHovered)
                          Positioned(
                            bottom: AppSpacing.md,
                            right: AppSpacing.md,
                            child: Row(
                              children: [
                                if (widget.onViewLive != null)
                                  _buildActionButton(
                                    icon: Icons.launch,
                                    onTap: widget.onViewLive!,
                                  ),
                                if (widget.onViewCode != null) ...[
                                  const SizedBox(width: AppSpacing.xs),
                                  _buildActionButton(
                                    icon: Icons.code,
                                    onTap: widget.onViewCode!,
                                  ),
                                ],
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 200.ms)
                              .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                  // Content Section - ocupa el resto del espacio
                  Expanded(
                    child: Padding(
                      padding: AppSpacing.paddingAllMd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              widget.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                    height: 1.5,
                                  ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Tech stack badges
                          Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            children: widget.techStack
                                .take(4)
                                .map((tech) => _buildTechBadge(tech, isDark))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.code,
        size: 64,
        color: AppColors.accent.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusFull,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }

  Widget _buildTechBadge(String tech, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.accent.withValues(alpha: 0.15)
            : AppColors.accent.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        tech,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
