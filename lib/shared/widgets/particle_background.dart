import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({
    this.particleCount = 50,
    this.particleColor,
    this.lineColor,
    this.enableLines = true,
    this.lineDistance = 150,
    super.key,
  });

  final int particleCount;
  final Color? particleColor;
  final Color? lineColor;
  final bool enableLines;
  final double lineDistance;

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final _random = math.Random();
  Size _size = Size.zero;
  Offset? _mousePosition;

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

  void _initParticles(Size size) {
    if (_size == size) return;
    _size = size;

    _particles = List.generate(widget.particleCount, (_) {
      return Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        vx: (_random.nextDouble() - 0.5) * 0.5,
        vy: (_random.nextDouble() - 0.5) * 0.5,
        radius: _random.nextDouble() * 2 + 1,
        opacity: _random.nextDouble() * 0.5 + 0.2,
      );
    });
  }

  void _updateParticles() {
    for (final particle in _particles) {
      particle
        ..x += particle.vx
        ..y += particle.vy;

      // Bounce off edges
      if (particle.x < 0 || particle.x > _size.width) {
        particle.vx *= -1;
      }
      if (particle.y < 0 || particle.y > _size.height) {
        particle.vy *= -1;
      }

      // Mouse interaction
      if (_mousePosition != null) {
        final dx = _mousePosition!.dx - particle.x;
        final dy = _mousePosition!.dy - particle.y;
        final distance = math.sqrt(dx * dx + dy * dy);

        if (distance < 100) {
          final force = (100 - distance) / 100;
          particle
            ..vx -= dx * force * 0.01
            ..vy -= dy * force * 0.01;
        }
      }

      // Limit velocity
      final speed = math.sqrt(particle.vx * particle.vx + particle.vy * particle.vy);
      if (speed > 2) {
        particle
          ..vx = (particle.vx / speed) * 2
          ..vy = (particle.vy / speed) * 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final particleColor = widget.particleColor ??
        (isDark ? AppColors.accent : AppColors.accentDark);
    final lineColor = widget.lineColor ??
        particleColor.withValues(alpha: 0.1);

    return LayoutBuilder(
      builder: (context, constraints) {
        _initParticles(Size(constraints.maxWidth, constraints.maxHeight));

        return MouseRegion(
          onHover: (event) {
            _mousePosition = event.localPosition;
          },
          onExit: (_) {
            _mousePosition = null;
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              _updateParticles();
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _ParticlePainter(
                  particles: _particles,
                  particleColor: particleColor,
                  lineColor: lineColor,
                  enableLines: widget.enableLines,
                  lineDistance: widget.lineDistance,
                  mousePosition: _mousePosition,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class Particle {
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.opacity,
  });

  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double opacity;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.particleColor,
    required this.lineColor,
    required this.enableLines,
    required this.lineDistance,
    this.mousePosition,
  });

  final List<Particle> particles;
  final Color particleColor;
  final Color lineColor;
  final bool enableLines;
  final double lineDistance;
  final Offset? mousePosition;

  @override
  void paint(Canvas canvas, Size size) {
    final particlePaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw lines between nearby particles
    if (enableLines) {
      for (var i = 0; i < particles.length; i++) {
        for (var j = i + 1; j < particles.length; j++) {
          final dx = particles[i].x - particles[j].x;
          final dy = particles[i].y - particles[j].y;
          final distance = math.sqrt(dx * dx + dy * dy);

          if (distance < lineDistance) {
            final opacity = (1 - distance / lineDistance) * 0.3;
            linePaint.color = lineColor.withValues(alpha: opacity);
            canvas.drawLine(
              Offset(particles[i].x, particles[i].y),
              Offset(particles[j].x, particles[j].y),
              linePaint,
            );
          }
        }

        // Draw line to mouse
        if (mousePosition != null) {
          final dx = particles[i].x - mousePosition!.dx;
          final dy = particles[i].y - mousePosition!.dy;
          final distance = math.sqrt(dx * dx + dy * dy);

          if (distance < lineDistance * 1.5) {
            final opacity = (1 - distance / (lineDistance * 1.5)) * 0.5;
            linePaint.color = particleColor.withValues(alpha: opacity);
            canvas.drawLine(
              Offset(particles[i].x, particles[i].y),
              mousePosition!,
              linePaint,
            );
          }
        }
      }
    }

    // Draw particles
    for (final particle in particles) {
      particlePaint.color = particleColor.withValues(alpha: particle.opacity);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.radius,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
