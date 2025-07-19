import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/scan_result.dart';
import '../services/api_service.dart';

// Provider pour le service API
final scanApiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provider pour l'état du scan en cours
final scanProgressProvider = StateProvider<ScanProgress>((ref) {
  return const ScanProgress();
});

// Provider pour les résultats de scan
final scanResultsProvider = StateProvider<List<ScanResult>>((ref) {
  return [];
});

// Provider pour le dernier scan effectué
final lastScanResultProvider = StateProvider<ScanResult?>((ref) {
  return null;
});

// Provider pour l'historique des scans
final scanHistoryProvider = StateProvider<List<ScanResult>>((ref) {
  return [];
});

// Provider pour les statistiques des scans
final scanStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final history = ref.watch(scanHistoryProvider);
  
  if (history.isEmpty) {
    return {
      'totalScans': 0,
      'healthyPlants': 0,
      'diseasedPlants': 0,
      'averageConfidence': 0.0,
      'mostCommonDiseases': <String>[],
      'lastScanDate': null,
    };
  }
  
  final healthy = history.where((scan) => scan.isHealthy).length;
  final diseased = history.where((scan) => scan.hasDiseases).length;
  
  final totalConfidence = history.fold<double>(
    0.0, 
    (sum, scan) => sum + scan.confidenceValue
  );
  final averageConfidence = totalConfidence / history.length;
  
  // Calcul des maladies les plus communes
  final diseaseCount = <String, int>{};
  for (final scan in history) {
    for (final disease in scan.diseases) {
      diseaseCount[disease] = (diseaseCount[disease] ?? 0) + 1;
    }
  }
  
  final sortedDiseases = diseaseCount.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  final mostCommonDiseases = sortedDiseases
    .take(5)
    .map((e) => e.key)
    .toList();
  
  return {
    'totalScans': history.length,
    'healthyPlants': healthy,
    'diseasedPlants': diseased,
    'averageConfidence': averageConfidence,
    'mostCommonDiseases': mostCommonDiseases,
    'lastScanDate': history.isNotEmpty ? history.first.scanDate : null,
  };
});

// Provider pour les recommandations basées sur l'historique
final scanRecommendationsProvider = Provider<List<String>>((ref) {
  final stats = ref.watch(scanStatsProvider);
  final recommendations = <String>[];
  
  if (stats['totalScans'] == 0) {
    recommendations.add('🔍 Effectuez votre premier scan pour commencer');
    return recommendations;
  }
  
  final diseaseRate = stats['diseasedPlants'] / stats['totalScans'];
  
  if (diseaseRate > 0.3) {
    recommendations.add('⚠️ Taux de maladie élevé (${(diseaseRate * 100).toStringAsFixed(1)}%). Vérifiez vos pratiques agricoles');
  }
  
  if (stats['averageConfidence'] < 70.0) {
    recommendations.add('📸 Améliorez la qualité des photos pour de meilleurs diagnostics');
  }
  
  if (stats['mostCommonDiseases'].isNotEmpty) {
    final topDisease = stats['mostCommonDiseases'][0];
    recommendations.add('🎯 Maladie fréquente détectée: $topDisease. Consultez un expert');
  }
  
  final daysSinceLastScan = stats['lastScanDate'] != null 
    ? DateTime.now().difference(stats['lastScanDate']).inDays 
    : 999;
  
  if (daysSinceLastScan > 7) {
    recommendations.add('📅 Il y a $daysSinceLastScan jours depuis votre dernier scan. Surveillez régulièrement vos plantes');
  }
  
  return recommendations;
});

// Provider pour le scan en cours (FutureProvider)
final currentScanProvider = FutureProvider.family<ScanResult?, File>((ref, imageFile) async {
  final apiService = ref.read(scanApiServiceProvider);
  
  // Mise à jour du progrès
  ref.read(scanProgressProvider.notifier).state = const ScanProgress(
    isScanning: true,
    progress: 0.0,
    currentStep: 'Préparation de l\'analyse...',
  );
  
  try {
    // Simulation du progrès (dans une vraie implémentation, cela viendrait du serveur)
    await Future.delayed(const Duration(milliseconds: 500));
    ref.read(scanProgressProvider.notifier).state = const ScanProgress(
      isScanning: true,
      progress: 0.3,
      currentStep: 'Envoi de l\'image...',
    );
    
    await Future.delayed(const Duration(milliseconds: 500));
    ref.read(scanProgressProvider.notifier).state = const ScanProgress(
      isScanning: true,
      progress: 0.6,
      currentStep: 'Analyse IA en cours...',
    );
    
    await Future.delayed(const Duration(milliseconds: 500));
    ref.read(scanProgressProvider.notifier).state = const ScanProgress(
      isScanning: true,
      progress: 0.9,
      currentStep: 'Finalisation...',
    );
    
    // Appel à l'API
    final result = await apiService.scanPlantImage(imageFile);
    
    // Mise à jour du progrès final
    ref.read(scanProgressProvider.notifier).state = const ScanProgress(
      isScanning: false,
      progress: 1.0,
      currentStep: 'Analyse terminée',
    );
    
    // Ajout à l'historique
    final currentHistory = ref.read(scanHistoryProvider);
    final newHistory = [result, ...currentHistory];
    ref.read(scanHistoryProvider.notifier).state = newHistory;
    
    // Mise à jour du dernier scan
    ref.read(lastScanResultProvider.notifier).state = result;
    
    return result;
    
  } catch (e) {
    // Gestion des erreurs
    ref.read(scanProgressProvider.notifier).state = ScanProgress(
      isScanning: false,
      progress: 0.0,
      currentStep: '',
      error: e.toString(),
    );
    
    rethrow;
  }
});

// Provider pour les filtres de scan
final scanFiltersProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'showHealthy': true,
    'showDiseased': true,
    'showWarnings': true,
    'dateRange': null, // DateTimeRange
    'plantName': '',
    'confidenceThreshold': 0.0,
  };
});

// Provider pour les scans filtrés
final filteredScanResultsProvider = Provider<List<ScanResult>>((ref) {
  final history = ref.watch(scanHistoryProvider);
  final filters = ref.watch(scanFiltersProvider);
  
  return history.where((scan) {
    // Filtre par statut de santé
    if (!filters['showHealthy'] && scan.isHealthy) return false;
    if (!filters['showDiseased'] && scan.hasDiseases) return false;
    if (!filters['showWarnings'] && !scan.isHealthy && !scan.hasDiseases) return false;
    
    // Filtre par nom de plante
    if (filters['plantName'].isNotEmpty) {
      if (!scan.plantName.toLowerCase().contains(filters['plantName'].toLowerCase())) {
        return false;
      }
    }
    
    // Filtre par seuil de confiance
    if (scan.confidenceValue < filters['confidenceThreshold']) return false;
    
    // Filtre par plage de dates
    if (filters['dateRange'] != null) {
      final range = filters['dateRange'] as DateTimeRange;
      if (scan.scanDate.isBefore(range.start) || scan.scanDate.isAfter(range.end)) {
        return false;
      }
    }
    
    return true;
  }).toList();
});