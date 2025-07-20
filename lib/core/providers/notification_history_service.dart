import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';
import '../constants/api_constants.dart';

final notificationHistoryServiceProvider =
    Provider<NotificationHistoryService>((ref) {
  return NotificationHistoryService();
});

final notificationHistoryProvider =
    StreamProvider<List<NotificationModel>>((ref) {
  debugPrint('🔄 Initialisation du provider d\'historique');
  final service = ref.watch(notificationHistoryServiceProvider);

  // Émettre une valeur initiale vide pour éviter le chargement infini
  if (service._database == null) {
    debugPrint('⚠️ Base de données non initialisée, retour liste vide');
    return Stream.value([]);
  }

  debugPrint('✅ Retour du stream d\'historique');
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
    String? dbPath;
    try {
      final databasesPath = await getDatabasesPath();
      dbPath = path.join(databasesPath, 'notifications_history.db');
      debugPrint('📁 Chemin de la base de données: $dbPath');

      _database = await openDatabase(
        dbPath,
        version: 2,
        onCreate: (Database db, int version) async {
          debugPrint('🆕 Création de la base de données v$version');
          await db.execute('''
            CREATE TABLE notifications (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              titre TEXT NOT NULL,
              message TEXT NOT NULL,
              timestamp INTEGER NOT NULL UNIQUE,
              audioFile TEXT NOT NULL,
              imagePath TEXT,
              createdAt INTEGER NOT NULL
            )
          ''');
          debugPrint('✅ Table notifications créée');
        },
        onOpen: (Database db) async {
          debugPrint('🔓 Base de données ouverte');
          // Charger l'historique immédiatement après l'ouverture
          await _loadHistory();
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          debugPrint(
              '⬆️ Migration de la base de données v$oldVersion -> v$newVersion');
          if (oldVersion < 2) {
            // Vérifier si la colonne existe déjà
            var tableInfo =
                await db.rawQuery('PRAGMA table_info(notifications)');
            bool hasImagePath =
                tableInfo.any((column) => column['name'] == 'imagePath');

            if (!hasImagePath) {
              debugPrint('➕ Ajout de la colonne imagePath...');
              await db.execute(
                  'ALTER TABLE notifications ADD COLUMN imagePath TEXT');
              debugPrint('✅ Colonne imagePath ajoutée');
            } else {
              debugPrint('ℹ️ La colonne imagePath existe déjà');
            }
          }
        },
      );

      debugPrint('✅ Base de données initialisée avec succès');
    } catch (e) {
      debugPrint(
          '❌ Erreur lors de l\'initialisation de la base de données: $e');
      // En cas d'erreur, supprimer la base de données et la recréer
      if (dbPath != null) {
        try {
          debugPrint(
              '🔄 Tentative de suppression et recréation de la base de données...');
          await deleteDatabase(dbPath);
          _database = await openDatabase(
            dbPath,
            version: 2,
            onCreate: (Database db, int version) async {
              await db.execute('''
                CREATE TABLE notifications (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  titre TEXT NOT NULL,
                  message TEXT NOT NULL,
                  timestamp INTEGER NOT NULL UNIQUE,
                  audioFile TEXT NOT NULL,
                  imagePath TEXT,
                  createdAt INTEGER NOT NULL
                )
              ''');
            },
          );
          debugPrint('✅ Base de données recréée avec succès');
          await _loadHistory();
        } catch (e) {
          debugPrint('❌ Échec de la recréation de la base de données: $e');
          _historyController.sink.add([]);
        }
      } else {
        debugPrint(
            '❌ Impossible de recréer la base de données: chemin non disponible');
        _historyController.sink.add([]);
      }
    }
  }

  /// Ajoute une notification à l'historique
  Future<void> addNotification(NotificationModel notification) async {
    if (_database == null) {
      debugPrint('❌ Base de données non initialisée');
      return;
    }

    try {
      debugPrint('📝 Ajout d\'une notification: ${notification.titre}');
      debugPrint('🔍 Détails: ${notification.toString()}');

      final id = await _database!.insert(
        'notifications',
        {
          'titre': notification.titre,
          'message': notification.message,
          'timestamp': notification.timestamp,
          'audioFile': notification.audioFile,
          'imagePath': notification.imagePath,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      debugPrint('✅ Notification ajoutée avec l\'ID: $id');

      // Recharger l'historique
      await _loadHistory();
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'ajout de la notification: $e');
    }
  }

  /// Charge l'historique depuis la base de données
  Future<void> _loadHistory() async {
    if (_database == null) {
      debugPrint('❌ Base de données non initialisée');
      return;
    }

    try {
      debugPrint('🔄 Chargement de l\'historique...');

      final List<Map<String, dynamic>> maps = await _database!.query(
        'notifications',
        orderBy: 'timestamp DESC',
        limit: 50,
      );
      debugPrint('📊 Nombre de notifications trouvées: ${maps.length}');

      if (maps.isNotEmpty) {
        debugPrint('🔍 Première notification: ${maps.first}');
      }

      final notifications = maps.map((map) {
        final notification = NotificationModel(
          titre: map['titre'],
          message: map['message'],
          timestamp: map['timestamp'],
          audioFile: map['audioFile'],
          imagePath: map['imagePath'],
        );
        debugPrint('📱 Notification chargée: ${notification.toString()}');
        return notification;
      }).toList();

      _historyController.sink.add(notifications);
      debugPrint('✅ Historique chargé avec succès');
    } catch (e) {
      debugPrint('❌ Erreur lors du chargement de l\'historique: $e');
    }
  }

  /// Recharge l'historique (pour le refresh)
  Future<void> refreshHistory() async {
    debugPrint('🔄 Rafraîchissement de l\'historique...');
    await _loadHistory();
  }

  /// Joue l'audio d'une notification depuis l'historique
  Future<void> playNotificationAudio(NotificationModel notification) async {
    try {
      // Récupérer l'URL depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('api_base_url') ?? ApiConstants.baseUrl;

      // Nettoyer l'URL audio pour éviter la double URL
      final audioPath =
          notification.audioFile.replaceAll(baseUrl, '').replaceAll('//', '/');
      final audioUrl = '$baseUrl$audioPath';

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
