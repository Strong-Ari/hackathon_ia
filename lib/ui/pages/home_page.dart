import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/router_provider.dart';
import '../widgets/agri_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _contentController;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _startContentAnimation();
  }

  void _startContentAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _contentController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();
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
              AppColors.backgroundBeige,
              AppColors.backgroundLight,
              AppColors.primaryGreen.withOpacity(0.1),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Particules flottantes animées
              _buildFloatingParticles(),
              
              // Contenu principal
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final offset = _backgroundController.value * 2 * 3.14159;
            final x = 50 + (index * 40) + 30 * math.sin(offset + index);
            final y = 100 + (index * 80) + 20 * math.cos(offset + index * 0.5);
            
            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 6 + (index % 3) * 2,
                height: 6 + (index % 3) * 2,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spaceLG),
          
          // En-tête
          _buildHeader(),
          
          const SizedBox(height: AppDimensions.spaceXXL),
          
          // Bouton principal scanner
          _buildScannerButton(),
          
          const SizedBox(height: AppDimensions.spaceXXL),
          
          // Boutons secondaires
          _buildSecondaryButtons(),
          
          const Spacer(),
          
          // Statistiques rapides
          _buildQuickStats(),
          
          const SizedBox(height: AppDimensions.spaceLG),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour ! 🌱',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                )
                    .animate(controller: _contentController)
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),
                
                const SizedBox(height: AppDimensions.spaceSM),
                
                Text(
                  'Vos cultures sont protégées',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate(controller: _contentController)
                    .fadeIn(
                      duration: 600.ms,
                      delay: 200.ms,
                      curve: Curves.easeOut,
                    )
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      duration: 600.ms,
                      delay: 200.ms,
                      curve: Curves.easeOut,
                    ),
              ],
            ),
            
            // Badge de statut
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMD,
                vertical: AppDimensions.paddingSM,
              ),
              decoration: BoxDecoration(
                color: AppColors.statusHealthy.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                border: Border.all(
                  color: AppColors.statusHealthy.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.statusHealthy,
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        duration: 1000.ms,
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.3, 1.3),
                      )
                      .then()
                      .scale(
                        duration: 1000.ms,
                        begin: const Offset(1.3, 1.3),
                        end: const Offset(1.0, 1.0),
                      ),
                  
                  const SizedBox(width: AppDimensions.spaceSM),
                  
                  Text(
                    'En ligne',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.statusHealthy,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                .animate(controller: _contentController)
                .fadeIn(
                  duration: 600.ms,
                  delay: 400.ms,
                  curve: Curves.easeOut,
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 600.ms,
                  delay: 400.ms,
                  curve: Curves.elasticOut,
                ),
          ],
        ),
      ],
    );
  }

  Widget _buildScannerButton() {
    return Center(
      child: Column(
        children: [
          // Titre du scanner
          Text(
            'Analyser une plante',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _contentController)
              .fadeIn(
                duration: 600.ms,
                delay: 600.ms,
                curve: Curves.easeOut,
              )
              .slideY(
                begin: 0.3,
                end: 0.0,
                duration: 600.ms,
                delay: 600.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: AppDimensions.spaceMD),

          Text(
            'Prenez une photo pour un diagnostic IA instantané',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _contentController)
              .fadeIn(
                duration: 600.ms,
                delay: 700.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: AppDimensions.spaceXL),

          // Gros bouton scanner avec Hero animation
          Hero(
            tag: 'scanner_button',
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.scannerFrame,
                    Color(0xFF00C853),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.scannerFrame.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push(AppRoutes.scan),
                  borderRadius: BorderRadius.circular(100),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: AppColors.textOnDark,
                        ),
                        SizedBox(height: AppDimensions.spaceSM),
                        Text(
                          'Scanner',
                          style: TextStyle(
                            color: AppColors.textOnDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
              .animate(controller: _contentController)
              .fadeIn(
                duration: 800.ms,
                delay: 800.ms,
                curve: Curves.easeOut,
              )
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 1000.ms,
                delay: 800.ms,
                curve: Curves.elasticOut,
              )
              .then()
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 3000.ms,
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButtons() {
    final buttons = [
      {
        'title': 'Carte communautaire',
        'subtitle': 'Voir les alertes locales',
        'icon': Icons.map_outlined,
        'route': AppRoutes.map,
        'color': AppColors.primaryGreen,
      },
      {
        'title': 'Mode Sentinelle',
        'subtitle': 'Surveillance automatique',
        'icon': Icons.radar_outlined,
        'route': AppRoutes.sentinel,
        'color': AppColors.accentGold,
      },
      {
        'title': 'Historique',
        'subtitle': 'Vos analyses passées',
        'icon': Icons.history_outlined,
        'route': AppRoutes.history,
        'color': AppColors.primaryGreenLight,
      },
    ];

    return Column(
      children: buttons.asMap().entries.map((entry) {
        final index = entry.key;
        final button = entry.value;
        
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.marginMD),
          child: _buildSecondaryButton(
            title: button['title'] as String,
            subtitle: button['subtitle'] as String,
            icon: button['icon'] as IconData,
            color: button['color'] as Color,
            onTap: () => context.push(button['route'] as String),
            delay: 1000 + (index * 100),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSecondaryButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: AppDimensions.iconMD,
                  ),
                ),
                
                const SizedBox(width: AppDimensions.spaceMD),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconSM,
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(controller: _contentController)
        .fadeIn(
          duration: 600.ms,
          delay: delay.ms,
          curve: Curves.easeOut,
        )
        .slideX(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          delay: delay.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('15', 'Analyses', Icons.analytics_outlined),
          Container(
            width: 1,
            height: 40,
            color: AppColors.primaryGreen.withOpacity(0.2),
          ),
          _buildStatItem('98%', 'Précision', Icons.accuracy_outlined),
          Container(
            width: 1,
            height: 40,
            color: AppColors.primaryGreen.withOpacity(0.2),
          ),
          _buildStatItem('24/7', 'Protection', Icons.shield_outlined),
        ],
      ),
    )
        .animate(controller: _contentController)
        .fadeIn(
          duration: 600.ms,
          delay: 1400.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          delay: 1400.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
}