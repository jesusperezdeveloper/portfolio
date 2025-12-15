import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_state.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/presentation/code_display.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/presentation/code_footer.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/presentation/code_header.dart';

/// The main code viewer panel with glassmorphism effect.
///
/// Features:
/// - Slide up animation from bottom (mobile) or side (desktop)
/// - Glassmorphism background with blur
/// - Gradient border (cyan to purple)
/// - Keyboard shortcuts (Escape to close)
/// - Responsive: bottom sheet on mobile, side panel on desktop
class CodeViewerPanel extends StatefulWidget {
  const CodeViewerPanel({super.key});

  @override
  State<CodeViewerPanel> createState() => _CodeViewerPanelState();
}

class _CodeViewerPanelState extends State<CodeViewerPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Request focus for keyboard shortcuts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      context.read<CodeViewerCubit>().closeViewer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<CodeViewerCubit, CodeViewerState>(
      listener: (context, state) {
        if (state is CodeViewerOpening || state is CodeViewerOpen) {
          _animationController.forward();
        } else if (state is CodeViewerClosing) {
          _animationController.reverse();
        }
      },
      builder: (context, state) {
        final isVisible = state is CodeViewerOpening ||
            state is CodeViewerOpen ||
            state is CodeViewerCopied ||
            state is CodeViewerClosing;

        if (!isVisible) {
          return const SizedBox.shrink();
        }

        return KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: Stack(
            children: [
              // Backdrop
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: () => context.read<CodeViewerCubit>().closeViewer(),
                    child: ColoredBox(
                      color: Colors.black.withValues(
                        alpha: 0.5 * _fadeAnimation.value,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5 * _fadeAnimation.value,
                          sigmaY: 5 * _fadeAnimation.value,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  );
                },
              ),
              // Panel
              Positioned(
                left: isMobile || isTablet ? 0 : screenWidth * 0.1,
                right: isMobile || isTablet ? 0 : screenWidth * 0.1,
                bottom: 0,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildPanel(
                    context,
                    isMobile: isMobile,
                    maxHeight: screenHeight * 0.7,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanel(
    BuildContext context, {
    required bool isMobile,
    required double maxHeight,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        // Gradient border
        gradient: LinearGradient(
          colors: [
            AppColors.accent,
            AppColors.secondaryEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2), // Border width
        decoration: BoxDecoration(
          color: const Color(0xFF0f0f19).withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl - 2),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl - 2),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle (mobile)
                if (isMobile) _buildDragHandle(),
                // Header
                const CodeHeader()
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 200.ms),
                // Code display
                Flexible(
                  child: const CodeDisplay()
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 300.ms),
                ),
                // Footer
                const CodeFooter()
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      ),
    );
  }
}

/// Shows the code viewer panel as an overlay.
///
/// This function should be called when the user wants to view source code.
/// It creates an overlay entry with the CodeViewerPanel.
void showCodeViewerPanel(BuildContext context) {
  final overlay = Overlay.of(context);
  // Capture the cubit BEFORE creating the overlay entry
  final cubit = context.read<CodeViewerCubit>();
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: BlocListener<CodeViewerCubit, CodeViewerState>(
        listener: (context, state) {
          if (state is CodeViewerClosed) {
            overlayEntry.remove();
          }
        },
        child: const Material(
          color: Colors.transparent,
          child: CodeViewerPanel(),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
