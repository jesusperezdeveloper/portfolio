import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_state.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/presentation/typing_animation.dart';

/// Displays source code with syntax highlighting, line numbers, and typing animation.
///
/// Features:
/// - Line numbers with subtle coloring
/// - Current line highlighting on hover
/// - Syntax highlighting using VS Code Dark+ theme
/// - Typing animation for code reveal
/// - Scrollable for long code
class CodeDisplay extends StatefulWidget {
  const CodeDisplay({
    this.fontSize = 14,
    this.lineHeight = 1.5,
    this.showLineNumbers = true,
    super.key,
  });

  /// Font size for code text.
  final double fontSize;

  /// Line height multiplier.
  final double lineHeight;

  /// Whether to show line numbers.
  final bool showLineNumbers;

  @override
  State<CodeDisplay> createState() => _CodeDisplayState();
}

class _CodeDisplayState extends State<CodeDisplay> {
  final ScrollController _scrollController = ScrollController();
  int? _hoveredLine;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeViewerCubit, CodeViewerState>(
      builder: (context, state) {
        if (state is! CodeViewerOpen && state is! CodeViewerCopied) {
          return const SizedBox.shrink();
        }

        final openState =
            state is CodeViewerCopied ? state.previousState : state as CodeViewerOpen;
        final code = openState.activeSourceCode.code;
        final lines = code.split('\n');
        final lineCount = lines.length;

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0f0f19),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Line numbers
                  if (widget.showLineNumbers) ...[
                    _buildLineNumbers(lineCount, lines),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  // Code content
                  Expanded(
                    child: _buildCodeContent(openState, lines),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineNumbers(int lineCount, List<String> lines) {
    final lineNumberWidth = lineCount.toString().length * 10.0 + 8;

    return SizedBox(
      width: lineNumberWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(lineCount, (index) {
          final lineNumber = index + 1;
          final isHovered = _hoveredLine == index;

          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredLine = index),
            onExit: (_) => setState(() => _hoveredLine = null),
            child: Container(
              height: widget.fontSize * widget.lineHeight,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              decoration: BoxDecoration(
                color: isHovered
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
              ),
              child: Text(
                '$lineNumber',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: widget.fontSize,
                  height: widget.lineHeight,
                  color: isHovered
                      ? const Color(0xFF6b7280)
                      : const Color(0xFF4a5568),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCodeContent(CodeViewerOpen state, List<String> lines) {
    return MouseRegion(
      onEnter: (_) {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(lines.length, (index) {
          final isHovered = _hoveredLine == index;

          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredLine = index),
            onExit: (_) => setState(() => _hoveredLine = null),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isHovered
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
              ),
              child: _buildLineContent(state, lines, index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLineContent(
    CodeViewerOpen state,
    List<String> lines,
    int lineIndex,
  ) {
    // Calculate character range for this line
    var charsBefore = 0;
    for (var i = 0; i < lineIndex; i++) {
      charsBefore += lines[i].length + 1; // +1 for newline
    }
    final lineStart = charsBefore;
    final lineEnd = lineStart + lines[lineIndex].length;
    final lineCode = lines[lineIndex];

    // If animation is complete, show full line
    if (state.isTypingComplete) {
      return HighlightedCode(
        code: lineCode.isEmpty ? ' ' : lineCode, // Preserve empty lines
        fontSize: widget.fontSize,
        lineHeight: widget.lineHeight,
      );
    }

    // During animation, calculate visible portion
    final visibleChars = state.visibleCharacters;

    if (visibleChars <= lineStart) {
      // Line not yet visible
      return SizedBox(height: widget.fontSize * widget.lineHeight);
    }

    if (visibleChars >= lineEnd) {
      // Line fully visible
      return HighlightedCode(
        code: lineCode.isEmpty ? ' ' : lineCode,
        fontSize: widget.fontSize,
        lineHeight: widget.lineHeight,
      );
    }

    // Partial line visible
    final visiblePortion = lineCode.substring(0, visibleChars - lineStart);
    final isLastVisibleLine = lineIndex == _getCurrentLineIndex(state);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HighlightedCode(
          code: visiblePortion,
          fontSize: widget.fontSize,
          lineHeight: widget.lineHeight,
        ),
        if (isLastVisibleLine) _buildCursor(),
      ],
    );
  }

  int _getCurrentLineIndex(CodeViewerOpen state) {
    final code = state.activeSourceCode.code;
    final visibleCode = code.substring(
      0,
      state.visibleCharacters.clamp(0, code.length),
    );
    return visibleCode.split('\n').length - 1;
  }

  Widget _buildCursor() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value * 2).clamp(0, 1) > 0.5 ? 1 : 0,
          child: Container(
            width: 2,
            height: widget.fontSize * widget.lineHeight,
            color: AppColors.accent,
          ),
        );
      },
    );
  }
}

/// A simpler code display without line-by-line interaction.
class SimpleCodeDisplay extends StatelessWidget {
  const SimpleCodeDisplay({
    required this.code,
    required this.isTypingComplete,
    this.fontSize = 14,
    this.lineHeight = 1.5,
    super.key,
  });

  final String code;
  final bool isTypingComplete;
  final double fontSize;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: Color(0xFF0f0f19),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: TypingAnimation(
          code: code,
          isComplete: isTypingComplete,
          fontSize: fontSize,
          lineHeight: lineHeight,
        ),
      ),
    );
  }
}
