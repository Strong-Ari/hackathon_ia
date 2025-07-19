// Modèle de données pour les capteurs agricoles
class SensorData {
  final String id;
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double lightIntensity;
  final String plantHealth;
  final DateTime timestamp;
  final String location;
  final int sensorCount;

  const SensorData({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.lightIntensity,
    required this.plantHealth,
    required this.timestamp,
    required this.location,
    required this.sensorCount,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      soilMoisture: (json['soilMoisture'] ?? 0.0).toDouble(),
      lightIntensity: (json['lightIntensity'] ?? 0.0).toDouble(),
      plantHealth: json['plantHealth'] ?? 'Unknown',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      location: json['location'] ?? '',
      sensorCount: json['sensorCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperature': temperature,
      'humidity': humidity,
      'soilMoisture': soilMoisture,
      'lightIntensity': lightIntensity,
      'plantHealth': plantHealth,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'sensorCount': sensorCount,
    };
  }

  // Méthodes utilitaires
  bool get isHealthy => plantHealth.toLowerCase() == 'healthy';
  bool get needsAttention => plantHealth.toLowerCase() == 'warning';
  bool get isCritical => plantHealth.toLowerCase() == 'critical';

  String get healthStatus {
    if (isHealthy) return 'Sain';
    if (needsAttention) return 'Attention requise';
    if (isCritical) return 'Critique';
    return 'Inconnu';
  }

  Color get healthColor {
    if (isHealthy) return const Color(AppConfig.successGreen);
    if (needsAttention) return const Color(AppConfig.warningOrange);
    if (isCritical) return const Color(AppConfig.errorRed);
    return Colors.grey;
  }
}

// Modèle pour les données agrégées du tableau de bord
class DashboardData {
  final List<SensorData> sensors;
  final double averageTemperature;
  final double averageHumidity;
  final double averageSoilMoisture;
  final int totalSensors;
  final int healthyPlants;
  final int warningPlants;
  final int criticalPlants;

  const DashboardData({
    required this.sensors,
    required this.averageTemperature,
    required this.averageHumidity,
    required this.averageSoilMoisture,
    required this.totalSensors,
    required this.healthyPlants,
    required this.warningPlants,
    required this.criticalPlants,
  });

  factory DashboardData.fromSensorList(List<SensorData> sensorList) {
    if (sensorList.isEmpty) {
      return const DashboardData(
        sensors: [],
        averageTemperature: 0.0,
        averageHumidity: 0.0,
        averageSoilMoisture: 0.0,
        totalSensors: 0,
        healthyPlants: 0,
        warningPlants: 0,
        criticalPlants: 0,
      );
    }

    final avgTemp = sensorList.map((s) => s.temperature).reduce((a, b) => a + b) / sensorList.length;
    final avgHumidity = sensorList.map((s) => s.humidity).reduce((a, b) => a + b) / sensorList.length;
    final avgSoilMoisture = sensorList.map((s) => s.soilMoisture).reduce((a, b) => a + b) / sensorList.length;
    
    final healthy = sensorList.where((s) => s.isHealthy).length;
    final warning = sensorList.where((s) => s.needsAttention).length;
    final critical = sensorList.where((s) => s.isCritical).length;

    return DashboardData(
      sensors: sensorList,
      averageTemperature: avgTemp,
      averageHumidity: avgHumidity,
      averageSoilMoisture: avgSoilMoisture,
      totalSensors: sensorList.length,
      healthyPlants: healthy,
      warningPlants: warning,
      criticalPlants: critical,
    );
  }
}