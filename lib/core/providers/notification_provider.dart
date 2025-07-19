import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/notification_model.dart';

// Provider pour l'historique des notifications
final notificationHistoryProvider = StateNotifierProvider<NotificationHistoryNotifier, List<NotificationModel>>((ref) {
  return NotificationHistoryNotifier();
});

class NotificationHistoryNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationHistoryNotifier() : super([]) {
    _loadNotifications();
  }

  static const String _storageKey = 'notification_history';

  // Charger les notifications depuis le stockage local
  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList(_storageKey);
      
      if (notificationsJson != null) {
        final notifications = notificationsJson
            .map((json) => NotificationModel.fromJson(jsonDecode(json)))
            .toList();
        
        // Trier par timestamp décroissant (plus récent en premier)
        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        state = notifications;
      }
    } catch (e) {
      print('Erreur lors du chargement des notifications: $e');
    }
  }

  // Sauvegarder les notifications dans le stockage local
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = state
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();
      
      await prefs.setStringList(_storageKey, notificationsJson);
    } catch (e) {
      print('Erreur lors de la sauvegarde des notifications: $e');
    }
  }

  // Ajouter une nouvelle notification
  Future<void> addNotification(NotificationModel notification) async {
    // Éviter les doublons basés sur le timestamp
    final exists = state.any((n) => n.timestamp == notification.timestamp);
    if (!exists) {
      state = [notification, ...state];
      await _saveNotifications();
    }
  }

  // Marquer toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    // Pour l'instant, on ne fait rien car le modèle n'a pas de champ "lu"
    // Cette méthode peut être étendue si nécessaire
  }

  // Supprimer une notification
  Future<void> removeNotification(int timestamp) async {
    state = state.where((n) => n.timestamp != timestamp).toList();
    await _saveNotifications();
  }

  // Vider tout l'historique
  Future<void> clearHistory() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  // Obtenir le nombre de notifications non lues (simulation)
  int get unreadCount => state.length > 5 ? 5 : 0; // Simulation simple

  // Ajouter des notifications d'exemple pour les tests
  Future<void> addSampleNotifications() async {
    final now = DateTime.now();
    final samples = [
      NotificationModel(
        audioFile: 'alert_parasite_tomate.mp3',
        message: 'Parasites détectés sur vos plants de tomates. Intervention recommandée dans les 24h.',
        timestamp: now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        titre: 'Alerte Parasites Détectés',
      ),
      NotificationModel(
        audioFile: 'irrigation_recommandee.mp3',
        message: 'Le niveau d\'humidité du sol est bas. Irrigation recommandée pour la parcelle B.',
        timestamp: now.subtract(const Duration(hours: 5)).millisecondsSinceEpoch ~/ 1000,
        titre: 'Irrigation Recommandée',
      ),
      NotificationModel(
        audioFile: 'maladie_detectee.mp3',
        message: 'Signes de mildiou détectés sur les plants de courgettes. Traitement fongicide conseillé.',
        timestamp: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
        titre: 'Maladie Détectée',
      ),
      NotificationModel(
        audioFile: 'conditions_optimales.mp3',
        message: 'Conditions météorologiques parfaites pour l\'épandage d\'engrais naturel.',
        timestamp: now.subtract(const Duration(days: 2)).millisecondsSinceEpoch ~/ 1000,
        titre: 'Conditions Optimales',
      ),
      NotificationModel(
        audioFile: 'recolte_prete.mp3',
        message: 'Vos tomates cerises sont prêtes pour la récolte. Maturité optimale atteinte.',
        timestamp: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch ~/ 1000,
        titre: 'Récolte Prête',
      ),
    ];

    for (final notification in samples) {
      await addNotification(notification);
    }
  }
}