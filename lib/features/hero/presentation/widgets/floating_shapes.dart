import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';

/// Floating geometric shapes (hexagons, circles, triangles) with glass effect,
/// slow 3D rotation and parallax movement for the Hero background.
class FloatingShapes extends StatefulWidget {
  const FloatingShapes({
    super.key,
    this.scrollOffset = 0,
    this.shapeCount = 8,
  });

  final double scrollOffset;
  final int shapeCount;

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ShapeData> _shapes;
  final _random = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _shapes = List.generate(widget.shapeCount, (_) => _generateShape());
  }

  _ShapeData _generateShape() {
    return _ShapeData(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: 40 + _random.nextDouble() * 80,
      rotationSpeed: 0.5 + _random.nextDouble() * 1.5,
      rotationOffset: _random.nextDouble() * 2 * pi,
      type: _ShapeType.values[_random.nextInt(_ShapeType.values.length)],
      opacity: 0.04 + _random.nextDouble() * 0.06,
      color: _random.nextBool() ? AppColors.accent : AppColors.secondaryEnd,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _FloatingShapesPainter(
            shapes: _shapes,
            animationValue: _controller.value,
            parallaxOffset: widget.scrollOffset * 0.6,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

enum _ShapeType { circle, hexagon, triangle }

class _ShapeData {
  _ShapeData({
    required this.x,
    required this.y,
    required this.size,
    required this.rotationSpeed,
    required this.rotationOffset,
    required this.type,
    required this.opacity,
    required this.color,
  });

  final double x;
  final double y;
  final double size;
  final double rotationSpeed;
  final double rotationOffset;
  final _ShapeType type;
  final double opacity;
  final Color color;
}

class _FloatingShapesPainter extends CustomPainter {
  _FloatingShapesPainter({
    required this.shapes,
    required this.animationValue,
    required this.parallaxOffset,
  });

  final List<_ShapeData> shapes;
  final double animationValue;
  final double parallaxOffset;

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      final centerX = shape.x * size.width;
      final centerY = shape.y * size.height - parallaxOffset;
      final rotation =
          animationValue * 2 * pi * shape.rotationSpeed + shape.rotationOffset;

      final paint = Paint()
        ..color = shape.color.withValues(alpha: shape.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas
        ..save()
        ..translate(centerX, centerY)
        ..rotate(rotation);

      switch (shape.type) {
        case _ShapeType.circle:
          canvas.drawCircle(Offset.zero, shape.size / 2, paint);
          // Inner glow
          paint
            ..style = PaintingStyle.fill
            ..color = shape.color.withValues(alpha: shape.opacity * 0.3);
          canvas.drawCircle(Offset.zero, shape.size / 2, paint);
        case _ShapeType.hexagon:
          final path = _hexagonPath(shape.size / 2);
          canvas.drawPath(path, paint);
          paint
            ..style = PaintingStyle.fill
            ..color = shape.color.withValues(alpha: shape.opacity * 0.2);
          canvas.drawPath(path, paint);
        case _ShapeType.triangle:
          final path = _trianglePath(shape.size / 2);
          canvas.drawPath(path, paint);
          paint
            ..style = PaintingStyle.fill
            ..color = shape.color.withValues(alpha: shape.opacity * 0.2);
          canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  Path _hexagonPath(double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * pi / 180;
      final point = Offset(radius * cos(angle), radius * sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  Path _trianglePath(double radius) {
    final path = Path();
    for (var i = 0; i < 3; i++) {
      final angle = (i * 120 - 90) * pi / 180;
      final point = Offset(radius * cos(angle), radius * sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_FloatingShapesPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue ||
      parallaxOffset != oldDelegate.parallaxOffset;
}
