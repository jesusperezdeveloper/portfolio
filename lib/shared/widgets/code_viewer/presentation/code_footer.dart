import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// Footer component for the code viewer panel.
///
/// Displays:
/// - Lines of code count
/// - File size
/// - Direct GitHub link
/// - Optional description
class CodeFooter extends StatelessWidget {
  const CodeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeViewerCubit, CodeViewerState>(
      builder: (context, state) {
        if (state is! CodeViewerOpen && state is! CodeViewerCopied) {
          return const SizedBox.shrink();
        }

        final openState =
            state is CodeViewerCopied ? state.previousState : state as CodeViewerOpen;
        final sourceCode = openState.activeSourceCode;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Description (if available)
              if (sourceCode.description != null) ...[
                Text(
                  sourceCode.description!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              // Stats row
              Row(
                children: [
                  // Lines count
                  _StatBadge(
                    icon: Icons.format_list_numbered_rounded,
                    value: '${sourceCode.lineCount} lines',
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // File size
                  _StatBadge(
                    icon: Icons.data_usage_rounded,
                    value: sourceCode.fileSizeFormatted,
                  ),
                  const Spacer(),
                  // GitHub link
                  if (sourceCode.githubUrl != null)
                    _GitHubLink(url: sourceCode.githubUrl!),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A single stat badge widget.
class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
  });

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ],
    );
  }
}

/// GitHub link button with hover effect.
class _GitHubLink extends StatefulWidget {
  const _GitHubLink({required this.url});

  final String url;

  @override
  State<_GitHubLink> createState() => _GitHubLinkState();
}

class _GitHubLinkState extends State<_GitHubLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _openGitHub,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: AppSpacing.borderRadiusSm,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code_rounded,
                size: 14,
                color: _isHovered
                    ? AppColors.accent
                    : Colors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                'View on GitHub',
                style: TextStyle(
                  color: _isHovered
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_outward_rounded,
                size: 12,
                color: _isHovered
                    ? AppColors.accent
                    : Colors.white.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGitHub() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
