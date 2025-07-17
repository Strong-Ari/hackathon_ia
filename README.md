# 🌱 AgriShield AI - L'IA veille sur vos cultures

Une application mobile d'agritech intelligente pour petits agriculteurs, conçue pour fonctionner même hors ligne et offrir une expérience utilisateur exceptionnelle.

## 🎯 Fonctionnalités principales

### 📷 Scanner IA de maladies
- Interface scanner type Google Lens avec animations fluides
- Détection automatique des maladies des plantes
- Diagnostic instantané avec score de confiance IA
- Support hors ligne avec modèles IA intégrés

### 🔍 Diagnostic intelligent
- Analyse détaillée des maladies détectées
- Estimation des pertes potentielles
- Classification par type (fongique, bactérienne, virale, etc.)
- Niveau de gravité avec code couleur

### 🤖 Recommandations IA
- Actions personnalisées basées sur l'IA
- Traitements recommandés avec timeline
- Conseils de prévention
- Estimation des coûts

### 🗺️ Carte communautaire
- Visualisation des alertes locales
- Heatmap des maladies par région
- Signalement collaboratif
- Données en temps réel

### 🛡️ Mode Sentinelle
- Surveillance automatique programmée
- Alertes proactives
- Analyse périodique
- Notifications intelligentes

## 🎨 Design & UX

### Interface utilisateur
- **Material 3** avec personnalisation poussée
- **Thème nature-tech** (vert, beige, doré)
- **Animations fluides** avec flutter_animate et Lottie
- **Responsive design** optimisé pour mobile
- **Mode sombre et clair** automatique

### Animations clés
- **Splash screen** : Transformation plante → circuit IA
- **Scanner** : Overlay animé avec particules et laser
- **Transitions** : Hero animations entre les écrans
- **Feedback** : Micro-interactions sur chaque action

### Accessibilité
- **Offline-first** : Fonctionne sans connexion
- **Contraste élevé** : Lisible en extérieur
- **Feedback haptique** : Confirmations tactiles
- **Navigation intuitive** : Flow logique et fluide

## 🏗️ Architecture technique

### Structure du projet
```
lib/
├── main.dart                    # Point d'entrée
├── core/
│   ├── constants/              # Couleurs, dimensions, etc.
│   ├── models/                 # Modèles de données
│   ├── providers/              # État global (Riverpod)
│   └── services/               # Services (IA, API, etc.)
└── ui/
    ├── pages/                  # Écrans de l'application
    ├── widgets/                # Composants réutilisables
    └── theme/                  # Thème Material 3
```

### Stack technologique
- **Flutter 3.22+** : Framework UI multiplateforme
- **Riverpod** : Gestion d'état réactive
- **go_router** : Navigation déclarative
- **flutter_animate** : Animations avancées
- **Google Fonts** : Typographie Poppins
- **Material 3** : Design system moderne

### Dépendances principales
- `flutter_riverpod` : État global et réactivité
- `go_router` : Navigation avec transitions
- `flutter_animate` : Animations fluides
- `google_fonts` : Polices personnalisées
- `lottie` : Animations complexes
- `camera` : Capture d'images
- `google_maps_flutter` : Cartes interactives

## 🚀 Installation et lancement

### Prérequis
- **Flutter SDK 3.22+**
- **Dart 3.8+**
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Installation
```bash
# Cloner le projet
git clone <repository-url>
cd agrischield-ai

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Configuration
1. **Assets** : Ajouter les images dans `assets/images/`
2. **Fonts** : Installer les polices Poppins dans `assets/fonts/`
3. **API Keys** : Configurer les clés pour Google Maps et services IA

## 📱 Flow de navigation

### Parcours principal
1. **Splash** (`/`) → Animation logo avec transformation
2. **Accueil** (`/home`) → Hub principal avec bouton scanner
3. **Scanner** (`/scan`) → Interface caméra avec overlay IA
4. **Diagnostic** (`/diagnosis`) → Résultats d'analyse détaillés
5. **Actions** (`/actions`) → Recommandations IA personnalisées
6. **Rapport** (`/report`) → Génération PDF et partage

### Fonctionnalités annexes
- **Carte** (`/map`) → Visualisation communautaire
- **Sentinelle** (`/sentinel`) → Configuration surveillance
- **Historique** (`/history`) → Analyses précédentes

### Transitions animées
| De → Vers | Animation |
|-----------|-----------|
| Splash → Home | Fade + ScaleUp |
| Home → Scan | Hero + SlideUp |
| Scan → Diagnosis | Fade + Glitch IA |
| Diagnosis → Actions | SlideLeft |
| Actions → Report | ScaleIn |

## 🎨 Guide de style

### Palette de couleurs
```dart
// Couleurs principales
primaryGreen: #2E7D32      // Vert nature principal
primaryGreenLight: #4CAF50 // Vert clair
accentGold: #FFB300        // Or accent

// Couleurs de statut
statusHealthy: #4CAF50     // Plante saine
statusWarning: #FF9800     // Attention
statusDanger: #E53935      // Danger
statusCritical: #D32F2F    // Critique
```

### Typographie
- **Famille** : Poppins (Google Fonts)
- **Poids** : 300 (Light) à 700 (Bold)
- **Hiérarchie** : displayLarge → bodySmall
- **Espacement** : Optimisé pour la lisibilité mobile

### Espacements
- **XS** : 4px | **SM** : 8px | **MD** : 16px
- **LG** : 24px | **XL** : 32px | **XXL** : 48px

## 🔮 Intégrations futures

### IA et Backend
- **Gemini AI** : Analyse avancée des images
- **Firebase** : Authentification et stockage
- **Cloud Functions** : Traitement côté serveur
- **ML Kit** : Reconnaissance on-device

### Fonctionnalités avancées
- **Réalité augmentée** : Superposition d'informations
- **IoT Integration** : Capteurs connectés
- **Chatbot IA** : Assistant conversationnel
- **Analytics** : Tableau de bord agriculteur

## 👥 Contribution

### Structure de développement
1. **Feature branches** : `feature/nom-fonctionnalite`
2. **Commits conventionnels** : `feat:`, `fix:`, `ui:`, etc.
3. **Tests requis** : Widget tests pour tous les composants
4. **Documentation** : Dartdoc pour toutes les API publiques

### Standards de code
- **Linting** : Utilisation de `flutter_lints`
- **Formatting** : `dart format` automatique
- **Architecture** : Separation of concerns stricte
- **Performance** : Optimisation des rebuilds

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

**Développé avec ❤️ pour les agriculteurs du monde entier**

*AgriShield AI - Quand l'intelligence artificielle rencontre l'agriculture traditionnelle*

