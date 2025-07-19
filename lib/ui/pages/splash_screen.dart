import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../widgets/animated_background.dart';

// Écran de splash animé pour AgriShield AI
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Démarrage des animations
    _backgroundController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    
    // Attente et navigation vers l'accueil
    await Future.delayed(AppConfig.splashAnimationDuration);
    
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan animé
          AnimatedBackground(
            controller: _backgroundController,
          ),
          
          // Contenu principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animé
                _buildLogo(),
                
                const SizedBox(height: 40),
                
                // Texte du titre
                _buildTitle(),
                
                const SizedBox(height: 20),
                
                // Sous-titre
                _buildSubtitle(),
                
                const SizedBox(height: 60),
                
                // Indicateur de chargement
                _buildLoadingIndicator(),
              ],
            ),
          ),
          
          // Version en bas à droite
          Positioned(
            bottom: 40,
            right: 40,
            child: _buildVersionText(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: Curves.elasticOut.transform(_logoController.value),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                  AppTheme.accentColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.eco,
              size: 60,
              color: Colors.white,
            ),
          ),
        );
      },
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 800))
      .slideY(begin: 0.3, end: 0, duration: const Duration(milliseconds: 800));
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _textController.value)),
            child: Text(
              'AgriShield AI',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _textController.value)),
            child: Text(
              'L\'IA veille sur vos cultures',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textController.value,
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVersionText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textController.value * 0.7,
          child: Text(
            'v${AppConfig.appVersion}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        );
      },
    );
  }
}

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