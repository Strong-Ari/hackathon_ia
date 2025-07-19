import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config.dart';
import '../../../core/providers/sensor_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/status_indicator.dart';
import '../../widgets/alert_banner.dart';

// Écran du tableau de bord producteur
class ProducerDashboardScreen extends ConsumerStatefulWidget {
  const ProducerDashboardScreen({super.key});

  @override
  ConsumerState<ProducerDashboardScreen> createState() => _ProducerDashboardScreenState();
}

class _ProducerDashboardScreenState extends ConsumerState<ProducerDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(realTimeStatsProvider);
    final alerts = ref.watch(alertsProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          // Indicateur de connexion
          IconButton(
            onPressed: () {
              _refreshController.forward().then((_) {
                _refreshController.reverse();
              });
              // TODO: Rafraîchir les données
            },
            icon: AnimatedBuilder(
              animation: _refreshController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _refreshController.value * 2 * 3.14159,
                  child: Icon(
                    connectionStatus ? Icons.wifi : Icons.wifi_off,
                    color: connectionStatus ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Rafraîchir les données
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bannière d'alerte si nécessaire
              if (alerts.isNotEmpty) ...[
                AlertBanner(
                  message: alerts.first,
                  type: AlertType.warning,
                ),
                const SizedBox(height: 20),
              ],

              // Titre de la section
              Text(
                'Vue d\'ensemble',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Cartes principales
              _buildMainCards(stats),
              const SizedBox(height: 30),

              // Section des capteurs
              _buildSensorsSection(),
              const SizedBox(height: 30),

              // Section des alertes
              _buildAlertsSection(alerts),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMainCards(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        // Carte température
        DashboardCard(
          title: 'Température',
          value: '${stats['averageTemperature'].toStringAsFixed(1)}°C',
          icon: Icons.thermostat,
          color: AppTheme.infoColor,
          trend: stats['averageTemperature'] > 25 ? Trend.up : Trend.down,
        ),

        // Carte humidité
        DashboardCard(
          title: 'Humidité',
          value: '${stats['averageHumidity'].toStringAsFixed(1)}%',
          icon: Icons.water_drop,
          color: AppTheme.infoColor,
          trend: stats['averageHumidity'] > 60 ? Trend.up : Trend.down,
        ),

        // Carte humidité du sol
        DashboardCard(
          title: 'Sol',
          value: '${stats['averageSoilMoisture'].toStringAsFixed(1)}%',
          icon: Icons.grass,
          color: AppTheme.secondaryColor,
          trend: stats['averageSoilMoisture'] > 40 ? Trend.up : Trend.down,
        ),

        // Carte capteurs
        DashboardCard(
          title: 'Capteurs',
          value: '${stats['totalSensors']}',
          icon: Icons.sensors,
          color: AppTheme.primaryColor,
          trend: Trend.stable,
        ),
      ],
    );
  }

  Widget _buildSensorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'État des capteurs',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        Consumer(
          builder: (context, ref, child) {
            final sensorDataAsync = ref.watch(realTimeSensorDataProvider);
            
            return sensorDataAsync.when(
              data: (sensors) {
                if (sensors.isEmpty) {
                  return _buildNoDataCard();
                }
                
                return Column(
                  children: sensors.take(3).map((sensor) => _buildSensorCard(sensor)).toList(),
                );
              },
              loading: () => _buildLoadingCard(),
              error: (error, stack) => _buildErrorCard(error.toString()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSensorCard(SensorData sensor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: sensor.healthColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.sensors,
            color: sensor.healthColor,
            size: 24,
          ),
        ),
        title: Text(
          'Capteur ${sensor.id}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${sensor.location} • ${sensor.healthStatus}',
          style: TextStyle(
            color: sensor.healthColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: StatusIndicator(
          status: sensor.isHealthy ? Status.healthy : 
                 sensor.needsAttention ? Status.warning : Status.critical,
        ),
        onTap: () {
          // TODO: Navigation vers les détails du capteur
        },
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.sensors_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune donnée disponible',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vérifiez la connexion de vos capteurs',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Chargement des données...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de connexion',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(List<String> alerts) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alertes',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        ...alerts.map((alert) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: AppTheme.warningColor.withOpacity(0.1),
          child: ListTile(
            leading: Icon(
              Icons.warning,
              color: AppTheme.warningColor,
            ),
            title: Text(
              alert,
              style: TextStyle(
                color: AppTheme.warningColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // Déjà sur le tableau de bord
            break;
          case 1:
            context.go('/producer/scan');
            break;
          case 2:
            context.go('/producer/reports');
            break;
          case 3:
            context.go('/producer/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Tableau de bord',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Scan IA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Rapports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
    );
  }
}