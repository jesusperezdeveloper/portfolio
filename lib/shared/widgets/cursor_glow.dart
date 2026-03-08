import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';

/// A widget that renders a subtle glow trail following the mouse cursor.
///
/// On desktop viewports (width > 1024), a radial gradient circle tracks
/// the cursor with a smooth lerp delay. On smaller viewports the child
/// is rendered without any overlay.
class CursorGlow extends StatefulWidget {
  const CursorGlow({required this.child, super.key});

  final Widget child;

  @override
  State<CursorGlow> createState() => _CursorGlowState();
}

class _CursorGlowState extends State<CursorGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Offset _targetPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;
  bool _isHovering = false;

  static const double _lerpFactor = 0.15;
  static const double _glowRadius = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_onTick);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTick() {
    if (!_isHovering) return;

    final dx = _lerpDouble(_currentPosition.dx, _targetPosition.dx);
    final dy = _lerpDouble(_currentPosition.dy, _targetPosition.dy);
    final next = Offset(dx, dy);

    if ((next - _currentPosition).distance < 0.1) return;

    setState(() {
      _currentPosition = next;
    });
  }

  double _lerpDouble(double current, double target) {
    return current + (target - current) * _lerpFactor;
  }

  void _onEnter(PointerEvent event) {
    _isHovering = true;
    _targetPosition = event.localPosition;
    _currentPosition = event.localPosition;
    _controller.repeat();
  }

  void _onHover(PointerEvent event) {
    _targetPosition = event.localPosition;
  }

  void _onExit(PointerEvent event) {
    _isHovering = false;
    _controller.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 1024;

    if (!isDesktop) {
      return widget.child;
    }

    return MouseRegion(
      onEnter: _onEnter,
      onHover: _onHover,
      onExit: _onExit,
      child: Stack(
        children: [
          widget.child,
          if (_isHovering)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _CursorGlowPainter(
                    position: _currentPosition,
                    radius: _glowRadius,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CursorGlowPainter extends CustomPainter {
  const _CursorGlowPainter({
    required this.position,
    required this.radius,
  });

  final Offset position;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.15),
          AppColors.accent.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(center: position, radius: radius),
      );

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(_CursorGlowPainter oldDelegate) {
    return oldDelegate.position != position || oldDelegate.radius != radius;
  }
}
