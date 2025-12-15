import 'package:flutter/material.dart';

abstract class AnimationConstants {
  // Duraciones base
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration slower = Duration(milliseconds: 800);
  static const Duration slowest = Duration(milliseconds: 1000);

  // Duraciones específicas para efectos
  static const Duration fadeIn = Duration(milliseconds: 400);
  static const Duration slideIn = Duration(milliseconds: 500);
  static const Duration scaleIn = Duration(milliseconds: 350);
  static const Duration pageTransition = Duration(milliseconds: 400);
  static const Duration heroAnimation = Duration(milliseconds: 1500);
  static const Duration typingEffect = Duration(milliseconds: 50);
  static const Duration particleFloat = Duration(milliseconds: 3000);

  // Delays para stagger animations
  static const Duration staggerDelay = Duration(milliseconds: 100);
  static const Duration staggerDelayLong = Duration(milliseconds: 150);

  // Curvas de animación
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve entranceCurve = Curves.easeOutQuart;
  static const Curve exitCurve = Curves.easeInQuart;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve sharpCurve = Curves.easeInOutQuint;

  // Curvas personalizadas
  static const Cubic heroRevealCurve = Cubic(0.25, 0.1, 0.25, 1);
  static const Cubic cardHoverCurve = Cubic(0.4, 0, 0.2, 1);

  // Offsets para slides
  static const Offset slideFromBottom = Offset(0, 50);
  static const Offset slideFromTop = Offset(0, -50);
  static const Offset slideFromLeft = Offset(-50, 0);
  static const Offset slideFromRight = Offset(50, 0);

  // Valores de escala
  static const double scaleStart = 0.8;
  static const double scaleHover = 1.05;
  static const double scaleTap = 0.95;

  // Valores de opacidad
  static const double fadeStart = 0;
  static const double fadeEnd = 1;
  static const double hoverOpacity = 0.8;

  // Valores de rotación (en radianes)
  static const double rotateStart = 0;
  static const double rotateSlight = 0.05;
  static const double rotate3D = 0.15;

  // Configuración de partículas
  static const int particleCount = 50;
  static const double particleMinSize = 2;
  static const double particleMaxSize = 6;
  static const double particleMinSpeed = 0.5;
  static const double particleMaxSpeed = 2;

  // Tilt effect para tarjetas 3D
  static const double maxTiltAngle = 0.1; // radianes
  static const double tiltPerspective = 0.002;

  // Scroll animation triggers
  static const double scrollTriggerOffset = 0.2; // 20% visible
  static const double parallaxFactor = 0.3;

  // Timing para secuencias del Hero
  static const Duration heroBackgroundStart = Duration.zero;
  static const Duration heroBackgroundEnd = Duration(milliseconds: 500);
  static const Duration heroParticlesStart = Duration(milliseconds: 300);
  static const Duration heroParticlesEnd = Duration(milliseconds: 800);
  static const Duration heroCodeStart = Duration(milliseconds: 500);
  static const Duration heroCodeEnd = Duration(milliseconds: 1500);
  static const Duration heroNameStart = Duration(milliseconds: 1200);
  static const Duration heroNameEnd = Duration(milliseconds: 2000);
  static const Duration heroTaglineStart = Duration(milliseconds: 2000);
  static const Duration heroTaglineEnd = Duration(milliseconds: 3500);
  static const Duration heroButtonsStart = Duration(milliseconds: 3000);
  static const Duration heroButtonsEnd = Duration(milliseconds: 3500);
}

// Extension para facilitar el uso de delays con flutter_animate
extension DurationDelay on Duration {
  Duration operator +(Duration other) => Duration(
        microseconds: inMicroseconds + other.inMicroseconds,
      );
}
