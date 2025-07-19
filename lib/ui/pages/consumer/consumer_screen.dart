import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../widgets/consumer_card.dart';

// Écran principal de l'espace consommateur
class ConsumerScreen extends StatefulWidget {
  const ConsumerScreen({super.key});

  @override
  State<ConsumerScreen> createState() => _ConsumerScreenState();
}

class _ConsumerScreenState extends State<ConsumerScreen>
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
      appBar: AppBar(
        title: const Text('Espace Consommateur'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigation vers les paramètres
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.secondaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre principal
                _buildMainTitle(),
                const SizedBox(height: 20),
                
                // Sous-titre
                _buildSubtitle(),
                const SizedBox(height: 40),
                
                // Cartes des fonctionnalités
                _buildFeatureCards(),
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

  Widget _buildMainTitle() {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        return Opacity(
          opacity: _titleController.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _titleController.value)),
            child: Text(
              'Découvrez l\'origine\nde vos produits',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
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
              'Tracez vos aliments de la ferme à votre assiette',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCards() {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (context, child) {
        return Opacity(
          opacity: _cardsController.value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - _cardsController.value)),
            child: Column(
              children: [
                // Scanner un produit
                ConsumerCard(
                  title: 'Scanner un produit',
                  subtitle: 'Scannez le QR code d\'un produit pour voir son origine',
                  icon: Icons.qr_code_scanner,
                  color: AppTheme.secondaryColor,
                  onTap: () => context.go('/consumer/scan'),
                ),
                
                const SizedBox(height: 20),
                
                // Rechercher un producteur
                ConsumerCard(
                  title: 'Rechercher un producteur',
                  subtitle: 'Trouvez des producteurs locaux et leurs produits',
                  icon: Icons.search,
                  color: AppTheme.primaryColor,
                  onTap: () => context.go('/consumer/search'),
                ),
                
                const SizedBox(height: 20),
                
                // Historique des scans
                ConsumerCard(
                  title: 'Historique',
                  subtitle: 'Consultez vos produits scannés précédemment',
                  icon: Icons.history,
                  color: AppTheme.infoColor,
                  onTap: () => context.go('/consumer/history'),
                ),
                
                const SizedBox(height: 20),
                
                // Informations sur l'agriculture
                ConsumerCard(
                  title: 'En savoir plus',
                  subtitle: 'Découvrez les bonnes pratiques agricoles',
                  icon: Icons.info,
                  color: AppTheme.accentColor,
                  onTap: () => context.go('/consumer/info'),
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