import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../models/sensor_data.dart';
import '../models/scan_result.dart';

// Service API pour communiquer avec le serveur externe
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  bool _isInitialized = false;

  // Initialisation du service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: AppConfig.defaultHeaders,
      connectTimeout: AppConfig.apiTimeout,
      receiveTimeout: AppConfig.apiTimeout,
      sendTimeout: AppConfig.apiTimeout,
    ));

    // Intercepteurs pour la gestion des erreurs
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('🌐 API Request: ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('✅ API Response: ${response.statusCode}');
        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint('❌ API Error: ${error.message}');
        handler.next(error);
      },
    ));

    _isInitialized = true;
  }

  // Vérification de la connectivité
  Future<bool> checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Erreur de vérification de connectivité: $e');
      return false;
    }
  }

  // Récupération des données des capteurs
  Future<List<SensorData>> getSensorData() async {
    try {
      await initialize();
      
      if (!await checkConnectivity()) {
        throw Exception('Aucune connexion internet disponible');
      }

      final response = await _dio.get(AppConfig.apiDataEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sensors'] ?? [];
        return data.map((json) => SensorData.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Délai de connexion dépassé');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Délai de réception dépassé');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Erreur de connexion au serveur');
      } else {
        throw Exception('Erreur réseau: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Envoi d'une image pour analyse IA
  Future<ScanResult> scanPlantImage(File imageFile) async {
    try {
      await initialize();
      
      if (!await checkConnectivity()) {
        throw Exception('Aucune connexion internet disponible');
      }

      // Préparation du formulaire multipart
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'plant_scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _dio.post(
        AppConfig.apiScanEndpoint,
        data: formData,
        onSendProgress: (sent, total) {
          debugPrint('📤 Upload progress: ${(sent / total * 100).toStringAsFixed(1)}%');
        },
      );

      if (response.statusCode == 200) {
        return ScanResult.fromJson(response.data);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Délai de connexion dépassé');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Délai de réception dépassé');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Erreur de connexion au serveur');
      } else {
        throw Exception('Erreur réseau: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Génération d'un rapport PDF
  Future<String> generateReport({
    required List<SensorData> sensorData,
    required List<ScanResult> scanResults,
    required String farmName,
    required String farmerName,
  }) async {
    try {
      await initialize();
      
      if (!await checkConnectivity()) {
        throw Exception('Aucune connexion internet disponible');
      }

      final reportData = {
        'farmName': farmName,
        'farmerName': farmerName,
        'generationDate': DateTime.now().toIso8601String(),
        'sensorData': sensorData.map((s) => s.toJson()).toList(),
        'scanResults': scanResults.map((s) => s.toJson()).toList(),
        'summary': {
          'totalSensors': sensorData.length,
          'totalScans': scanResults.length,
          'healthyPlants': scanResults.where((s) => s.isHealthy).length,
          'diseasedPlants': scanResults.where((s) => s.hasDiseases).length,
        },
      };

      final response = await _dio.post(
        AppConfig.apiReportEndpoint,
        data: jsonEncode(reportData),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['pdfUrl'] ?? '';
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Délai de connexion dépassé');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Délai de réception dépassé');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Erreur de connexion au serveur');
      } else {
        throw Exception('Erreur réseau: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Test de connexion au serveur
  Future<bool> testConnection() async {
    try {
      await initialize();
      
      if (!await checkConnectivity()) {
        return false;
      }

      final response = await _dio.get('/health', 
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Test de connexion échoué: $e');
      return false;
    }
  }
}