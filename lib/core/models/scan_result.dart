import 'package:flutter/material.dart';
import '../config.dart';

// Modèle pour les résultats de scan IA des plantes
class ScanResult {
  final String id;
  final String plantName;
  final String diagnosis;
  final String confidence;
  final List<String> diseases;
  final List<String> recommendations;
  final String imageUrl;
  final DateTime scanDate;
  final String location;

  const ScanResult({
    required this.id,
    required this.plantName,
    required this.diagnosis,
    required this.confidence,
    required this.diseases,
    required this.recommendations,
    required this.imageUrl,
    required this.scanDate,
    required this.location,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] ?? '',
      plantName: json['plantName'] ?? 'Plante inconnue',
      diagnosis: json['diagnosis'] ?? 'Aucun diagnostic disponible',
      confidence: json['confidence'] ?? '0%',
      diseases: List<String>.from(json['diseases'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      scanDate: DateTime.parse(json['scanDate'] ?? DateTime.now().toIso8601String()),
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantName': plantName,
      'diagnosis': diagnosis,
      'confidence': confidence,
      'diseases': diseases,
      'recommendations': recommendations,
      'imageUrl': imageUrl,
      'scanDate': scanDate.toIso8601String(),
      'location': location,
    };
  }

  // Méthodes utilitaires
  bool get isHealthy => diagnosis.toLowerCase().contains('sain') || 
                       diagnosis.toLowerCase().contains('healthy');
  
  bool get hasDiseases => diseases.isNotEmpty;
  
  bool get hasRecommendations => recommendations.isNotEmpty;

  Color get statusColor {
    if (isHealthy) return const Color(AppConfig.successGreen);
    if (hasDiseases) return const Color(AppConfig.errorRed);
    return const Color(AppConfig.warningOrange);
  }

  String get statusText {
    if (isHealthy) return 'Plante saine';
    if (hasDiseases) return 'Maladie détectée';
    return 'Attention requise';
  }

  double get confidenceValue {
    final cleanConfidence = confidence.replaceAll('%', '').replaceAll(' ', '');
    return double.tryParse(cleanConfidence) ?? 0.0;
  }
}

// Modèle pour les données de scan en cours
class ScanProgress {
  final bool isScanning;
  final double progress;
  final String currentStep;
  final String? error;

  const ScanProgress({
    this.isScanning = false,
    this.progress = 0.0,
    this.currentStep = '',
    this.error,
  });

  ScanProgress copyWith({
    bool? isScanning,
    double? progress,
    String? currentStep,
    String? error,
  }) {
    return ScanProgress(
      isScanning: isScanning ?? this.isScanning,
      progress: progress ?? this.progress,
      currentStep: currentStep ?? this.currentStep,
      error: error ?? this.error,
    );
  }
}