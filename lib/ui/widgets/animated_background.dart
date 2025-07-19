import 'package:flutter/material.dart';
import '../../config.dart';

// Widget pour l'arrière-plan animé
class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  const AnimatedBackground({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
                AppTheme.accentColor,
              ],
              stops: [
                0.0,
                0.5 + (controller.value * 0.3),
                1.0,
              ],
            ),
          ),
          child: CustomPaint(
            painter: BackgroundPainter(controller.value),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

// Peintre personnalisé pour l'arrière-plan
class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Cercles animés en arrière-plan
    for (int i = 0; i < 5; i++) {
      final radius = 50.0 + (i * 30.0) + (animationValue * 20.0);
      final x = size.width * (0.2 + (i * 0.15)) + (animationValue * 10.0);
      final y = size.height * (0.3 + (i * 0.1)) + (animationValue * 5.0);
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }

    // Particules flottantes
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i / 20.0)) + (animationValue * 50.0);
      final y = (size.height * 0.5) + (i * 20.0) + (animationValue * 30.0);
      
      canvas.drawCircle(
        Offset(x, y),
        2.0 + (animationValue * 3.0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}