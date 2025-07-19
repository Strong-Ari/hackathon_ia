import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';
import '../constants/api_constants.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationStreamProvider = StreamProvider<NotificationModel?>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.notificationStream;
});

class NotificationService {
  final Dio _dio = Dio();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _alertPlayer = AudioPlayer();
  
  Timer? _pollingTimer;
  final StreamController<NotificationModel?> _notificationController = 
      StreamController<NotificationModel?>.broadcast();
  
  final Set<int> _processedTimestamps = <int>{};
  bool _isPolling = false;
  
  Stream<NotificationModel?> get notificationStream => _notificationController.stream;

  NotificationService() {
    _loadProcessedTimestamps();
  }

  /// Charge les timestamps déjà traités depuis SharedPreferences
  Future<void> _loadProcessedTimestamps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? timestamps = prefs.getStringList('processed_timestamps');
      if (timestamps != null) {
        _processedTimestamps.addAll(timestamps.map((t) => int.parse(t)));
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des timestamps: $e');
    }
  }

  /// Sauvegarde les timestamps traités dans SharedPreferences
  Future<void> _saveProcessedTimestamps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> timestamps = _processedTimestamps.map((t) => t.toString()).toList();
      await prefs.setStringList('processed_timestamps', timestamps);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des timestamps: $e');
    }
  }

  /// Démarre le polling des notifications
  void startPolling() {
    if (_isPolling) return;
    
    _isPolling = true;
    debugPrint('Démarrage du polling des notifications...');
    
    // Premier appel immédiat
    _fetchNotifications();
    
    // Polling régulier
    _pollingTimer = Timer.periodic(ApiConstants.pollingInterval, (_) {
      _fetchNotifications();
    });
  }

  /// Arrête le polling des notifications
  void stopPolling() {
    _isPolling = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    debugPrint('Arrêt du polling des notifications');
  }

  /// Récupère les notifications depuis l'API
  Future<void> _fetchNotifications() async {
    try {
      // Récupérer l'URL depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('api_base_url') ?? ApiConstants.baseUrl;
      final notificationsUrl = '$baseUrl${ApiConstants.notificationsEndpoint}';
      
      final response = await _dio.get(notificationsUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<NotificationModel> notifications = data
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        // Trier par timestamp pour traiter les plus récentes en premier
        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        // Traiter les nouvelles notifications
        for (final notification in notifications) {
          if (!_processedTimestamps.contains(notification.timestamp)) {
            await _processNewNotification(notification);
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des notifications: $e');
    }
  }

  /// Traite une nouvelle notification
  Future<void> _processNewNotification(NotificationModel notification) async {
    try {
      debugPrint('Nouvelle notification reçue: ${notification.titre}');
      
      // Marquer comme traitée
      _processedTimestamps.add(notification.timestamp);
      await _saveProcessedTimestamps();
      
      // Émettre la notification dans le stream
      _notificationController.sink.add(notification);
      
      // Jouer l'audio
      await _playNotificationAudio(notification);
      
    } catch (e) {
      debugPrint('Erreur lors du traitement de la notification: $e');
    }
  }

  /// Joue l'audio de notification (bip + message vocal)
  Future<void> _playNotificationAudio(NotificationModel notification) async {
    try {
      // 1. Jouer le son d'alerte (bip)
      await _playAlertSound();
      
      // 2. Attendre un court délai
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 3. Jouer le message vocal
      await _playVoiceMessage(notification);
      
    } catch (e) {
      debugPrint('Erreur lors de la lecture audio: $e');
    }
  }

  /// Joue le son d'alerte court
  Future<void> _playAlertSound() async {
    try {
      await _alertPlayer.setAsset(ApiConstants.alertSoundAsset);
      await _alertPlayer.play();
    } catch (e) {
      debugPrint('Erreur lors de la lecture du son d\'alerte: $e');
    }
  }

  /// Joue le message vocal depuis l'URL distante
  Future<void> _playVoiceMessage(NotificationModel notification) async {
    try {
      // Récupérer l'URL depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('api_base_url') ?? ApiConstants.baseUrl;
      final audioUrl = '$baseUrl/${notification.audioFile}';
      
      debugPrint('Lecture du message vocal: $audioUrl');
      
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Erreur lors de la lecture du message vocal: $e');
    }
  }

  /// Arrête la lecture audio en cours
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    await _alertPlayer.stop();
  }

  /// Nettoie les ressources
  void dispose() {
    stopPolling();
    _audioPlayer.dispose();
    _alertPlayer.dispose();
    _notificationController.close();
  }

  /// Vide le cache des notifications traitées
  Future<void> clearProcessedNotifications() async {
    _processedTimestamps.clear();
    await _saveProcessedTimestamps();
    debugPrint('Cache des notifications nettoyé');
  }
}