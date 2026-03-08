import 'dart:math';

import 'package:flutter/material.dart';

/// A text widget that reveals characters with a scramble/glitch effect.
/// Characters cycle through random symbols before resolving to the final text.
class TextScramble extends StatefulWidget {
  const TextScramble({
    required this.text,
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    this.animate = true,
    this.onComplete,
  });

  final String text;
  final TextStyle? style;
  final Duration duration;
  final bool animate;
  final VoidCallback? onComplete;

  @override
  State<TextScramble> createState() => _TextScrambleState();
}

class _TextScrambleState extends State<TextScramble>
    with SingleTickerProviderStateMixin {
  static const _chars = r'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&*<>{}[]';
  final _random = Random();
  late AnimationController _controller;
  String _displayText = '';
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _displayText = widget.animate ? '' : widget.text;
    _completed = !widget.animate;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.animate) {
      _startScramble();
    }
  }

  @override
  void didUpdateWidget(TextScramble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _startScramble();
    }
    if (widget.text != oldWidget.text) {
      _completed = false;
      _startScramble();
    }
  }

  void _startScramble() {
    _controller
      ..reset()
      ..forward()
      ..addListener(_updateText)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_completed) {
          _completed = true;
          if (mounted) {
            setState(() => _displayText = widget.text);
          }
          widget.onComplete?.call();
        }
      });
  }

  void _updateText() {
    if (!mounted) return;

    final progress = _controller.value;
    final text = widget.text;
    final resolvedCount = (progress * text.length).floor();
    final buffer = StringBuffer();

    for (var i = 0; i < text.length; i++) {
      if (i < resolvedCount) {
        buffer.write(text[i]);
      } else if (text[i] == ' ') {
        buffer.write(' ');
      } else {
        final distanceFromResolved = i - resolvedCount;
        if (distanceFromResolved < 3 && progress > 0.1) {
          buffer.write(
            _random.nextDouble() > 0.5 ? text[i] : _randomChar(),
          );
        } else {
          buffer.write(_randomChar());
        }
      }
    }

    setState(() => _displayText = buffer.toString());
  }

  String _randomChar() => _chars[_random.nextInt(_chars.length)];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
    );
  }
}
