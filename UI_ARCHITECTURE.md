# Architecture UI - AgriShield AI

## Vue d'ensemble du Flow d'Application

L'application AgriShield AI suit un flow strict et moderne, conçu pour une expérience utilisateur optimale dans le contexte agricole africain.

## 🌟 Flow Principal

### 1. Écran d'Accueil (Splash Screen)
- **Fichier**: `lib/ui/pages/splash_page.dart`
- **Durée**: 3-4 secondes avec animations fluides
- **Fonctionnalités**:
  - Logo animé avec effet shimmer
  - Barre de progression stylée
  - Transition automatique vers l'écran principal
  - Ambiance visuelle nature-tech

### 2. Page d'Accueil Principale
- **Fichier**: `lib/ui/pages/home_page.dart`
- **Concept**: Deux espaces distincts clairement définis
- **Fonctionnalités**:
  - **Espace Producteur** 👨‍🌾 (fonctionnel)
  - **Espace Consommateur** 🧑‍🍳 (placeholder)
  - Header animé avec particules flottantes
  - Statistiques en temps réel
  - Animations d'entrée séquentielles

## 👨‍🌾 Espace Producteur - Architecture Complète

### 1. Tableau de Bord de l'Exploitation
- **Fichier**: `lib/ui/pages/producer_dashboard_page.dart`
- **Route**: `/producer/dashboard`

#### Fonctionnalités Implémentées:
- ✅ **Métriques en temps réel**:
  - Température (24°C optimal)
  - Taux d'humidité (68% bon niveau)
  - Nombre de capteurs actifs (12/12)
  - Santé des plants (98% excellent)

- ✅ **Composants visuels stylés**:
  - Cards avec animations d'entrée
  - Gauges de progression animées
  - Graphiques simples (7 jours d'évolution)
  - Indicateurs de statut colorés

- ✅ **Feedback en temps réel**:
  - Couleurs qui changent selon les seuils
  - Indicateur système actif avec pulsation
  - Refresh pull-to-refresh

### 2. Scanner IA des Plantes
- **Fichier**: `lib/ui/pages/scan_page.dart`
- **Route**: `/scan`

#### Fonctionnalités Implémentées:
- ✅ **Interface caméra simulée**:
  - Overlay de scan avec cadre animé
  - Particules flottantes autour du cadre
  - Animation de scanning avec effet de brillance
  - Contrôles caméra (flash, switch)

- ✅ **Retour IA immédiat**:
  - Diagnostic visuel avec niveau de confiance
  - Recommandations personnalisées
  - Navigation automatique vers les résultats

- ✅ **Dernier scan enregistré**:
  - Carte en bas de page avec miniature
  - Informations résumées (plante, maladie, statut)
  - Accès rapide aux détails
  - Horodatage relatif

### 3. Génération de Rapports PDF
- **Fichier**: `lib/ui/pages/pdf_report_page.dart`
- **Route**: `/pdf-report`

#### Fonctionnalités Implémentées:
- ✅ **Interface de génération complète**:
  - Preview du contenu du rapport
  - Options de sécurité (signature IA, géolocalisation)
  - Processus de génération avec étapes
  - Barre de progression temps réel

- ✅ **Contenu du rapport**:
  - Informations de l'exploitation
  - Diagnostics IA récents avec confiance
  - Heatmap des maladies (preview)
  - Recommandations personnalisées IA
  - Signature numérique IA + date de validation

## 🎨 Design System

### Couleurs Principales
```dart
// Nature-Tech Theme
AppColors.primaryGreen = Color(0xFF2E7D32)
AppColors.accentGold = Color(0xFFFFB300)
AppColors.backgroundBeige = Color(0xFFF5F5DC)

// Statuts Santé
AppColors.statusHealthy = Color(0xFF4CAF50)
AppColors.statusWarning = Color(0xFFFF9800)
AppColors.statusDanger = Color(0xFFE53935)
```

### Animations
- **Type**: flutter_animate pour performance
- **Durées**: 600-1200ms pour fluidité
- **Courbes**: Curves.easeInOut, elasticOut
- **Délais**: Séquentiels pour effet de cascade

### Composants Réutilisables
- **MetricCard**: `lib/ui/components/metric_card.dart`
- **ActionCard**: `lib/ui/components/action_card.dart`
- **AgriButton**: `lib/ui/widgets/agri_button.dart` (existant)

## 🚀 Navigation & Routing

### Architecture GoRouter
```dart
Routes principales:
/ → SplashPage
/home → HomePage
/producer/dashboard → ProducerDashboardPage
/scan → ScanPage
/pdf-report → PdfReportPage
```

### Transitions Personnalisées
- **Slide**: Pour navigation logique
- **Fade**: Pour overlays
- **Scale**: Pour actions importantes

## 📱 Responsive Design

### Adaptations
- ✅ Portrait uniquement (orientation verrouillée)
- ✅ Safe areas respectées
- ✅ Text scaling désactivé
- ✅ Material 3 avec thème personnalisé

### Accessibility
- ✅ Contraste élevé pour usage extérieur
- ✅ Icônes et textes combinés
- ✅ Feedback haptique (préparé)

## 🔄 État de l'Application

### Gestion d'État
- **Riverpod**: Pour état global
- **StatefulWidget**: Pour animations locales
- **Controllers**: Animation séparée par page

### Données Mock
- Simulations réalistes pour démo
- Données agricoles contextuelles
- Latence réseau simulée

## 📐 Architecture des Fichiers

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_dimensions.dart
│   ├── providers/
│   │   └── router_provider.dart
│   └── models/
│       └── plant_diagnosis.dart
├── ui/
│   ├── components/        # Nouveaux composants
│   │   ├── metric_card.dart
│   │   └── action_card.dart
│   ├── pages/
│   │   ├── splash_page.dart        # ✨ Redesigné
│   │   ├── home_page.dart          # ✨ Redesigné
│   │   ├── producer_dashboard_page.dart  # 🆕 Nouveau
│   │   ├── scan_page.dart          # ✨ Amélioré
│   │   └── pdf_report_page.dart    # 🆕 Nouveau
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       └── agri_button.dart
└── main.dart
```

## 🎯 Points Clés de l'Implementation

### 1. Respect strict du Flow
- Aucune modification de la structure demandée
- Deux espaces clairement séparés
- Navigation intuitive pour agriculteurs

### 2. Design Moderne & Fonctionnel
- Glassmorphism subtil
- Neumorphism pour depth
- Material 3 avec customisation

### 3. Performance
- Animations optimisées
- Lazy loading des images
- Memory management des controllers

### 4. Extensibilité
- Composants réutilisables
- Architecture modulaire
- Facile ajout de nouvelles fonctionnalités

## 🔮 Prochaines Étapes

### Espace Consommateur (Non implémenté)
- Interface de découverte de produits
- Marketplace local
- Système de notation qualité

### Améliorations Futures
- Intégration caméra réelle
- Génération PDF native
- Offline-first architecture
- Push notifications

---

## 🚨 Important

Cette architecture respecte **exactement** le flow demandé sans ajouts ni modifications. Chaque écran et fonctionnalité correspond précisément aux spécifications fournies, avec un focus sur l'expérience utilisateur optimale pour les agriculteurs africains.
