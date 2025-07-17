import 'package:flutter/material.dart';

enum PlantHealthStatus {
  healthy,
  warning,
  danger,
  critical,
}

enum DiseaseType {
  fungal,
  bacterial,
  viral,
  pest,
  nutritional,
  environmental,
}

class PlantDiagnosis {
  final String id;
  final String plantName;
  final String diseaseName;
  final DiseaseType diseaseType;
  final PlantHealthStatus status;
  final double confidence;
  final double estimatedLoss;
  final String description;
  final List<String> symptoms;
  final List<String> treatments;
  final String imagePath;
  final DateTime timestamp;
  final Location? location;

  const PlantDiagnosis({
    required this.id,
    required this.plantName,
    required this.diseaseName,
    required this.diseaseType,
    required this.status,
    required this.confidence,
    required this.estimatedLoss,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.imagePath,
    required this.timestamp,
    this.location,
  });

  Color get statusColor {
    switch (status) {
      case PlantHealthStatus.healthy:
        return const Color(0xFF4CAF50);
      case PlantHealthStatus.warning:
        return const Color(0xFFFF9800);
      case PlantHealthStatus.danger:
        return const Color(0xFFE53935);
      case PlantHealthStatus.critical:
        return const Color(0xFFD32F2F);
    }
  }

  String get statusText {
    switch (status) {
      case PlantHealthStatus.healthy:
        return 'Saine';
      case PlantHealthStatus.warning:
        return 'Attention';
      case PlantHealthStatus.danger:
        return 'Danger';
      case PlantHealthStatus.critical:
        return 'Critique';
    }
  }

  String get diseaseTypeText {
    switch (diseaseType) {
      case DiseaseType.fungal:
        return 'Fongique';
      case DiseaseType.bacterial:
        return 'Bactérienne';
      case DiseaseType.viral:
        return 'Virale';
      case DiseaseType.pest:
        return 'Parasitaire';
      case DiseaseType.nutritional:
        return 'Nutritionnelle';
      case DiseaseType.environmental:
        return 'Environnementale';
    }
  }

  IconData get diseaseTypeIcon {
    switch (diseaseType) {
      case DiseaseType.fungal:
        return Icons.eco_outlined;
      case DiseaseType.bacterial:
        return Icons.biotech_outlined;
      case DiseaseType.viral:
        return Icons.coronavirus_outlined;
      case DiseaseType.pest:
        return Icons.bug_report_outlined;
      case DiseaseType.nutritional:
        return Icons.local_dining_outlined;
      case DiseaseType.environmental:
        return Icons.wb_sunny_outlined;
    }
  }

  PlantDiagnosis copyWith({
    String? id,
    String? plantName,
    String? diseaseName,
    DiseaseType? diseaseType,
    PlantHealthStatus? status,
    double? confidence,
    double? estimatedLoss,
    String? description,
    List<String>? symptoms,
    List<String>? treatments,
    String? imagePath,
    DateTime? timestamp,
    Location? location,
  }) {
    return PlantDiagnosis(
      id: id ?? this.id,
      plantName: plantName ?? this.plantName,
      diseaseName: diseaseName ?? this.diseaseName,
      diseaseType: diseaseType ?? this.diseaseType,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      estimatedLoss: estimatedLoss ?? this.estimatedLoss,
      description: description ?? this.description,
      symptoms: symptoms ?? this.symptoms,
      treatments: treatments ?? this.treatments,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
    );
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String? address;

  const Location({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

class AIRecommendation {
  final String id;
  final String title;
  final String description;
  final RecommendationType type;
  final Priority priority;
  final double confidence;
  final List<String> steps;
  final String? productName;
  final double? estimatedCost;
  final int? timelineDays;
  final bool isUrgent;

  const AIRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.confidence,
    required this.steps,
    this.productName,
    this.estimatedCost,
    this.timelineDays,
    this.isUrgent = false,
  });

  Color get priorityColor {
    switch (priority) {
      case Priority.low:
        return const Color(0xFF4CAF50);
      case Priority.medium:
        return const Color(0xFFFF9800);
      case Priority.high:
        return const Color(0xFFE53935);
    }
  }

  String get priorityText {
    switch (priority) {
      case Priority.low:
        return 'Faible';
      case Priority.medium:
        return 'Moyenne';
      case Priority.high:
        return 'Élevée';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case RecommendationType.treatment:
        return Icons.medical_services_outlined;
      case RecommendationType.prevention:
        return Icons.shield_outlined;
      case RecommendationType.monitoring:
        return Icons.visibility_outlined;
      case RecommendationType.environmental:
        return Icons.eco_outlined;
    }
  }
}

enum RecommendationType {
  treatment,
  prevention,
  monitoring,
  environmental,
}

enum Priority {
  low,
  medium,
  high,
}