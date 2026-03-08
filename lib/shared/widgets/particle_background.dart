import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/constants/animation_constants.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';

/// Enhanced 3D particle field with depth layers, mouse interaction,
/// and connection lines. Particles react to cursor with repulsion effect.
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _random = math.Random();
  Size _size = Size.zero;
  Offset? _mousePosition;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _particles = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _particleCount(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return AnimationConstants.particleCountMobile;
    }
    if (Responsive.isTablet(context)) {
      return AnimationConstants.particleCountTablet;
    }
    return AnimationConstants.particleCountDesktop;
  }

  void _initParticles(Size size, int count) {
    if (_initialized && _size == size) return;
    _size = size;
    _initialized = true;

    _particles = List.generate(count, (_) {
      final layer = _random.nextInt(3); // 0=far, 1=mid, 2=near
      final layerScale = 0.4 + layer * 0.3; // 0.4, 0.7, 1.0
      return _Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        vx: (_random.nextDouble() - 0.5) * 0.4 * layerScale,
        vy: (_random.nextDouble() - 0.5) * 0.4 * layerScale,
        radius: (AnimationConstants.particleMinSize +
                _random.nextDouble() *
                    (AnimationConstants.particleMaxSize -
                        AnimationConstants.particleMinSize)) *
            layerScale,
        opacity: (0.15 + _random.nextDouble() * 0.4) * layerScale,
        layer: layer,
        color: layer == 2
            ? AppColors.accent
            : layer == 1
                ? AppColors.secondaryStart
                : AppColors.secondaryEnd,
      );
    });
  }

  void _updateParticles() {
    const mouseRadius = AnimationConstants.particleMouseRadius;
    const maxSpeed = AnimationConstants.particleMaxSpeed;

    for (final p in _particles) {
      p
        ..x += p.vx
        ..y += p.vy;

      // Wrap around edges
      if (p.x < -10) p.x = _size.width + 10;
      if (p.x > _size.width + 10) p.x = -10;
      if (p.y < -10) p.y = _size.height + 10;
      if (p.y > _size.height + 10) p.y = -10;

      // Mouse repulsion
      if (_mousePosition != null) {
        final dx = p.x - _mousePosition!.dx;
        final dy = p.y - _mousePosition!.dy;
        final dist = math.sqrt(dx * dx + dy * dy);

        if (dist < mouseRadius && dist > 0) {
          final force = (mouseRadius - dist) / mouseRadius;
          final forceScale = force * force * 0.08;
          p
            ..vx += (dx / dist) * forceScale
            ..vy += (dy / dist) * forceScale;
        }
      }

      // Damping
      p
        ..vx *= 0.99
        ..vy *= 0.99;

      // Limit velocity
      final speed = math.sqrt(p.vx * p.vx + p.vy * p.vy);
      if (speed > maxSpeed) {
        p
          ..vx = (p.vx / speed) * maxSpeed
          ..vy = (p.vy / speed) * maxSpeed;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size, _particleCount(context));

        return MouseRegion(
          onHover: (event) => _mousePosition = event.localPosition,
          onExit: (_) => _mousePosition = null,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              _updateParticles();
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  particles: _particles,
                  mousePosition: _mousePosition,
                  isDark: isDark,
                  connectionDistance:
                      AnimationConstants.particleConnectionDistance,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.opacity,
    required this.layer,
    required this.color,
  });

  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double opacity;
  int layer;
  Color color;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.isDark,
    required this.connectionDistance,
    this.mousePosition,
  });

  final List<_Particle> particles;
  final Offset? mousePosition;
  final bool isDark;
  final double connectionDistance;

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      _paintLight(canvas, size);
      return;
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final dotPaint = Paint()..style = PaintingStyle.fill;

    // Draw connection lines (only between nearby particles in same/adjacent layers)
    for (var i = 0; i < particles.length; i++) {
      final a = particles[i];
      for (var j = i + 1; j < particles.length; j++) {
        final b = particles[j];
        if ((a.layer - b.layer).abs() > 1) continue;

        final dx = a.x - b.x;
        final dy = a.y - b.y;
        final dist = math.sqrt(dx * dx + dy * dy);

        if (dist < connectionDistance) {
          final alpha = (1 - dist / connectionDistance) * 0.15;
          linePaint.color = a.color.withValues(alpha: alpha);
          canvas.drawLine(Offset(a.x, a.y), Offset(b.x, b.y), linePaint);
        }
      }

      // Lines to mouse
      if (mousePosition != null) {
        final dx = a.x - mousePosition!.dx;
        final dy = a.y - mousePosition!.dy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist < connectionDistance * 1.5) {
          final alpha = (1 - dist / (connectionDistance * 1.5)) * 0.25;
          linePaint.color = AppColors.accent.withValues(alpha: alpha);
          canvas.drawLine(Offset(a.x, a.y), mousePosition!, linePaint);
        }
      }
    }

    // Draw particles with glow for near-layer
    for (final p in particles) {
      dotPaint.color = p.color.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, dotPaint);

      // Glow for near-layer particles
      if (p.layer == 2) {
        dotPaint.color = p.color.withValues(alpha: p.opacity * 0.3);
        canvas.drawCircle(Offset(p.x, p.y), p.radius * 2.5, dotPaint);
      }
    }
  }

  void _paintLight(Canvas canvas, Size size) {
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      const color = AppColors.accentLight;
      dotPaint.color = color.withValues(alpha: p.opacity * 0.4);
      canvas.drawCircle(Offset(p.x, p.y), p.radius * 0.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
