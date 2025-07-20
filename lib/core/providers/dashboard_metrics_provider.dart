import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardMetrics {
  final double temperature;
  final double humidity;
  final int activeSensors;
  final int totalSensors;
  final double plantHealth;
  final DateTime lastUpdate;

  DashboardMetrics({
    required this.temperature,
    required this.humidity,
    required this.activeSensors,
    required this.totalSensors,
    required this.plantHealth,
    required this.lastUpdate,
  });

  DashboardMetrics copyWith({
    double? temperature,
    double? humidity,
    int? activeSensors,
    int? totalSensors,
    double? plantHealth,
    DateTime? lastUpdate,
  }) {
    return DashboardMetrics(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      activeSensors: activeSensors ?? this.activeSensors,
      totalSensors: totalSensors ?? this.totalSensors,
      plantHealth: plantHealth ?? this.plantHealth,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  String get temperatureDisplay => '${temperature.toStringAsFixed(1)}°C';
  String get humidityDisplay => '${humidity.toStringAsFixed(0)}%';
  String get sensorsDisplay => '$activeSensors/$totalSensors';
  String get plantHealthDisplay => '${(plantHealth * 100).toStringAsFixed(0)}%';

  double get temperatureProgress => (temperature - 15) / 20; // 15-35°C range
  double get humidityProgress => humidity / 100;
  double get sensorsProgress => activeSensors / totalSensors;

  String get temperatureStatus {
    if (temperature < 18) return 'Froid';
    if (temperature > 30) return 'Chaud';
    return 'Optimal';
  }

  String get humidityStatus {
    if (humidity < 40) return 'Sec';
    if (humidity > 80) return 'Humide';
    return 'Bon niveau';
  }

  String get sensorsStatus {
    if (activeSensors == totalSensors) return 'Tous actifs';
    if (activeSensors < totalSensors * 0.8) return 'Problème détecté';
    return 'Quelques déconnectés';
  }

  String get plantHealthStatus {
    if (plantHealth > 0.95) return 'Excellent';
    if (plantHealth > 0.85) return 'Très bon';
    if (plantHealth > 0.70) return 'Bon';
    if (plantHealth > 0.50) return 'Moyen';
    return 'Préoccupant';
  }
}

class DashboardMetricsNotifier extends StateNotifier<DashboardMetrics> {
  Timer? _timer;
  final Random _random = Random();
  
  // Valeurs de base pour la simulation
  double _baseTemperature = 24.0;
  double _baseHumidity = 65.0;
  double _basePlantHealth = 0.95;

  DashboardMetricsNotifier() : super(
    DashboardMetrics(
      temperature: 24.0,
      humidity: 65.0,
      activeSensors: 12,
      totalSensors: 12,
      plantHealth: 0.95,
      lastUpdate: DateTime.now(),
    ),
  ) {
    _startSimulation();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateMetrics();
    });
  }

  void _updateMetrics() {
    // Simulation de variations naturelles
    final temperatureVariation = (_random.nextDouble() - 0.5) * 2; // ±1°C
    final humidityVariation = (_random.nextDouble() - 0.5) * 10; // ±5%
    final plantHealthVariation = (_random.nextDouble() - 0.5) * 0.02; // ±1%

    // Appliquer des tendances lentes (cycles de 30 secondes)
    final cycleTime = DateTime.now().millisecondsSinceEpoch / 1000 / 30;
    final temperatureCycle = sin(cycleTime * 2 * pi) * 3; // ±3°C sur 30s
    final humidityCycle = cos(cycleTime * 2 * pi) * 8; // ±8% sur 30s

    // Calculer les nouvelles valeurs
    final newTemperature = (_baseTemperature + temperatureVariation + temperatureCycle)
        .clamp(16.0, 32.0);
    
    final newHumidity = (_baseHumidity + humidityVariation + humidityCycle)
        .clamp(35.0, 85.0);
    
    final newPlantHealth = (_basePlantHealth + plantHealthVariation)
        .clamp(0.85, 0.99);

    // Simulation occasionnelle de capteurs déconnectés
    final sensorsIssue = _random.nextDouble() < 0.05; // 5% de chance
    final activeSensors = sensorsIssue ? 11 : 12;

    state = state.copyWith(
      temperature: newTemperature,
      humidity: newHumidity,
      activeSensors: activeSensors,
      plantHealth: newPlantHealth,
      lastUpdate: DateTime.now(),
    );
  }

  void refreshMetrics() {
    _updateMetrics();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final dashboardMetricsProvider = StateNotifierProvider<DashboardMetricsNotifier, DashboardMetrics>(
  (ref) => DashboardMetricsNotifier(),
);