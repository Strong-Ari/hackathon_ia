import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/router_provider.dart';

class ProducerDashboardPage extends StatefulWidget {
  const ProducerDashboardPage({super.key});

  @override
  State<ProducerDashboardPage> createState() => _ProducerDashboardPageState();
}

class _ProducerDashboardPageState extends State<ProducerDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _metricsController;
  late AnimationController _alertController;
  int _selectedIndex = 0;

  // Données simulées pour la démo
  final Map<String, dynamic> _farmData = {
    'temperature': 24.5,
    'humidity': 68.0,
    'soilMoisture': 45.0,
    'plantHealth': 92.0,
    'sensorsConnected': 12,
    'totalSensors': 15,
    'lastScanTime': 'Il y a 2h',
    'alerts': 2,
  };

  @override
  void initState() {
    super.initState();
    
    _metricsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _alertController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _metricsController.forward();
  }

  @override
  void dispose() {
    _metricsController.dispose();
    _alertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedIndex == 0 
          ? _buildDashboard()
          : _selectedIndex == 1 
            ? _buildScanPage()
            : _buildReportsPage(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        // App Bar personnalisée
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primaryGreen,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tableau de bord',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textOnDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Exploitation AgriShield',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textOnDark.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          _buildStatusBadge(),
                        ],
                      ),
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
              icon: const Icon(PhosphorIcons.bell, color: AppColors.textOnDark),
              onPressed: () => _showNotifications(),
            ),
          ],
        ),

        // Contenu du dashboard
        SliverPadding(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Métriques principales
              _buildMetricsGrid(),
              
              const SizedBox(height: AppDimensions.spaceXL),
              
              // Gauge de santé globale
              _buildHealthGauge(),
              
              const SizedBox(height: AppDimensions.spaceXL),
              
              // Actions rapides
              _buildQuickActions(),
              
              const SizedBox(height: AppDimensions.spaceXL),
              
              // Dernier scan
              _buildLastScanCard(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
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
              .animate(controller: _alertController)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.3, 1.3),
                curve: Curves.easeInOut,
              ),
          const SizedBox(width: AppDimensions.spaceSM),
          Text(
            'En ligne',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final metrics = [
      {
        'title': 'Température',
        'value': '${_farmData['temperature']}°C',
        'icon': PhosphorIcons.thermometer,
        'color': AppColors.statusWarning,
        'trend': '+2.1°',
      },
      {
        'title': 'Humidité',
        'value': '${_farmData['humidity']}%',
        'icon': PhosphorIcons.drop,
        'color': AppColors.primaryGreen,
        'trend': '-3%',
      },
      {
        'title': 'Sol',
        'value': '${_farmData['soilMoisture']}%',
        'icon': PhosphorIcons.plant,
        'color': AppColors.accentGold,
        'trend': 'Optimal',
      },
      {
        'title': 'Capteurs',
        'value': '${_farmData['sensorsConnected']}/${_farmData['totalSensors']}',
        'icon': PhosphorIcons.cpu,
        'color': AppColors.statusHealthy,
        'trend': 'Actifs',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spaceMD,
        mainAxisSpacing: AppDimensions.spaceMD,
        childAspectRatio: 1.2,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _buildMetricCard(
          title: metric['title'] as String,
          value: metric['value'] as String,
          icon: metric['icon'] as IconData,
          color: metric['color'] as Color,
          trend: metric['trend'] as String,
          delay: index * 100,
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required int delay,
  }) {
    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSM),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSM,
                    vertical: AppDimensions.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.statusHealthy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  ),
                  child: Text(
                    trend,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.statusHealthy,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(controller: _metricsController)
        .fadeIn(
          duration: 600.ms,
          delay: delay.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          delay: delay.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildHealthGauge() {
    final healthPercentage = _farmData['plantHealth'] as double;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.accentGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Santé Globale des Cultures',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          
          // Gauge circulaire
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cercle de fond
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
                
                // Gauge animée
                AnimatedBuilder(
                  animation: _metricsController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(180, 180),
                      painter: GaugePainter(
                        percentage: healthPercentage * _metricsController.value,
                        color: _getHealthColor(healthPercentage),
                      ),
                    );
                  },
                ),
                
                // Valeur centrale
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${healthPercentage.toInt()}%',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getHealthColor(healthPercentage),
                      ),
                    ),
                    Text(
                      'Excellent',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(controller: _metricsController)
        .fadeIn(duration: 800.ms, delay: 400.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          delay: 400.ms,
          curve: Curves.easeOut,
        );
  }

  Color _getHealthColor(double percentage) {
    if (percentage >= 80) return AppColors.statusHealthy;
    if (percentage >= 60) return AppColors.statusWarning;
    return AppColors.statusDanger;
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Scanner IA',
        'subtitle': 'Analyser une plante',
        'icon': PhosphorIcons.camera,
        'color': AppColors.scannerFrame,
        'onTap': () => setState(() => _selectedIndex = 1),
      },
      {
        'title': 'Générer Rapport',
        'subtitle': 'PDF automatique',
        'icon': PhosphorIcons.filePdf,
        'color': AppColors.statusDanger,
        'onTap': () => setState(() => _selectedIndex = 2),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMD),
        
        Row(
          children: actions.map((action) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: AppDimensions.marginMD),
              child: _buildActionCard(
                title: action['title'] as String,
                subtitle: action['subtitle'] as String,
                icon: action['icon'] as IconData,
                color: action['color'] as Color,
                onTap: action['onTap'] as VoidCallback,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Icon(
                icon,
                color: AppColors.textOnDark,
                size: AppDimensions.iconLG,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastScanCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: const Icon(
              PhosphorIcons.leaf,
              color: AppColors.primaryGreen,
              size: AppDimensions.iconLG,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dernier Scan IA',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Tomate - Santé excellente',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _farmData['lastScanTime'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.statusHealthy,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            PhosphorIcons.arrowRight,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildScanPage() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIcons.camera,
            size: 80,
            color: AppColors.scannerFrame,
          ),
          const SizedBox(height: AppDimensions.spaceXL),
          Text(
            'Scanner IA des Plantes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            'Prenez une photo pour un diagnostic instantané',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXXL),
          // TODO: Intégrer la caméra et l'IA de diagnostic
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Ouvrir la caméra
            },
            icon: const Icon(PhosphorIcons.camera),
            label: const Text('Ouvrir Caméra'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.scannerFrame,
              foregroundColor: AppColors.textOnDark,
              minimumSize: const Size(200, 60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsPage() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIcons.filePdf,
            size: 80,
            color: AppColors.statusDanger,
          ),
          const SizedBox(height: AppDimensions.spaceXL),
          Text(
            'Rapports PDF',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            'Générez des rapports détaillés avec recommandations IA',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXXL),
          // TODO: Intégrer la génération PDF
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Générer le PDF
            },
            icon: const Icon(PhosphorIcons.filePdf),
            label: const Text('Générer Rapport'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusDanger,
              foregroundColor: AppColors.textOnDark,
              minimumSize: const Size(200, 60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.house),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.camera),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.filePdf),
            label: 'Rapports',
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    // TODO: Implémenter les notifications
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications : 2 alertes en attente'),
        backgroundColor: AppColors.statusWarning,
      ),
    );
  }
}

// Custom Painter pour la gauge circulaire
class GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;

  GaugePainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Fond de la gauge
    final backgroundPaint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Gauge de progression
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (percentage / 100) * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Commencer en haut
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}