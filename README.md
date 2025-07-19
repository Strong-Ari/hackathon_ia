# 🌱 AgriShield AI - Application Mobile Flutter

**L'IA veille sur vos cultures** - Une application mobile complète pour l'agriculture intelligente avec IA intégrée.

## 🎯 Vue d'ensemble

AgriShield AI est une application Flutter moderne conçue pour révolutionner l'agriculture grâce à l'intelligence artificielle. Elle offre deux expériences distinctes :

- **👨‍🌾 Espace Producteur** : Surveillance en temps réel, diagnostic IA, rapports automatisés
- **🧑‍🍳 Espace Consommateur** : Découverte de produits locaux certifiés de qualité

## ✨ Fonctionnalités Principales

### 🏠 Écran d'Accueil
- **Design ultra-moderne** avec animations fluides
- **Choix d'espace** intuitif (Producteur/Consommateur)
- **Fond animé** avec particules flottantes
- **Transitions premium** entre les écrans

### 👨‍🌾 Espace Producteur

#### 📊 Tableau de Bord
- **Métriques en temps réel** : température, humidité, sol, capteurs
- **Gauge de santé globale** avec animation circulaire personnalisée
- **Cartes de données** avec tendances et alertes visuelles
- **Interface responsive** optimisée pour tous les écrans

#### 📱 Scanner IA
- **Diagnostic instantané** des maladies des plantes
- **Interface caméra** avec overlay d'analyse
- **Résultats en temps réel** avec recommandations
- **Historique des scans** avec détails complets

#### 📄 Rapports PDF
- **Génération automatique** de rapports détaillés
- **Métriques d'exploitation** avec graphiques
- **Recommandations IA** formatées professionnellement
- **Heatmap intégrée** avec Google Maps
- **Signature numérique** avec validation IA

### 🧑‍🍳 Espace Consommateur

#### 🛒 Marketplace
- **Produits locaux certifiés** avec garantie qualité
- **Système de notation** A+/A/B avec couleurs
- **Recherche avancée** par catégories
- **Certification AgriShield** pour tous les producteurs

#### 📍 Traçabilité
- **Distance producteur** affichée en temps réel
- **Score de fraîcheur** calculé par IA
- **Origine locale** garantie et vérifiée

## 🎨 Design System

### 🎨 Couleurs
```dart
// Palette Nature-Tech
- Vert Principal: #2E7D32 (Primary Green)
- Or Accent: #FFB300 (Accent Gold)  
- Beige Naturel: #F5F5DC (Background)
- Statuts: Vert/Orange/Rouge pour santé des plantes
```

### 🔤 Typographie
- **Police principale** : Poppins (Google Fonts)
- **Hiérarchie claire** : Display/Headline/Title/Body/Label
- **Poids variables** : 400 à 700 selon le contexte

### 🎭 Animations
- **Flutter Animate** pour les transitions fluides
- **Animations personnalisées** avec CustomPainter
- **Micro-interactions** sur tous les éléments tactiles
- **Particules flottantes** en arrière-plan

## 🏗️ Architecture Technique

### 📁 Structure du Projet
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        # Palette de couleurs
│   │   └── app_dimensions.dart    # Espacements et tailles
│   ├── models/
│   │   └── plant_diagnosis.dart   # Modèles de données
│   └── providers/
│       └── router_provider.dart   # Navigation GoRouter
├── ui/
│   ├── pages/
│   │   ├── splash_page.dart       # Écran de démarrage animé
│   │   ├── home_page.dart         # Sélection d'espace
│   │   ├── producer_dashboard.dart # Tableau de bord producteur
│   │   ├── consumer_home.dart     # Marketplace consommateur
│   │   └── ...                    # Autres écrans
│   ├── widgets/
│   │   └── agri_button.dart       # Bouton personnalisé
│   └── theme/
│       └── app_theme.dart         # Thème Material 3
└── main.dart                      # Point d'entrée
```

### 🔧 Technologies Utilisées
- **Flutter 3.8+** avec Material 3
- **Riverpod** pour la gestion d'état
- **GoRouter** pour la navigation déclarative
- **Flutter Animate** pour les animations
- **Phosphor Icons** pour l'iconographie moderne
- **Google Fonts** (Poppins) pour la typographie

### 📱 Packages Principaux
```yaml
dependencies:
  flutter_riverpod: ^2.5.1    # État réactif
  go_router: ^16.0.0          # Navigation
  flutter_animate: ^4.5.0     # Animations
  google_fonts: ^6.2.1        # Typographie
  phosphor_flutter: ^2.1.0    # Icônes modernes
  camera: ^0.11.2             # Caméra pour scanner
  google_maps_flutter: ^2.6.1 # Cartes
  pdf: ^3.10.8                # Génération PDF
```

## 🚀 Installation et Démarrage

### Prérequis
- Flutter SDK 3.8+
- Dart 3.0+
- Android Studio / VS Code
- Émulateur Android/iOS ou appareil physique

### Installation
```bash
# Cloner le projet
git clone [repository-url]
cd agrischield_ai

# Installer les dépendances
flutter pub get

# Générer les fichiers (si nécessaire)
flutter packages pub run build_runner build

# Lancer l'application
flutter run
```

### Configuration
1. **Permissions** : Caméra, localisation, stockage
2. **API Keys** : Google Maps, services IA (à configurer)
3. **Environnement** : Debug/Release selon le contexte

## 🎭 Expérience Utilisateur

### 🎨 Animations et Transitions
- **Splash Screen** : Logo qui pulse avec transformation plante → circuit
- **Navigation** : Slides latéraux et fades selon le contexte
- **Cartes** : Apparition en cascade avec delays échelonnés
- **Interactions** : Scale et glow sur tous les boutons tactiles

### 📱 Responsive Design
- **Portrait uniquement** pour une expérience mobile optimale
- **Adaptation automatique** aux différentes tailles d'écran
- **Safe Areas** respectées sur tous les appareils
- **Densité de pixels** fixée pour une cohérence visuelle

### ♿ Accessibilité
- **Contrastes élevés** pour une lisibilité optimale
- **Tailles de police** adaptatives selon les préférences système
- **Navigation clavier** pour les utilisateurs avec handicaps
- **Feedback haptique** sur les interactions importantes

## 🔮 Fonctionnalités à Venir

### 🤖 Intégrations IA
- [ ] **Modèle TensorFlow Lite** pour diagnostic offline
- [ ] **Vision par ordinateur** pour analyse des cultures
- [ ] **Prédictions météo** avec recommandations
- [ ] **Optimisation des rendements** par machine learning

### 🌐 Connectivité
- [ ] **API Backend** pour synchronisation cloud
- [ ] **Notifications push** pour alertes critiques
- [ ] **Mode hors ligne** avec synchronisation différée
- [ ] **Partage social** des succès agricoles

### 📊 Analytics
- [ ] **Tableaux de bord avancés** avec graphiques interactifs
- [ ] **Rapports personnalisés** par période/culture
- [ ] **Comparaisons régionales** avec anonymisation
- [ ] **Prédictions saisonnières** basées sur l'historique

## 🤝 Contribution

Ce projet est conçu pour être **facilement extensible** :

1. **Architecture modulaire** avec séparation claire des responsabilités
2. **Design system cohérent** pour une intégration harmonieuse
3. **Documentation inline** avec TODO pour les futures fonctionnalités
4. **Tests unitaires** (à implémenter) pour la robustesse

### Ajout de Fonctionnalités
```dart
// Exemple d'ajout d'une nouvelle page
class NewFeaturePage extends StatefulWidget {
  // Suivre le pattern existant avec AnimationController
  // Utiliser le design system (AppColors, AppDimensions)
  // Intégrer les animations Flutter Animate
}
```

## 📄 Licence

Projet développé pour **AgriShield AI** - Tous droits réservés © 2024

---

**🌱 L'agriculture de demain commence aujourd'hui avec AgriShield AI**

