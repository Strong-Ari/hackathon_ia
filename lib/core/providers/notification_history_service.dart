import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';
import '../constants/api_constants.dart';

final notificationHistoryServiceProvider = Provider<NotificationHistoryService>((ref) {
  return NotificationHistoryService();
});

final notificationHistoryProvider = StreamProvider<List<NotificationModel>>((ref) {
  final service = ref.watch(notificationHistoryServiceProvider);
  return service.notificationHistoryStream;
});

class NotificationHistoryService {
  Database? _database;
  final AudioPlayer _historyAudioPlayer = AudioPlayer();
  final StreamController<List<NotificationModel>> _historyController =
      StreamController<List<NotificationModel>>.broadcast();

  Stream<List<NotificationModel>> get notificationHistoryStream =>
      _historyController.stream;

  NotificationHistoryService() {
    _initDatabase();
  }

  /// Initialise la base de données SQLite
  Future<void> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final dbPath = path.join(databasesPath, 'notifications_history.db');

              _database = await openDatabase(
          dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE notifications (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              titre TEXT NOT NULL,
              message TEXT NOT NULL,
              timestamp INTEGER NOT NULL UNIQUE,
              audioFile TEXT NOT NULL,
              createdAt INTEGER NOT NULL
            )
          ''');
        },
      );

      // Charger l'historique initial
      await _loadHistory();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation de la base de données: $e');
    }
  }

  /// Ajoute une notification à l'historique
  Future<void> addNotification(NotificationModel notification) async {
    if (_database == null) return;

    try {
      await _database!.insert(
        'notifications',
        {
          'titre': notification.titre,
          'message': notification.message,
          'timestamp': notification.timestamp,
          'audioFile': notification.audioFile,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      // Recharger l'historique
      await _loadHistory();
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de la notification: $e');
    }
  }

  /// Charge l'historique depuis la base de données
  Future<void> _loadHistory() async {
    if (_database == null) return;

    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'notifications',
        orderBy: 'timestamp DESC',
        limit: 50, // Limiter à 50 notifications récentes
      );

      final notifications = maps.map((map) => NotificationModel(
        titre: map['titre'],
        message: map['message'],
        timestamp: map['timestamp'],
        audioFile: map['audioFile'],
      )).toList();

      _historyController.sink.add(notifications);
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'historique: $e');
    }
  }

  /// Recharge l'historique (pour le refresh)
  Future<void> refreshHistory() async {
    await _loadHistory();
  }

  /// Joue l'audio d'une notification depuis l'historique
  Future<void> playNotificationAudio(NotificationModel notification) async {
    try {
      // Récupérer l'URL depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('api_base_url') ?? ApiConstants.baseUrl;
      final audioUrl = '$baseUrl/${notification.audioFile}';

      debugPrint('Lecture audio historique: $audioUrl');

      await _historyAudioPlayer.setUrl(audioUrl);
      await _historyAudioPlayer.play();
    } catch (e) {
      debugPrint('Erreur lors de la lecture audio: $e');
    }
  }

  /// Arrête la lecture audio
  Future<void> stopAudio() async {
    await _historyAudioPlayer.stop();
  }

  /// Supprime une notification de l'historique
  Future<void> deleteNotification(int timestamp) async {
    if (_database == null) return;

    try {
      await _database!.delete(
        'notifications',
        where: 'timestamp = ?',
        whereArgs: [timestamp],
      );

      // Recharger l'historique
      await _loadHistory();
    } catch (e) {
      debugPrint('Erreur lors de la suppression: $e');
    }
  }

  /// Vide tout l'historique
  Future<void> clearHistory() async {
    if (_database == null) return;

    try {
      await _database!.delete('notifications');
      _historyController.sink.add([]);
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'historique: $e');
    }
  }

  /// Nettoie les ressources
  void dispose() {
    _historyAudioPlayer.dispose();
    _historyController.close();
    _database?.close();
  }
}