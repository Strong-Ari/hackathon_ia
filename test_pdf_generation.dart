// Script de test pour la génération PDF AgriShield
// À lancer depuis le projet Flutter

import 'dart:io';
import 'package:flutter/services.dart';
import 'lib/core/services/pdf_generator_service.dart';

void main() async {
  print('🌱 Test de génération PDF AgriShield');
  print('=====================================');
  
  try {
    // Simulation de données d'exploitation
    final testData = {
      'farmName': 'Exploitation Test AgriShield',
      'location': 'Ouagadougou, Burkina Faso',
      'surfaceArea': 8.5,
      'farmStats': {
        'totalScans': 25,
        'accuracy': 96,
        'healthyPlants': 89,
        'diseaseDetected': 2,
        'monthlyGrowth': 18,
      }
    };
    
    print('📊 Données de test:');
    print('   Nom: ${testData['farmName']}');
    print('   Localisation: ${testData['location']}');
    print('   Surface: ${testData['surfaceArea']} ha');
    print('');
    
    print('⏳ Génération du PDF en cours...');
    final startTime = DateTime.now();
    
    final pdfBytes = await PdfGeneratorService.generateStylizedReport(
      farmName: testData['farmName'] as String,
      location: testData['location'] as String,
      surfaceArea: testData['surfaceArea'] as double,
      farmStats: testData['farmStats'] as Map<String, dynamic>,
    );
    
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    
    print('✅ PDF généré avec succès!');
    print('   Taille: ${(pdfBytes.length / 1024).toStringAsFixed(1)} KB');
    print('   Durée: ${duration.inMilliseconds}ms');
    print('');
    
    // Sauvegarde optionnelle
    final file = File('rapport_test_agrishield.pdf');
    await file.writeAsBytes(pdfBytes);
    print('💾 PDF sauvegardé: ${file.path}');
    
    print('');
    print('🎉 Test réussi! Le système PDF fonctionne parfaitement.');
    
  } catch (e) {
    print('❌ Erreur lors du test: $e');
    print('');
    print('🔧 Vérifications à effectuer:');
    print('   - Dépendances PDF installées');
    print('   - Imports corrects');
    print('   - Permissions de fichier');
  }
}

// Fonction utilitaire pour les tests en environnement Flutter
class PdfTestHelper {
  static void logPdfFeatures() {
    print('🎨 Fonctionnalités PDF AgriShield:');
    print('   ✓ Header premium avec gradient');
    print('   ✓ Informations exploitation personnalisables');
    print('   ✓ Statistiques avec icônes colorées');
    print('   ✓ Diagnostics IA avec niveaux de confiance');
    print('   ✓ Recommandations par priorité');
    print('   ✓ Graphique de tendances');
    print('   ✓ Annexes techniques détaillées');
    print('   ✓ Certification numérique SHA-256');
    print('   ✓ Footer avec pagination');
    print('   ✓ Design responsive A4');
  }
  
  static Map<String, dynamic> getSampleFarmData() {
    return {
      'farmName': 'Ferme Bio Excellence',
      'location': 'Bobo-Dioulasso, Burkina Faso',
      'surfaceArea': 12.3,
      'farmStats': {
        'totalScans': 45,
        'accuracy': 98,
        'healthyPlants': 92,
        'diseaseDetected': 1,
        'monthlyGrowth': 22,
      }
    };
  }
}