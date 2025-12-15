import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart' show CodePeekWrapper;
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_state.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/presentation/code_peek_wrapper.dart' show CodePeekWrapper;

/// Toggle button for enabling/disabling Dev Mode.
///
/// Designed to be placed in the navbar. When Dev Mode is active,
/// components wrapped with [CodePeekWrapper] will show indicators
/// that allow viewing their source code.
class DevModeToggle extends StatefulWidget {
  const DevModeToggle({super.key});

  @override
  State<DevModeToggle> createState() => _DevModeToggleState();
}

class _DevModeToggleState extends State<DevModeToggle>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _pulseController.dispose();
    super.dispose();
  }

  void _showOverlay(BuildContext context, bool isEnabled) {
    _hideOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => _DevModeTooltipOverlay(
        link: _layerLink,
        isEnabled: isEnabled,
        onDismiss: _hideOverlay,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colors based on theme
    final defaultColor = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final hoverColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final borderDefaultColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : AppColors.textMutedLight.withValues(alpha: 0.3);
    final borderHoverColor = isDark
        ? Colors.white.withValues(alpha: 0.3)
        : AppColors.textSecondaryLight.withValues(alpha: 0.5);
    final hoverBgColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : AppColors.accentLight.withValues(alpha: 0.08);

    return BlocConsumer<DevModeCubit, DevModeState>(
      listener: (context, state) {
        if (state.isEnabled) {
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController..stop()
          ..reset();
        }
      },
      builder: (context, state) {
        final accentColor = isDark ? AppColors.accent : AppColors.accentLight;

        return CompositedTransformTarget(
          link: _layerLink,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _showOverlay(context, state.isEnabled);
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _hideOverlay();
            },
            child: GestureDetector(
              onTap: () => context.read<DevModeCubit>().toggle(),
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: state.isEnabled ? _pulseAnimation.value : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: state.isEnabled
                            ? accentColor.withValues(alpha: 0.2)
                            : (_isHovered ? hoverBgColor : Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.isEnabled
                              ? accentColor
                              : (_isHovered ? borderHoverColor : borderDefaultColor),
                          width: state.isEnabled ? 2 : 1,
                        ),
                        boxShadow: state.isEnabled
                            ? [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.code,
                            size: 18,
                            color: state.isEnabled
                                ? accentColor
                                : (_isHovered ? hoverColor : defaultColor),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'DEV',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: state.isEnabled
                                  ? accentColor
                                  : (_isHovered ? hoverColor : defaultColor),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Compact version of the Dev Mode toggle (just the icon).
class DevModeToggleCompact extends StatefulWidget {
  const DevModeToggleCompact({super.key});

  @override
  State<DevModeToggleCompact> createState() => _DevModeToggleCompactState();
}

class _DevModeToggleCompactState extends State<DevModeToggleCompact> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevModeCubit, DevModeState>(
      builder: (context, state) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Tooltip(
            message: state.isEnabled ? 'Disable Dev Mode' : 'Enable Dev Mode',
            child: IconButton(
              onPressed: () => context.read<DevModeCubit>().toggle(),
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: state.isEnabled
                      ? AppColors.accent.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: state.isEnabled
                        ? AppColors.accent
                        : (_isHovered
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.transparent),
                  ),
                ),
                child: Icon(
                  Icons.code,
                  color: state.isEnabled
                      ? AppColors.accent
                      : (_isHovered ? Colors.white : Colors.white70),
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom tooltip overlay for Dev Mode toggle with detailed description.
class _DevModeTooltipOverlay extends StatelessWidget {
  const _DevModeTooltipOverlay({
    required this.link,
    required this.isEnabled,
    required this.onDismiss,
  });

  final LayerLink link;
  final bool isEnabled;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 280,
      child: CompositedTransformFollower(
        link: link,
        targetAnchor: Alignment.bottomCenter,
        followerAnchor: Alignment.topCenter,
        offset: const Offset(0, 8),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isEnabled ? Icons.code_off : Icons.code,
                      color: AppColors.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEnabled ? 'Desactivar Dev Mode' : 'Activar Dev Mode',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isEnabled
                      ? 'Haz clic para desactivar el modo desarrollador y ocultar los indicadores de código.'
                      : 'Activa el modo desarrollador para explorar el código fuente de los principales componentes de esta web.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                if (!isEnabled) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: AppColors.accent.withValues(alpha: 0.8),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pasa el ratón sobre los componentes para ver su código',
                            style: TextStyle(
                              color: AppColors.accent.withValues(alpha: 0.9),
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
