import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/router_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
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

    // Démarrer l'animation des cartes
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardsController.forward();
    });
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
      body: Stack(
        children: [
          // Background animé
          _buildAnimatedBackground(),
          
          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              child: Column(
                children: [
                  // Header avec logo et titre
                  _buildHeader(),
                  
                  const SizedBox(height: AppDimensions.spaceXXL),
                  
                  // Cartes de sélection
                  Expanded(
                    child: _buildSelectionCards(),
                  ),
                  
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundBeige,
                AppColors.backgroundLight,
                AppColors.primaryGreen.withOpacity(0.05),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Particules flottantes
              ...List.generate(15, (index) {
                final offset = Offset(
                  (index * 50.0) % MediaQuery.of(context).size.width,
                  (index * 80.0) % MediaQuery.of(context).size.height,
                );
                return Positioned(
                  left: offset.dx + (30 * (_backgroundController.value * 2 - 1)),
                  top: offset.dy + (20 * (_backgroundController.value * 2 - 1)),
                  child: Transform.rotate(
                    angle: _backgroundController.value * 6.28,
                    child: Container(
                      width: 4 + (index % 3) * 2,
                      height: 4 + (index % 3) * 2,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo avec animation
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            PhosphorIcons.leaf,
            size: 40,
            color: AppColors.textOnDark,
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 1000.ms,
              curve: Curves.elasticOut,
            ),

        const SizedBox(height: AppDimensions.spaceLG),

        // Titre principal
        Text(
          'AgriShield AI',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
            letterSpacing: 1.2,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
            .slideY(begin: 0.3, end: 0.0, duration: 600.ms, delay: 300.ms),

        const SizedBox(height: AppDimensions.spaceSM),

        // Sous-titre
        Text(
          'Choisissez votre espace',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms, curve: Curves.easeOut)
            .slideY(begin: 0.3, end: 0.0, duration: 600.ms, delay: 500.ms),
      ],
    );
  }

  Widget _buildSelectionCards() {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (context, child) {
        return Column(
          children: [
            // Carte Producteur
            Expanded(
              child: _buildUserTypeCard(
                title: 'Espace Producteur',
                subtitle: 'Surveillez vos cultures avec l\'IA',
                icon: PhosphorIcons.plant,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.primaryGreenDark,
                  ],
                ),
                onTap: () => context.go(AppRoutes.producerDashboard),
                animationDelay: 0.0,
              ),
            ),

            const SizedBox(height: AppDimensions.spaceLG),

            // Carte Consommateur
            Expanded(
              child: _buildUserTypeCard(
                title: 'Espace Consommateur',
                subtitle: 'Découvrez des produits de qualité',
                icon: PhosphorIcons.shoppingCart,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentGold,
                    AppColors.accentGoldDark,
                  ],
                ),
                onTap: () => context.go(AppRoutes.consumerHome),
                animationDelay: 0.2,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    required double animationDelay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Motif décoratif
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            
            // Contenu
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                    ),
                    child: Icon(
                      icon,
                      size: 30,
                      color: AppColors.textOnDark,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spaceLG),

                  // Titre
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spaceSM),

                  // Sous-titre
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textOnDark.withOpacity(0.9),
                    ),
                  ),

                  const Spacer(),

                  // Flèche
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                      child: const Icon(
                        PhosphorIcons.arrowRight,
                        color: AppColors.textOnDark,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(controller: _cardsController)
          .fadeIn(
            duration: 800.ms,
            delay: (animationDelay * 1000).ms,
            curve: Curves.easeOut,
          )
          .slideX(
            begin: animationDelay == 0.0 ? -0.3 : 0.3,
            end: 0.0,
            duration: 800.ms,
            delay: (animationDelay * 1000).ms,
            curve: Curves.easeOut,
          )
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: 800.ms,
            delay: (animationDelay * 1000).ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Version
        Text(
          'Version 1.0.0',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 1000.ms),

        const SizedBox(height: AppDimensions.spaceSM),

        // Copyright
        Text(
          '© 2024 AgriShield AI',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 1200.ms),
      ],
    );
  }
}
