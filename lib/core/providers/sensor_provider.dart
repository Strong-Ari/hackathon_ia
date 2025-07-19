import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/sensor_data.dart';
import '../services/api_service.dart';

// Provider pour le service API
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provider pour la connectivité
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

// Provider pour les données des capteurs
final sensorDataProvider = FutureProvider<List<SensorData>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getSensorData();
});

// Provider pour les données du tableau de bord
final dashboardDataProvider = Provider<DashboardData>((ref) {
  final sensorDataAsync = ref.watch(sensorDataProvider);
  
  return sensorDataAsync.when(
    data: (sensors) => DashboardData.fromSensorList(sensors),
    loading: () => const DashboardData(
      sensors: [],
      averageTemperature: 0.0,
      averageHumidity: 0.0,
      averageSoilMoisture: 0.0,
      totalSensors: 0,
      healthyPlants: 0,
      warningPlants: 0,
      criticalPlants: 0,
    ),
    error: (error, stack) => const DashboardData(
      sensors: [],
      averageTemperature: 0.0,
      averageHumidity: 0.0,
      averageSoilMoisture: 0.0,
      totalSensors: 0,
      healthyPlants: 0,
      warningPlants: 0,
      criticalPlants: 0,
    ),
  );
});

// Provider pour le statut de connexion
final connectionStatusProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityProvider);
  
  return connectivityAsync.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => false,
    error: (error, stack) => false,
  );
});

// Provider pour le rafraîchissement automatique
final autoRefreshProvider = StateProvider<bool>((ref) => true);

// Provider pour l'intervalle de rafraîchissement
final refreshIntervalProvider = StateProvider<Duration>((ref) => 
  AppConfig.refreshInterval
);

// Provider pour les données en temps réel (avec rafraîchissement automatique)
final realTimeSensorDataProvider = StreamProvider<List<SensorData>>((ref) async* {
  final apiService = ref.read(apiServiceProvider);
  final autoRefresh = ref.watch(autoRefreshProvider);
  final interval = ref.watch(refreshIntervalProvider);
  
  if (!autoRefresh) {
    // Si le rafraîchissement automatique est désactivé, on récupère une seule fois
    try {
      yield await apiService.getSensorData();
    } catch (e) {
      yield [];
    }
    return;
  }
  
  // Rafraîchissement automatique
  while (true) {
    try {
      final data = await apiService.getSensorData();
      yield data;
    } catch (e) {
      // En cas d'erreur, on continue avec les données précédentes
      yield [];
    }
    
    await Future.delayed(interval);
  }
});

// Provider pour les statistiques en temps réel
final realTimeStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final sensorDataAsync = ref.watch(realTimeSensorDataProvider);
  
  return sensorDataAsync.when(
    data: (sensors) {
      if (sensors.isEmpty) {
        return {
          'totalSensors': 0,
          'healthyPlants': 0,
          'warningPlants': 0,
          'criticalPlants': 0,
          'averageTemperature': 0.0,
          'averageHumidity': 0.0,
          'averageSoilMoisture': 0.0,
          'lastUpdate': DateTime.now(),
        };
      }
      
      final healthy = sensors.where((s) => s.isHealthy).length;
      final warning = sensors.where((s) => s.needsAttention).length;
      final critical = sensors.where((s) => s.isCritical).length;
      
      final avgTemp = sensors.map((s) => s.temperature).reduce((a, b) => a + b) / sensors.length;
      final avgHumidity = sensors.map((s) => s.humidity).reduce((a, b) => a + b) / sensors.length;
      final avgSoilMoisture = sensors.map((s) => s.soilMoisture).reduce((a, b) => a + b) / sensors.length;
      
      return {
        'totalSensors': sensors.length,
        'healthyPlants': healthy,
        'warningPlants': warning,
        'criticalPlants': critical,
        'averageTemperature': avgTemp,
        'averageHumidity': avgHumidity,
        'averageSoilMoisture': avgSoilMoisture,
        'lastUpdate': DateTime.now(),
      };
    },
    loading: () => {
      'totalSensors': 0,
      'healthyPlants': 0,
      'warningPlants': 0,
      'criticalPlants': 0,
      'averageTemperature': 0.0,
      'averageHumidity': 0.0,
      'averageSoilMoisture': 0.0,
      'lastUpdate': DateTime.now(),
    },
    error: (error, stack) => {
      'totalSensors': 0,
      'healthyPlants': 0,
      'warningPlants': 0,
      'criticalPlants': 0,
      'averageTemperature': 0.0,
      'averageHumidity': 0.0,
      'averageSoilMoisture': 0.0,
      'lastUpdate': DateTime.now(),
      'error': error.toString(),
    },
  );
});

// Provider pour les alertes
final alertsProvider = Provider<List<String>>((ref) {
  final stats = ref.watch(realTimeStatsProvider);
  final alerts = <String>[];
  
  // Vérification des seuils critiques
  if (stats['averageTemperature'] > 35.0) {
    alerts.add('⚠️ Température élevée détectée (${stats['averageTemperature'].toStringAsFixed(1)}°C)');
  }
  
  if (stats['averageHumidity'] < 30.0) {
    alerts.add('💧 Humidité faible détectée (${stats['averageHumidity'].toStringAsFixed(1)}%)');
  }
  
  if (stats['averageSoilMoisture'] < 20.0) {
    alerts.add('🌱 Humidité du sol faible (${stats['averageSoilMoisture'].toStringAsFixed(1)}%)');
  }
  
  if (stats['criticalPlants'] > 0) {
    alerts.add('🚨 ${stats['criticalPlants']} plante(s) en état critique');
  }
  
  if (stats['warningPlants'] > 0) {
    alerts.add('⚠️ ${stats['warningPlants']} plante(s) nécessitent une attention');
  }
  
  return alerts;
});