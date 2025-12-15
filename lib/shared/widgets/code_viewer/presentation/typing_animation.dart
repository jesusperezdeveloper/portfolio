import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/utils/syntax_highlighter.dart';

/// A widget that displays code with a typing animation effect.
///
/// Characters are revealed progressively from left to right, top to bottom,
/// with a blinking cursor at the end during the animation.
class TypingAnimation extends StatefulWidget {
  const TypingAnimation({
    required this.code,
    required this.isComplete,
    this.charactersPerFrame = 50,
    this.frameInterval = const Duration(milliseconds: 16),
    this.fontSize = 14,
    this.lineHeight = 1.5,
    this.showCursor = true,
    this.onComplete,
    super.key,
  });

  /// The full code to display.
  final String code;

  /// Whether the animation is complete (show all code).
  final bool isComplete;

  /// Number of characters to reveal per frame.
  final int charactersPerFrame;

  /// Time between animation frames.
  final Duration frameInterval;

  /// Font size for the code text.
  final double fontSize;

  /// Line height multiplier.
  final double lineHeight;

  /// Whether to show the blinking cursor during animation.
  final bool showCursor;

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;
  int _visibleCharacters = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    if (!widget.isComplete) {
      _startAnimation();
    } else {
      _visibleCharacters = widget.code.length;
    }
  }

  @override
  void didUpdateWidget(TypingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If code changed, restart animation
    if (oldWidget.code != widget.code) {
      _visibleCharacters = 0;
      if (!widget.isComplete) {
        _startAnimation();
      } else {
        setState(() {
          _visibleCharacters = widget.code.length;
        });
      }
    }

    // If completed externally (skip button), show all
    if (!oldWidget.isComplete && widget.isComplete) {
      setState(() {
        _isAnimating = false;
        _visibleCharacters = widget.code.length;
      });
    }
  }

  void _startAnimation() {
    if (_isAnimating) return;
    _isAnimating = true;
    _animateNextFrame();
  }

  void _animateNextFrame() {
    if (!mounted || !_isAnimating) return;

    setState(() {
      _visibleCharacters += widget.charactersPerFrame;
      if (_visibleCharacters >= widget.code.length) {
        _visibleCharacters = widget.code.length;
        _isAnimating = false;
        widget.onComplete?.call();

        // Notify cubit of completion
        try {
          context.read<CodeViewerCubit>().completeTyping();
        } catch (_) {
          // Cubit might not be available in all contexts
        }
      }
    });

    if (_isAnimating) {
      Future.delayed(widget.frameInterval, _animateNextFrame);
    }
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _isAnimating = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleCode = widget.code.substring(
      0,
      _visibleCharacters.clamp(0, widget.code.length),
    );

    final spans = SyntaxHighlighter.highlight(visibleCode);

    // Add blinking cursor if animating
    final showCursor = widget.showCursor && _isAnimating;

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: widget.fontSize,
          height: widget.lineHeight,
        ),
        children: [
          ...spans,
          if (showCursor)
            WidgetSpan(
              child: AnimatedBuilder(
                animation: _cursorController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _cursorController.value,
                    child: Container(
                      width: 2,
                      height: widget.fontSize * widget.lineHeight,
                      color: const Color(0xFF00d4ff),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// A simpler version that just highlights code without animation.
class HighlightedCode extends StatelessWidget {
  const HighlightedCode({
    required this.code,
    this.fontSize = 14,
    this.lineHeight = 1.5,
    super.key,
  });

  /// The code to highlight.
  final String code;

  /// Font size for the code text.
  final double fontSize;

  /// Line height multiplier.
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: fontSize,
          height: lineHeight,
        ),
        children: SyntaxHighlighter.highlight(code),
      ),
    );
  }
}
