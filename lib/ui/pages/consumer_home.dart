import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/router_provider.dart';

class ConsumerHomePage extends StatefulWidget {
  const ConsumerHomePage({super.key});

  @override
  State<ConsumerHomePage> createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _productsController;
  int _selectedCategory = 0;

  final List<String> _categories = [
    'Tous',
    'Légumes',
    'Fruits',
    'Céréales',
    'Bio',
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Tomates Bio',
      'producer': 'Ferme Dubois',
      'price': '4.50€/kg',
      'quality': 'A+',
      'distance': '2.3 km',
      'image': '🍅',
      'certification': 'AgriShield Certifié',
      'healthScore': 98,
    },
    {
      'name': 'Carottes Fraîches',
      'producer': 'Maraîchage Martin',
      'price': '3.20€/kg',
      'quality': 'A',
      'distance': '5.1 km',
      'image': '🥕',
      'certification': 'AgriShield Certifié',
      'healthScore': 95,
    },
    {
      'name': 'Pommes de Terre',
      'producer': 'Exploitation Leroy',
      'price': '2.80€/kg',
      'quality': 'A',
      'distance': '8.7 km',
      'image': '🥔',
      'certification': 'AgriShield Certifié',
      'healthScore': 92,
    },
    {
      'name': 'Salade Verte',
      'producer': 'Jardins de Claire',
      'price': '1.50€/pièce',
      'quality': 'A+',
      'distance': '3.2 km',
      'image': '🥬',
      'certification': 'AgriShield Certifié',
      'healthScore': 97,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _productsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _productsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _productsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar personnalisée
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.accentGold,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentGold,
                      AppColors.accentGoldDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Bonjour ! 🛒',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            .animate(controller: _headerController)
                            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                            .slideX(begin: -0.3, end: 0.0, duration: 600.ms),
                        
                        const SizedBox(height: AppDimensions.spaceSM),
                        
                        Text(
                          'Découvrez des produits locaux de qualité',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textOnDark.withOpacity(0.9),
                          ),
                        )
                            .animate(controller: _headerController)
                            .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOut)
                            .slideX(begin: -0.3, end: 0.0, duration: 600.ms, delay: 200.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(PhosphorIcons.arrowLeft, color: AppColors.textOnDark),
              onPressed: () => context.go(AppRoutes.home),
            ),
            actions: [
              IconButton(
                icon: const Icon(PhosphorIcons.shoppingCart, color: AppColors.textOnDark),
                onPressed: () => _showCart(),
              ),
              IconButton(
                icon: const Icon(PhosphorIcons.user, color: AppColors.textOnDark),
                onPressed: () => _showProfile(),
              ),
            ],
          ),

          // Contenu principal
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Barre de recherche
                _buildSearchBar(),
                
                const SizedBox(height: AppDimensions.spaceXL),
                
                // Catégories
                _buildCategories(),
                
                const SizedBox(height: AppDimensions.spaceXL),
                
                // Stats qualité
                _buildQualityStats(),
                
                const SizedBox(height: AppDimensions.spaceXL),
                
                // Titre produits
                _buildProductsHeader(),
                
                const SizedBox(height: AppDimensions.spaceLG),
              ]),
            ),
          ),

          // Liste des produits
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLG),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildProductCard(_products[index], index);
                },
                childCount: _products.length,
              ),
            ),
          ),

          // Espacement final
          const SliverPadding(
            padding: EdgeInsets.only(bottom: AppDimensions.spaceXXL),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            PhosphorIcons.magnifyingGlass,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher des produits...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingLG,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSM),
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: const Icon(
              PhosphorIcons.sliders,
              color: AppColors.textOnDark,
              size: 20,
            ),
          ),
        ],
      ),
    )
        .animate(controller: _headerController)
        .fadeIn(duration: 600.ms, delay: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.3, end: 0.0, duration: 600.ms, delay: 400.ms);
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMD),
        
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategory == index;
              return Container(
                margin: const EdgeInsets.only(right: AppDimensions.marginMD),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLG,
                      vertical: AppDimensions.paddingMD,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accentGold : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                      border: Border.all(
                        color: isSelected ? AppColors.accentGold : AppColors.textSecondary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      _categories[index],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? AppColors.textOnDark : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              )
                  .animate(controller: _headerController)
                  .fadeIn(
                    duration: 400.ms,
                    delay: (600 + index * 100).ms,
                    curve: Curves.easeOut,
                  )
                  .slideX(
                    begin: 0.3,
                    end: 0.0,
                    duration: 400.ms,
                    delay: (600 + index * 100).ms,
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQualityStats() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.accentGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingSM),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: const Icon(
                  PhosphorIcons.shield,
                  color: AppColors.textOnDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Garantie AgriShield',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Tous nos producteurs sont certifiés IA',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('98%', 'Qualité', PhosphorIcons.star),
              _buildStatItem('24h', 'Fraîcheur', PhosphorIcons.clock),
              _buildStatItem('Local', 'Origine', PhosphorIcons.mapPin),
            ],
          ),
        ],
      ),
    )
        .animate(controller: _headerController)
        .fadeIn(duration: 800.ms, delay: 800.ms, curve: Curves.easeOut)
        .slideY(begin: 0.3, end: 0.0, duration: 800.ms, delay: 800.ms);
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primaryGreen,
          size: AppDimensions.iconMD,
        ),
        const SizedBox(height: AppDimensions.spaceXS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Produits Recommandés',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: Voir tous les produits
          },
          child: Text(
            'Voir tout',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.accentGold,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginLG),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Row(
          children: [
            // Image produit
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.backgroundBeige,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Center(
                child: Text(
                  product['image'],
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            
            const SizedBox(width: AppDimensions.spaceLG),
            
            // Informations produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      _buildQualityBadge(product['quality']),
                    ],
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceXS),
                  
                  Text(
                    product['producer'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceSM),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingSM,
                          vertical: AppDimensions.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              PhosphorIcons.shield,
                              size: 12,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: AppDimensions.spaceXS),
                            Text(
                              product['certification'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceSM),
                      Text(
                        product['distance'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceMD),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product['price'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _addToCart(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          foregroundColor: AppColors.textOnDark,
                          minimumSize: const Size(80, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                          ),
                        ),
                        child: const Text('Ajouter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(controller: _productsController)
        .fadeIn(
          duration: 600.ms,
          delay: (index * 150).ms,
          curve: Curves.easeOut,
        )
        .slideX(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          delay: (index * 150).ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildQualityBadge(String quality) {
    Color badgeColor;
    switch (quality) {
      case 'A+':
        badgeColor = AppColors.statusHealthy;
        break;
      case 'A':
        badgeColor = AppColors.accentGold;
        break;
      default:
        badgeColor = AppColors.statusWarning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      ),
      child: Text(
        quality,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textOnDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} ajouté au panier'),
        backgroundColor: AppColors.statusHealthy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCart() {
    // TODO: Implémenter le panier
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Panier : 3 articles'),
        backgroundColor: AppColors.accentGold,
      ),
    );
  }

  void _showProfile() {
    // TODO: Implémenter le profil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil utilisateur'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}