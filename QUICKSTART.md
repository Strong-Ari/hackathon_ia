# ⚡ Quick Start - AgriShield AI

## 🚀 Lancement en 5 minutes

### 1. Prérequis
```bash
# Vérifier Flutter
flutter --version
# Flutter 3.22+ requis

# Vérifier les appareils
flutter devices
```

### 2. Installation
```bash
# Cloner et naviguer
git clone <repo-url>
cd agrischield-ai

# Installer les dépendances
flutter pub get

# Vérifier que tout est OK
flutter doctor
```

### 3. Lancement
```bash
# Mode debug (recommandé pour développement)
flutter run

# Mode release (pour tests performance)
flutter run --release

# Hot reload disponible en mode debug (r)
# Hot restart disponible (R)
```

## 📱 Navigation de test

### Flow principal recommandé
1. **Démarrage** → Admirez l'animation splash (4s)
2. **Accueil** → Cliquez sur le bouton scanner hero
3. **Scanner** → Attendez la simulation caméra puis scannez
4. **Diagnostic** → Explorez les résultats avec animations
5. **Actions** → Testez les boutons de recommandations

### Raccourcis debug
- `r` : Hot reload (préserve l'état)
- `R` : Hot restart (reset complet)
- `o` : Toggle plateforme (iOS/Android)
- `q` : Quitter

## 🎨 Points d'intérêt à tester

### Animations époustouflantes
- **Splash** : Transformation plante → circuit
- **Scanner** : Overlay avec particules animées
- **Hero transition** : Bouton scanner → page scanner
- **Micro-interactions** : Tous les boutons ont des animations

### Interface adaptative
- **Mode sombre** : Change automatiquement avec le système
- **Responsive** : Adapte à toutes les tailles d'écran
- **Feedback** : Retour visuel sur chaque interaction

### Navigation fluide
- **Transitions** : Chaque changement de page est animé
- **Retour** : Navigation cohérente avec boutons back
- **Flow logique** : Parcours utilisateur naturel

## 🔧 Développement

### Structure des fichiers
```
lib/
├── main.dart                    # Point d'entrée
├── core/constants/             # Couleurs & dimensions
├── core/models/                # Modèles de données
├── core/providers/             # Navigation & état
├── ui/pages/                   # Écrans principaux
├── ui/widgets/                 # Composants réutilisables
└── ui/theme/                   # Configuration thème
```

### Modification rapide
```dart
// Changer les couleurs principales
// Fichier: lib/core/constants/app_colors.dart
static const Color primaryGreen = Color(0xFF2E7D32);

// Modifier les animations
// Fichier: lib/core/constants/app_dimensions.dart
static const int animationMedium = 300; // millisecondes

// Ajouter une nouvelle page
// 1. Créer dans lib/ui/pages/
// 2. Ajouter route dans lib/core/providers/router_provider.dart
```

## 🐛 Dépannage express

### Erreurs communes
```bash
# Dépendances manquantes
flutter pub get

# Cache corrompu
flutter clean
flutter pub get

# Problème gradlew (Android)
cd android && ./gradlew clean && cd ..

# Reset complet
flutter clean && flutter pub get && flutter run
```

### Performance
```bash
# Profiler les performances
flutter run --profile

# Analyser la taille de l'app
flutter build appbundle --analyze-size

# Debugger les rebuilds
flutter run --debug --dart-define=flutter.inspector.structuredErrors=true
```

## 🎯 Tests rapides

### Fonctionnalités clés à valider
- [ ] Splash animation complète (4 secondes)
- [ ] Navigation home → scanner avec hero
- [ ] Scanner overlay avec animations
- [ ] Simulation analyse IA fonctionnelle
- [ ] Page diagnostic avec données mock
- [ ] Boutons actions qui naviguent
- [ ] Navigation back cohérente
- [ ] Mode sombre/clair adaptatif

### Qualité visuelle
- [ ] 60 FPS constant pendant les animations
- [ ] Aucun jank visible
- [ ] Couleurs cohérentes partout
- [ ] Texte lisible à toutes les tailles
- [ ] Boutons réactifs au touch

## 📞 Support

### En cas de problème
1. **Vérifier Flutter** : `flutter doctor`
2. **Clean rebuild** : `flutter clean && flutter pub get`
3. **Redémarrer l'éditeur** : VS Code/Android Studio
4. **Tester sur émulateur différent**

### Ressources utiles
- [Flutter Documentation](https://flutter.dev/docs)
- [Material 3 Guidelines](https://m3.material.io/)
- [Riverpod Documentation](https://riverpod.dev/)

---

**🎉 Amusez-vous bien avec AgriShield AI !**

*L'interface est conçue pour impressionner - n'hésitez pas à explorer toutes les animations et transitions !*
