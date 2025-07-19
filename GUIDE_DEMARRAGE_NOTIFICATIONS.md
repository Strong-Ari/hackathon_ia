# 🚀 Guide de Démarrage Rapide - Notifications Vocales

## ⚡ Test rapide en 5 minutes

### 1. Démarrer le serveur Flask de test

```bash
# Installer les dépendances
pip install -r requirements.txt

# Démarrer le serveur
python backend_flask_exemple.py
```

Le serveur démarre sur `http://localhost:5000`

### 2. Configurer l'application Flutter

1. Lancez l'application Flutter
2. Sur la page d'accueil, cliquez sur **"Test Notifications"** (bouton discret en bas)
3. Dans le champ "URL de base", entrez : `http://localhost:5000`
4. Cliquez sur **"Sauvegarder la configuration"**

### 3. Démarrer les notifications

1. Cliquez sur **"Démarrer le polling"**
2. Le système commence à vérifier les notifications toutes les 10 secondes
3. Le serveur Flask génère aléatoirement des notifications de test

### 4. Observer le fonctionnement

- **Notifications automatiques** : Apparaissent de manière aléatoire
- **Animations** : Cartes qui glissent depuis le haut
- **Audio** : Bip d'alerte + tentative de lecture du message vocal
- **Auto-dismiss** : Disparition automatique après 8 secondes

## 🔧 Commandes de test utiles

### Générer une notification manuellement
```bash
curl -X POST http://localhost:5000/generate_notification
```

### Vérifier le statut du serveur
```bash
curl http://localhost:5000/status
```

### Voir les notifications actuelles
```bash
curl http://localhost:5000/notifications/
```

### Effacer toutes les notifications
```bash
curl -X POST http://localhost:5000/clear_notifications
```

## 📱 Interface de test Flutter

### Contrôles disponibles

- **🟢 Démarrer le polling** : Active la surveillance
- **🟠 Arrêter le polling** : Désactive la surveillance  
- **🧪 Test notification** : Simule une notification locale
- **🗑️ Vider le cache** : Remet à zéro l'historique
- **💾 Sauvegarder** : Persiste la configuration

### Informations affichées

- Intervalle de polling : 10 secondes
- Endpoint : `/notifications/`
- Fichier audio d'alerte : `assets/audio/bling.mp3`

## 🐛 Dépannage

### L'application ne reçoit pas de notifications

1. Vérifiez que le serveur Flask fonctionne : `http://localhost:5000/status`
2. Confirmez l'URL dans l'app Flutter
3. Vérifiez les logs de debug dans la console Flutter
4. Testez l'endpoint manuellement : `curl http://localhost:5000/notifications/`

### Pas de son d'alerte

1. Vérifiez que le fichier `assets/audio/bling.mp3` existe
2. Confirmez que les assets sont déclarés dans `pubspec.yaml`
3. Redémarrez l'application après modification des assets

### Erreurs de lecture audio des messages vocaux

- Normal avec le serveur de test (fichiers audio vides)
- En production, remplacez par de vrais fichiers MP3
- Les erreurs sont journalisées sans planter l'app

## 📦 Production

### Pour utiliser avec votre vraie API Flask

1. Remplacez l'URL dans l'interface de test
2. Assurez-vous que votre API retourne le format JSON attendu
3. Vérifiez que les fichiers MP3 sont accessibles via HTTP
4. Activez CORS sur votre serveur Flask

### Format JSON requis

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

### Structure des fichiers audio

```
votre_serveur_flask/
├── audio_files/
│   ├── notification_1752911454.mp3
│   ├── notification_1752911455.mp3
│   └── ...
└── app.py
```

## 🎯 Personnalisation

### Modifier l'intervalle de polling

Dans `lib/core/constants/api_constants.dart` :
```dart
static const Duration pollingInterval = Duration(seconds: 5); // 5 secondes
```

### Changer la durée d'auto-dismiss

Dans `lib/ui/widgets/notification_overlay.dart` :
```dart
Timer(const Duration(seconds: 12), () {  // 12 secondes
  _dismissNotification(notification);
});
```

### Personnaliser les animations

Dans `lib/ui/widgets/voice_notification_card.dart`, modifiez :
```dart
.slideY(
  begin: -1.0,
  end: 0.0,
  duration: 800.ms,  // Plus lent
  curve: Curves.bounceOut,  // Effet rebond
)
```

---

**🎉 Félicitations !** Votre système de notifications vocales est maintenant opérationnel.