import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/router_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _transformController;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _transformController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Démarrer l'animation du logo
    _logoController.forward();
    
    // Attendre un peu puis démarrer le texte
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    
    // Démarrer la transformation plante -> circuit
    await Future.delayed(const Duration(milliseconds: 800));
    _transformController.forward();
    
    // Naviguer vers l'accueil après l'animation
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animé
                _buildAnimatedLogo(),
                
                const SizedBox(height: AppDimensions.spaceXXL),
                
                // Titre et sous-titre animés
                _buildAnimatedText(),
                
                const SizedBox(height: AppDimensions.spaceXXXL),
                
                // Indicateur de chargement
                _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _transformController,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Plante (fade out pendant la transformation)
                Opacity(
                  opacity: 1 - _transformController.value,
                  child: const Icon(
                    Icons.eco,
                    size: 60,
                    color: AppColors.textOnDark,
                  ),
                ),
                
                // Circuit (fade in pendant la transformation)
                Opacity(
                  opacity: _transformController.value,
                  child: Transform.scale(
                    scale: _transformController.value,
                    child: const Icon(
                      Icons.memory,
                      size: 60,
                      color: AppColors.textOnDark,
                    ),
                  ),
                ),
                
                // Particules qui tournent
                ...List.generate(6, (index) {
                  return Transform.rotate(
                    angle: (_transformController.value * 4 * 3.14159) + (index * 3.14159 / 3),
                    child: Transform.translate(
                      offset: Offset(
                        35 * _transformController.value,
                        0,
                      ),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.accentGold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGold.withOpacity(0.6),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        )
            .animate(controller: _logoController)
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 800.ms,
              curve: Curves.elasticOut,
            );
      },
    );
  }

  Widget _buildAnimatedText() {
    return Column(
      children: [
        // Titre principal
        Text(
          'AgriShield AI',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
            letterSpacing: 1.2,
          ),
        )
            .animate(controller: _textController)
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.3,
              end: 0.0,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: AppDimensions.spaceMD),

        // Sous-titre
        Text(
          'L\'IA veille sur vos cultures',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        )
            .animate(controller: _textController)
            .fadeIn(
              duration: 600.ms,
              delay: 200.ms,
              curve: Curves.easeOut,
            )
            .slideY(
              begin: 0.3,
              end: 0.0,
              duration: 600.ms,
              delay: 200.ms,
              curve: Curves.easeOut,
            ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        // Barre de progression stylée
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedBuilder(
            animation: _transformController,
            builder: (context, child) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 200 * _transformController.value,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
            .animate(controller: _textController)
            .fadeIn(
              duration: 400.ms,
              delay: 600.ms,
            ),

        const SizedBox(height: AppDimensions.spaceLG),

        // Texte de chargement
        Text(
          'Initialisation de l\'IA...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        )
            .animate(controller: _textController)
            .fadeIn(
              duration: 400.ms,
              delay: 800.ms,
            )
            .shimmer(
              duration: 1500.ms,
              delay: 1000.ms,
              color: AppColors.primaryGreen.withOpacity(0.3),
            ),
      ],
    );
  }
}