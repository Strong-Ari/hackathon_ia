# 🔊 Système de Notifications Vocales Interactives

## 📋 Vue d'ensemble

Le système de notifications vocales interactives permet à l'application Flutter de recevoir et diffuser automatiquement des notifications avec audio depuis une API Flask, sans utiliser les notifications natives du système.

## 🏗️ Architecture

### Composants principaux

1. **NotificationModel** (`lib/core/models/notification_model.dart`)
   - Modèle de données pour les notifications
   - Gère la sérialisation/désérialisation JSON

2. **NotificationService** (`lib/core/providers/notification_service.dart`)
   - Service principal de gestion des notifications
   - Polling régulier de l'API Flask
   - Lecture audio automatique
   - Gestion du cache pour éviter les doublons

3. **VoiceNotificationCard** (`lib/ui/widgets/voice_notification_card.dart`)
   - Widget de carte de notification avec animations
   - Design moderne avec effets visuels

4. **NotificationOverlay** (`lib/ui/widgets/notification_overlay.dart`)
   - Overlay global pour afficher les notifications
   - Gestion automatique de l'affichage et du dismiss

5. **NotificationTestPage** (`lib/ui/pages/notification_test_page.dart`)
   - Interface de test et configuration
   - Contrôles pour démarrer/arrêter le polling

## 🚀 Fonctionnalités

### ✅ Implémentées

- **Polling automatique** : Vérification régulière des nouvelles notifications (configurable, par défaut 10s)
- **Détection des doublons** : Système de cache basé sur les timestamps
- **Lecture audio séquentielle** : Bip d'alerte + message vocal distant
- **Interface utilisateur non-bloquante** : Notifications flottantes au-dessus du contenu
- **Animations fluides** : Effets slide-in et fade-in pour l'apparition
- **Configuration dynamique** : URL de l'API modifiable dans l'interface
- **Auto-dismiss** : Disparition automatique après 8 secondes
- **Gestion multi-notifications** : Support de plusieurs notifications simultanées

### 🎵 Gestion Audio

1. **Son d'alerte** : Court bip depuis `assets/audio/bling.mp3`
2. **Message vocal** : Streaming du fichier MP3 distant depuis l'API Flask
3. **Lecture séquentielle** : Alerte → Pause (500ms) → Message vocal

## 🔧 Configuration

### URL de l'API Flask

L'application se connecte à votre API Flask via l'URL configurée dans l'interface de test.

**Endpoint attendu** : `GET /notifications/`

**Format de réponse JSON** :
```json
[
  {
    "audio_file": "audio_files/notification_1752911454.mp3",
    "message": "Votre plantation est saine pour l'instant.",
    "timestamp": 1752911454,
    "titre": "Analyse automatique"
  }
]
```

### Fichiers audio

- **Alerte locale** : `assets/audio/bling.mp3` (inclus dans l'app)
- **Messages vocaux** : Servis depuis l'API Flask via `/{audio_file}`

## 🎯 Utilisation

### Accès à l'interface de test

1. Lancez l'application Flutter
2. Depuis la page d'accueil, cliquez sur le bouton discret "Test Notifications" en bas
3. Configurez l'URL de votre API Flask
4. Démarrez le polling

### Configuration recommandée

```
URL de base : http://192.168.1.100:5000
Polling : 10 secondes
Auto-dismiss : 8 secondes
```

### Commandes disponibles

- **Démarrer/Arrêter le polling** : Active ou désactive la surveillance
- **Test notification** : Simule une notification (sans audio réel)
- **Vider le cache** : Remet à zéro les notifications déjà traitées
- **Sauvegarder la configuration** : Persiste l'URL de l'API

## 🔄 Cycle de vie

1. **Démarrage automatique** : Le polling démarre au lancement de l'app
2. **Polling continu** : Vérification régulière de l'endpoint
3. **Détection** : Nouvelles notifications identifiées par timestamp
4. **Affichage** : Apparition animée de la carte de notification
5. **Audio** : Lecture automatique bip + message vocal
6. **Dismiss** : Disparition automatique ou manuelle

## 🎨 Personnalisation

### Animations

Les animations peuvent être personnalisées dans `VoiceNotificationCard` :
- **Slide-in** : Configuration via `flutter_animate`
- **Pulsation de l'icône** : Animation en boucle pour attirer l'attention
- **Transitions** : Durées et courbes modifiables

### Styles visuels

- **Couleurs** : Adaptées au thème de l'application
- **Typographie** : Google Fonts (Poppins)
- **Icônes** : Phosphor Icons pour la cohérence
- **Ombres** : Effets de profondeur multicouches

## 🛠️ Dépendances requises

```yaml
dependencies:
  just_audio: ^0.9.36          # Lecture audio
  flutter_animate: ^4.5.0      # Animations
  dio: ^5.4.1                  # Requêtes HTTP
  shared_preferences: ^2.2.2   # Persistance locale
  google_fonts: ^6.2.1         # Typographie
  phosphor_flutter: ^2.1.0     # Icônes
  flutter_riverpod: ^2.5.1     # Gestion d'état
```

## 🔍 Debug et Tests

### Logs de debug

Le service affiche des logs pour le diagnostic :
```
Démarrage du polling des notifications...
Nouvelle notification reçue: Analyse automatique
Lecture du message vocal: http://192.168.1.100:5000/audio_files/notification_1752911454.mp3
```

### Test sans backend

La page de test permet de simuler des notifications même sans API Flask active.

## 🚨 Gestion d'erreurs

- **Connexion réseau** : Échecs silencieux avec logs
- **Fichiers audio manquants** : Tentative de lecture avec gestion d'erreur
- **JSON malformé** : Validation et traitement des erreurs
- **Permissions audio** : Gestion automatique par `just_audio`

## 🔐 Sécurité et Performance

- **Cache local** : Timestamps stockés dans SharedPreferences
- **Polling optimisé** : Arrêt automatique lors de la fermeture de l'app
- **Gestion mémoire** : Disposal correct des AudioPlayer
- **Ressources** : Nettoyage automatique des contrôleurs d'animation

## 🎯 Points d'extension

1. **Notifications riches** : Ajout d'images, boutons d'action
2. **Persistence** : Historique des notifications reçues
3. **Filtrage** : Critères de priorité ou catégories
4. **Interactions** : Actions personnalisées sur tap/swipe
5. **Synthèse vocale** : TTS local en fallback du MP3 distant

---

**Note** : Ce système est conçu pour être léger, non-intrusif et facilement désactivable selon les besoins de l'utilisateur.
