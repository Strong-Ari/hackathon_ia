import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/router_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _cardsController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cardsController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundLight,
              AppColors.backgroundBeige,
              AppColors.primaryGreen.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header avec animation de fond
              SliverToBoxAdapter(
                child: _buildAnimatedHeader(),
              ),
              
              // Contenu principal
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Message d'accueil
                      _buildWelcomeMessage(),
                      
                      const SizedBox(height: 40),
                      
                      // Cartes des espaces
                      Expanded(
                        child: Column(
                          children: [
                            _buildSpaceCard(
                              title: 'Espace Producteur',
                              subtitle: 'Surveillez et optimisez vos cultures',
                              icon: Icons.agriculture,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primaryGreen,
                                  AppColors.primaryGreenDark,
                                ],
                              ),
                              delay: 0,
                              onTap: () => _navigateToProducerSpace(),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            _buildSpaceCard(
                              title: 'Espace Consommateur',
                              subtitle: 'Découvrez des produits de qualité',
                              icon: Icons.restaurant,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.accentGold,
                                  AppColors.accentGoldDark,
                                ],
                              ),
                              delay: 200,
                              onTap: () => _navigateToConsumerSpace(),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Footer informatif
                      _buildFooter(),
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

  Widget _buildAnimatedHeader() {
    return Container(
      height: 200,
      child: Stack(
        children: [
          // Fond animé avec particules
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryGreen.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Stack(
                  children: List.generate(15, (index) {
                    final double animationValue = _backgroundController.value;
                    final double delay = index * 0.1;
                    final double adjustedValue = (animationValue + delay) % 1.0;
                    
                    return Positioned(
                      left: (index * 30.0) % MediaQuery.of(context).size.width,
                      top: 20 + (adjustedValue * 150),
                      child: Opacity(
                        opacity: (1 - adjustedValue) * 0.3,
                        child: Icon(
                          index % 3 == 0 ? Icons.eco : 
                          index % 3 == 1 ? Icons.wb_sunny_outlined : 
                          Icons.water_drop_outlined,
                          size: 12 + (index % 3) * 4,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          
          // Contenu du header
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'AgriShield AI',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                    letterSpacing: 1.5,
                  ),
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 800))
                    .slideY(begin: -0.3, end: 0),
                
                const SizedBox(height: 8),
                
                Text(
                  'Votre assistant intelligent pour l\'agriculture',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 800),
                    )
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.waving_hand,
              color: AppColors.accentGold,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue !',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choisissez votre espace pour commencer',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 800),
        )
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSpaceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required int delay,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (context, child) {
        final delayedValue = Curves.easeOutCubic.transform(
          (_cardsController.value - (delay / 1000)).clamp(0.0, 1.0),
        );
        
        return Transform.translate(
          offset: Offset(0, 50 * (1 - delayedValue)),
          child: Opacity(
            opacity: delayedValue,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Effet de brillance
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    
                    // Contenu
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subtitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      'Accéder',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              icon,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('500+', 'Producteurs'),
            _buildStatItem('24/7', 'Surveillance'),
            _buildStatItem('98%', 'Précision IA'),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.eco,
                size: 16,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              Text(
                'Agriculture Intelligente • Afrique 2024',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 800),
        );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _navigateToProducerSpace() {
    // Naviguer vers le tableau de bord producteur
    context.push('/producer/dashboard');
  }

  void _navigateToConsumerSpace() {
    // Pour l'instant, afficher un message car l'espace consommateur n'est pas implémenté
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Espace Consommateur - Bientôt disponible !'),
        backgroundColor: AppColors.accentGold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
