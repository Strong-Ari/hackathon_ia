import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/router_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _controller.forward();

    await Future.delayed(const Duration(seconds: 2));
    _fadeController.forward();

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGreen,
              AppColors.primaryGreenDark,
              Color(0xFF0D4F0F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Icône principale
                      Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.eco,
                              size: 60,
                              color: AppColors.primaryGreen,
                            ),
                          )
                          .animate()
                          .scale(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.elasticOut,
                          )
                          .then()
                          .shimmer(
                            duration: const Duration(seconds: 2),
                            color: AppColors.accentGold.withOpacity(0.3),
                          ),

                      const SizedBox(height: 40),

                      // Titre principal
                      Text(
                            'AgriShield AI',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                          )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 400),
                            duration: const Duration(milliseconds: 800),
                          )
                          .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                      const SizedBox(height: 16),

                      // Sous-titre
                      Text(
                            'L\'IA veille sur vos cultures',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1,
                                ),
                          )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 800),
                          )
                          .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                      const SizedBox(height: 60),

                      // Indicateur de chargement stylé
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Column(
                            children: [
                              Container(
                                width: 200,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 200 * _controller.value,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.accentGold,
                                          AppColors.accentGoldLight,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Initialisation...',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ],
                          );
                        },
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 1200),
                        duration: const Duration(milliseconds: 600),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer avec version
              FadeTransition(
                opacity: _fadeController,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.agriculture,
                              size: 16,
                              color: AppColors.accentGold,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Révolutionner l\'agriculture en Afrique',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Version 1.0.0',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
