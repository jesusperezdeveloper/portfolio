import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_state.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/models/component_code.dart';

/// Wrapper widget that adds Code Peek functionality to any component.
///
/// When Dev Mode is enabled:
/// - Shows a dotted border around the component on hover
/// - Displays a small `</>` icon indicator
/// - Shows a tooltip with component name on hover
/// - Opens a modal with full code on click
///
/// Usage:
/// ```dart
/// CodePeekWrapper(
///   componentCode: ComponentCodes.animatedButton,
///   child: AnimatedButton(
///     text: 'Contact Me',
///     onPressed: () {},
///   ),
/// )
/// ```
class CodePeekWrapper extends StatefulWidget {
  const CodePeekWrapper({
    required this.componentCode,
    required this.child,
    super.key,
  });

  /// The code information for this component.
  final ComponentCode componentCode;

  /// The child widget to wrap.
  final Widget child;

  @override
  State<CodePeekWrapper> createState() => _CodePeekWrapperState();
}

class _CodePeekWrapperState extends State<CodePeekWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevModeCubit, DevModeState>(
      builder: (context, state) {
        // If Dev Mode is off, just return the child
        if (!state.isEnabled) {
          return widget.child;
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              context.read<DevModeCubit>().selectComponent(
                    widget.componentCode.id,
                  );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // The actual component with animated border
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.accent.withValues(alpha: 0.6)
                          : AppColors.accent.withValues(alpha: 0.3),
                      width: _isHovered ? 2 : 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: widget.child,
                ),
                // Code indicator icon
                Positioned(
                  top: -8,
                  right: -8,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.7,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: _isHovered ? 1.1 : 1.0,
                      child: _buildCodeIndicator(),
                    ),
                  ),
                ),
                // Component name tooltip (on hover)
                if (_isHovered)
                  Positioned(
                    top: -28,
                    left: 0,
                    child: _buildTooltipLabel(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCodeIndicator() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.secondaryEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Icon(
        Icons.code,
        color: Colors.white,
        size: 14,
      ),
    );
  }

  Widget _buildTooltipLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.code,
            color: AppColors.accent,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            widget.componentCode.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
