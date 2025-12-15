import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_state.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/models/source_code_model.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/presentation/code_viewer_panel.dart';

/// A floating button that triggers the code viewer panel.
///
/// Features:
/// - Positioned at bottom-right of each section
/// - Code brackets icon with glow effect
/// - Pulse animation on idle
/// - Scale up on hover
/// - Opens the CodeViewerPanel when tapped
class CodeViewerButton extends StatefulWidget {
  const CodeViewerButton({
    required this.sourceCode,
    this.right = 24,
    this.bottom = 24,
    super.key,
  });

  /// The source code to display when the button is pressed.
  final SourceCodeModel sourceCode;

  /// Position from right edge.
  final double right;

  /// Position from bottom edge.
  final double bottom;

  @override
  State<CodeViewerButton> createState() => _CodeViewerButtonState();
}

class _CodeViewerButtonState extends State<CodeViewerButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTap() {
    context.read<CodeViewerCubit>().openViewer(widget.sourceCode);
    showCodeViewerPanel(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeViewerCubit, CodeViewerState>(
      builder: (context, state) {
        // Hide button when panel is open
        final isVisible = state is CodeViewerInitial || state is CodeViewerClosed;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isVisible ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: !isVisible,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _onTap,
                child: Tooltip(
                  message: 'View Source Code',
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final scale = _isHovered ? 1.15 : _pulseAnimation.value;
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: _buildButton(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _isHovered
            ? AppColors.accent.withValues(alpha: 0.3)
            : AppColors.backgroundDark.withValues(alpha: 0.8),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(
          color: _isHovered
              ? AppColors.accent
              : AppColors.accent.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: _isHovered ? 0.5 : 0.3),
            blurRadius: _isHovered ? 20 : 12,
            spreadRadius: _isHovered ? 2 : 0,
          ),
        ],
      ),
      child: Icon(
        Icons.code_rounded,
        color: _isHovered ? Colors.white : AppColors.accent,
        size: 24,
      ),
    )
        .animate(target: _isHovered ? 1 : 0)
        .shimmer(
          duration: 1.seconds,
          color: AppColors.accent.withValues(alpha: 0.3),
        );
  }
}

/// A wrapper widget that adds the CodeViewerButton to any section.
///
/// Usage:
/// ```dart
/// CodeViewerWrapper(
///   sourceCode: CodeSnippets.heroSection,
///   child: HeroSectionContent(),
/// )
/// ```
class CodeViewerWrapper extends StatelessWidget {
  const CodeViewerWrapper({
    required this.sourceCode,
    required this.child,
    this.buttonRight = 24,
    this.buttonBottom = 24,
    super.key,
  });

  /// The source code to display.
  final SourceCodeModel sourceCode;

  /// The section content to wrap.
  final Widget child;

  /// Position of button from right edge.
  final double buttonRight;

  /// Position of button from bottom edge.
  final double buttonBottom;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CodeViewerCubit(),
      child: Stack(
        children: [
          child,
          Positioned(
            right: buttonRight,
            bottom: buttonBottom,
            child: CodeViewerButton(
              sourceCode: sourceCode,
            ),
          ),
        ],
      ),
    );
  }
}
