import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../widgets/space_card.dart';

// Écran d'accueil avec choix entre Espace Producteur et Espace Consommateur
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _cardsController;

  @override
  void initState() {
    super.initState();
    
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _titleController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _cardsController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              children: [
                // En-tête
                _buildHeader(),
                
                const SizedBox(height: 40),
                
                // Titre principal
                _buildMainTitle(),
                
                const SizedBox(height: 20),
                
                // Sous-titre
                _buildSubtitle(),
                
                const Spacer(),
                
                // Cartes des espaces
                _buildSpaceCards(),
                
                const Spacer(),
                
                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
              ],
            ),
          ),
          child: const Icon(
            Icons.eco,
            color: Colors.white,
            size: 30,
          ),
        ),
        
        // Bouton paramètres
        IconButton(
          onPressed: () {
            // TODO: Navigation vers les paramètres
          },
          icon: const Icon(
            Icons.settings,
            color: AppTheme.primaryColor,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildMainTitle() {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        return Opacity(
          opacity: _titleController.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _titleController.value)),
            child: Text(
              'Bienvenue sur\nAgriShield AI',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                height: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        return Opacity(
          opacity: _titleController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _titleController.value)),
            child: Text(
              'Choisissez votre espace pour commencer',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpaceCards() {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (context, child) {
        return Opacity(
          opacity: _cardsController.value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - _cardsController.value)),
            child: Column(
              children: [
                // Espace Producteur
                SpaceCard(
                  title: 'Espace Producteur',
                  subtitle: 'Gérez vos cultures et surveillez vos capteurs',
                  icon: Icons.agriculture,
                  color: AppTheme.primaryColor,
                  onTap: () => context.go('/producer'),
                ),
                
                const SizedBox(height: 20),
                
                // Espace Consommateur
                SpaceCard(
                  title: 'Espace Consommateur',
                  subtitle: 'Découvrez l\'origine de vos produits',
                  icon: Icons.shopping_basket,
                  color: AppTheme.secondaryColor,
                  onTap: () => context.go('/consumer'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (context, child) {
        return Opacity(
          opacity: _cardsController.value * 0.7,
          child: Column(
            children: [
              Text(
                'Version ${AppConfig.appVersion}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '© 2024 AgriShield AI - Tous droits réservés',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}