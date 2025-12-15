import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_state.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/data/component_codes.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/models/component_code.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/utils/syntax_highlighter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modal overlay that displays the full source code of a component.
///
/// Shows when a component is selected in Dev Mode.
/// Features:
/// - Glassmorphism design
/// - Syntax highlighted code
/// - Copy to clipboard
/// - GitHub link
/// - Keyboard shortcuts (Escape to close)
class CodePeekModal extends StatefulWidget {
  const CodePeekModal({super.key});

  @override
  State<CodePeekModal> createState() => _CodePeekModalState();
}

class _CodePeekModalState extends State<CodePeekModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

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
      _close();
    }
  }

  Future<void> _close() async {
    await _animationController.reverse();
    if (mounted) {
      context.read<DevModeCubit>().clearSelection();
    }
  }

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  Future<void> _openGitHub(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<DevModeCubit, DevModeState>(
      builder: (context, state) {
        if (!state.hasSelection) {
          return const SizedBox.shrink();
        }

        final componentCode = ComponentCodes.getById(state.selectedComponentId!);
        if (componentCode == null) {
          return const SizedBox.shrink();
        }

        return KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  // Backdrop
                  GestureDetector(
                    onTap: _close,
                    child: ColoredBox(
                      color: Colors.black.withValues(
                        alpha: 0.6 * _fadeAnimation.value,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8 * _fadeAnimation.value,
                          sigmaY: 8 * _fadeAnimation.value,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                  // Modal
                  Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildModal(
                          context,
                          componentCode,
                          isMobile: isMobile,
                          maxWidth: isMobile ? screenSize.width - 32 : 800,
                          maxHeight: screenSize.height * 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildModal(
    BuildContext context,
    ComponentCode componentCode, {
    required bool isMobile,
    required double maxWidth,
    required double maxHeight,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.secondaryEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xFF0f0f19).withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl - 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl - 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(componentCode),
                Flexible(child: _buildCodeArea(componentCode)),
                _buildFooter(componentCode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ComponentCode componentCode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // Icon and title
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.secondaryEnd],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.code, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  componentCode.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (componentCode.description != null)
                  Text(
                    componentCode.description!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Close button
          IconButton(
            onPressed: _close,
            icon: const Icon(Icons.close, color: Colors.white70),
            tooltip: 'Close (Esc)',
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 100.ms, duration: 200.ms);
  }

  Widget _buildCodeArea(ComponentCode componentCode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        child: SelectableText.rich(
          TextSpan(
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 13,
              height: 1.6,
            ),
            children: SyntaxHighlighter.highlight(componentCode.code),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildFooter(ComponentCode componentCode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // File info
          Text(
            '${componentCode.lineCount} lines • ${componentCode.sizeLabel}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
          if (componentCode.filePath != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              '• ${componentCode.filePath}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          // Action buttons
          _buildActionButton(
            icon: _copied ? Icons.check : Icons.copy,
            label: _copied ? 'Copied!' : 'Copy',
            onPressed: () => _copyCode(componentCode.code),
            isAccent: _copied,
          ),
          if (componentCode.githubUrl != null) ...[
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              icon: Icons.open_in_new,
              label: 'GitHub',
              onPressed: () => _openGitHub(componentCode.githubUrl),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 200.ms);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isAccent = false,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
        color: isAccent ? AppColors.success : AppColors.accent,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isAccent ? AppColors.success : AppColors.accent,
          fontSize: 13,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        backgroundColor: (isAccent ? AppColors.success : AppColors.accent)
            .withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shows the CodePeekModal as an overlay.
void showCodePeekModal(BuildContext context) {
  final overlay = Overlay.of(context);
  final cubit = context.read<DevModeCubit>();
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: BlocListener<DevModeCubit, DevModeState>(
        listener: (context, state) {
          if (!state.hasSelection) {
            overlayEntry.remove();
          }
        },
        child: const Material(
          color: Colors.transparent,
          child: CodePeekModal(),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
