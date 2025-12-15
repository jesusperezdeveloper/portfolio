import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// Header component for the code viewer panel.
///
/// Displays:
/// - File tabs for switching between related files
/// - Current file path with folder icon
/// - Language badge (Dart/Flutter)
/// - Action buttons: Copy, GitHub, Close
class CodeHeader extends StatelessWidget {
  const CodeHeader({
    this.onClose,
    super.key,
  });

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeViewerCubit, CodeViewerState>(
      builder: (context, state) {
        if (state is! CodeViewerOpen && state is! CodeViewerCopied) {
          return const SizedBox.shrink();
        }

        final openState =
            state is CodeViewerCopied ? state.previousState : state as CodeViewerOpen;
        final isCopied = state is CodeViewerCopied;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top row: File tabs and actions
              Row(
                children: [
                  // File tabs
                  Expanded(
                    child: _buildFileTabs(context, openState),
                  ),
                  // Actions
                  _buildActions(context, openState, isCopied),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Bottom row: File path and language badge
              Row(
                children: [
                  // File path
                  Expanded(
                    child: _buildFilePath(openState),
                  ),
                  // Language badge
                  _buildLanguageBadge(openState),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileTabs(BuildContext context, CodeViewerOpen state) {
    final cubit = context.read<CodeViewerCubit>();
    final files = state.allFiles;

    if (files.length <= 1) {
      // Single file - just show filename
      return Row(
        children: [
          const Icon(
            Icons.description_outlined,
            size: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            state.activeSourceCode.fileName,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    // Multiple files - show tabs
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(files.length, (index) {
          final file = files[index];
          final isActive = index == state.activeFileIndex;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: _FileTab(
              fileName: file.fileName,
              isActive: isActive,
              onTap: () => cubit.switchFile(index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    CodeViewerOpen state,
    bool isCopied,
  ) {
    final cubit = context.read<CodeViewerCubit>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Skip animation button (only during typing)
        if (!state.isTypingComplete)
          _ActionButton(
            icon: Icons.skip_next_rounded,
            tooltip: 'Skip Animation',
            onTap: cubit.skipAnimation,
          ),
        // Copy button
        _ActionButton(
          icon: isCopied ? Icons.check_rounded : Icons.copy_rounded,
          tooltip: isCopied ? 'Copied!' : 'Copy Code',
          isHighlighted: isCopied,
          onTap: isCopied ? null : cubit.copyCode,
        ),
        // GitHub button
        if (state.activeSourceCode.githubUrl != null)
          _ActionButton(
            icon: Icons.open_in_new_rounded,
            tooltip: 'View on GitHub',
            onTap: () => _openGitHub(state.activeSourceCode.githubUrl!),
          ),
        // Close button
        _ActionButton(
          icon: Icons.close_rounded,
          tooltip: 'Close',
          onTap: onClose ?? cubit.closeViewer,
        ),
      ],
    );
  }

  Widget _buildFilePath(CodeViewerOpen state) {
    return Row(
      children: [
        Icon(
          Icons.folder_outlined,
          size: 14,
          color: Colors.white.withValues(alpha: 0.5),
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            state.activeSourceCode.filePath,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontFamily: 'JetBrainsMono',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageBadge(CodeViewerOpen state) {
    final language = state.activeSourceCode.language.toUpperCase();
    final isFlutter = language == 'DART' || language == 'FLUTTER';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isFlutter
            ? AppColors.accent.withValues(alpha: 0.2)
            : AppColors.secondaryStart.withValues(alpha: 0.2),
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: isFlutter
              ? AppColors.accent.withValues(alpha: 0.3)
              : AppColors.secondaryStart.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFlutter) ...[
            const Icon(
              Icons.flutter_dash,
              size: 12,
              color: AppColors.accent,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            language,
            style: TextStyle(
              color: isFlutter ? AppColors.accent : AppColors.secondaryStart,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGitHub(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// A single file tab widget.
class _FileTab extends StatefulWidget {
  const _FileTab({
    required this.fileName,
    required this.isActive,
    required this.onTap,
  });

  final String fileName;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_FileTab> createState() => _FileTabState();
}

class _FileTabState extends State<_FileTab> {
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
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.accent.withValues(alpha: 0.2)
                : _isHovered
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.transparent,
            borderRadius: AppSpacing.borderRadiusSm,
            border: Border.all(
              color: widget.isActive
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 14,
                color: widget.isActive
                    ? AppColors.accent
                    : Colors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                widget.fileName,
                style: TextStyle(
                  color: widget.isActive
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: widget.isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single action button in the header.
class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.isHighlighted = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool isHighlighted;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(left: AppSpacing.xs),
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: widget.isHighlighted
                  ? AppColors.success.withValues(alpha: 0.2)
                  : _isHovered
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: widget.isHighlighted
                  ? AppColors.success
                  : _isHovered
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.7),
            ),
          )
              .animate(target: widget.isHighlighted ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2))
              .then()
              .scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1)),
        ),
      ),
    );
  }
}
