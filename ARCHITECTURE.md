# 🏗️ Architecture AgriShield AI

## Vue d'ensemble

AgriShield AI suit une architecture **modulaire et scalable** basée sur les meilleures pratiques Flutter avec une séparation claire des responsabilités.

## 📁 Structure du Projet

```
lib/
├── main.dart                       # Point d'entrée de l'application
├── core/                          # Logique métier et utilitaires
│   ├── constants/                 # Constantes de l'application
│   │   ├── app_colors.dart       # Palette de couleurs
│   │   ├── app_dimensions.dart   # Espacements et dimensions
│   │   └── app_constants.dart    # Textes et configurations
│   ├── models/                   # Modèles de données
│   │   └── plant_diagnosis.dart  # Modèle de diagnostic IA
│   └── providers/               # Gestion d'état et navigation
│       └── router_provider.dart # Configuration GoRouter
├── ui/                          # Interface utilisateur
│   ├── pages/                   # Écrans de l'application
│   │   ├── splash_page.dart     # Écran de démarrage animé
│   │   ├── home_page.dart       # Sélection d'espace utilisateur
│   │   ├── producer_dashboard.dart # Tableau de bord producteur
│   │   ├── consumer_home.dart   # Marketplace consommateur
│   │   ├── scan_page.dart       # Interface scanner IA
│   │   ├── diagnosis_page.dart  # Résultats de diagnostic
│   │   ├── actions_page.dart    # Recommandations IA
│   │   ├── report_page.dart     # Génération de rapports
│   │   ├── map_page.dart        # Carte communautaire
│   │   ├── sentinel_page.dart   # Mode surveillance
│   │   └── history_page.dart    # Historique des analyses
│   ├── widgets/                 # Composants réutilisables
│   │   ├── agri_button.dart     # Bouton personnalisé animé
│   │   └── metric_card.dart     # Carte de métrique avec animations
│   └── theme/                   # Design system
│       └── app_theme.dart       # Thème Material 3 personnalisé
└── assets/                      # Ressources statiques (si nécessaire)
```

## 🎯 Principes Architecturaux

### 1. **Separation of Concerns**
- **Core** : Logique métier, modèles, constantes
- **UI** : Interface utilisateur et interactions
- **Providers** : Gestion d'état et navigation

### 2. **Composition over Inheritance**
- Widgets composés de petits composants réutilisables
- Mixins pour les animations répétitives
- Extensions pour enrichir les types existants

### 3. **Reactive Programming**
- Riverpod pour la gestion d'état réactive
- AnimationController pour les animations fluides
- Stream-based pour les données temps réel (futures)

## 🔧 Technologies et Patterns

### Framework et Packages
```yaml
# Core Framework
flutter: ^3.8.0
flutter_riverpod: ^2.5.1  # State management

# Navigation
go_router: ^16.0.0         # Declarative routing

# UI & Animations
flutter_animate: ^4.5.0    # Advanced animations
google_fonts: ^6.2.1       # Typography
phosphor_flutter: ^2.1.0   # Modern icons

# Device Integration
camera: ^0.11.2            # Camera access
google_maps_flutter: ^2.6.1 # Maps integration
pdf: ^3.10.8               # PDF generation
```

### Design Patterns Utilisés

#### 1. **Provider Pattern** (Riverpod)
```dart
// Exemple de provider pour l'état global
final farmDataProvider = StateNotifierProvider<FarmDataNotifier, FarmData>((ref) {
  return FarmDataNotifier();
});
```

#### 2. **Repository Pattern** (Future)
```dart
// Interface pour l'accès aux données
abstract class PlantDiagnosisRepository {
  Future<PlantDiagnosis> scanPlant(File image);
  Future<List<PlantDiagnosis>> getHistory();
}
```

#### 3. **Builder Pattern** (Widgets)
```dart
// Construction flexible des cartes de métriques
MetricCard.builder()
  .title('Température')
  .value('24.5°C')
  .icon(PhosphorIcons.thermometer)
  .trend('+2.1°')
  .build();
```

## 🎨 Design System

### Thème Material 3
- **ColorScheme** : Générée à partir de `seedColor`
- **Typography** : Poppins avec hiérarchie claire
- **Components** : Boutons, cartes, inputs personnalisés

### Animations
- **Flutter Animate** : Transitions et micro-interactions
- **CustomPainter** : Gauges circulaires et graphiques
- **Hero Animations** : Transitions entre écrans

### Responsive Design
- **Breakpoints** : Mobile-first avec adaptation tablette
- **SafeArea** : Gestion des encoches et barres système
- **MediaQuery** : Adaptation aux différentes tailles d'écran

## 📱 Flow de Navigation

### Navigation Déclarative (GoRouter)
```dart
// Configuration des routes avec transitions
GoRoute(
  path: '/producer',
  pageBuilder: (context, state) => CustomTransitionPage(
    child: ProducerDashboardPage(),
    transitionsBuilder: slideTransition,
  ),
)
```

### Hiérarchie des Écrans
```
Splash (/) 
  └── Home (/home)
      ├── Producer Dashboard (/producer)
      │   ├── Scanner (tab)
      │   ├── Reports (tab)
      │   └── Settings (future)
      └── Consumer Home (/consumer)
          ├── Products List
          ├── Product Detail (future)
          └── Cart (future)
```

## 🔄 Gestion d'État

### Architecture Riverpod
```dart
// État local des composants
class _DashboardPageState extends State<DashboardPage> {
  // AnimationControllers et état UI local
}

// État global de l'application
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// État dérivé et calculé
final healthPercentageProvider = Provider<double>((ref) {
  final farmData = ref.watch(farmDataProvider);
  return calculateHealthPercentage(farmData);
});
```

## 🎭 Système d'Animation

### Types d'Animations
1. **Entrance** : Fade + Scale + Slide
2. **Transition** : Hero + Custom transitions
3. **Micro-interactions** : Hover, tap, loading states
4. **Background** : Particules flottantes, gradients animés

### Performance
- **AnimationController** : Réutilisation et disposal correct
- **Intervals** : Animations séquentielles optimisées
- **Curves** : Easing naturel pour un feeling premium

## 🔮 Extensibilité Future

### Architecture Prête pour
1. **Backend Integration**
   ```dart
   // Service abstrait pour API calls
   abstract class ApiService {
     Future<T> get<T>(String endpoint);
     Future<T> post<T>(String endpoint, Map<String, dynamic> data);
   }
   ```

2. **Offline-First**
   ```dart
   // Repository avec cache local
   class CachedPlantDiagnosisRepository implements PlantDiagnosisRepository {
     final LocalDatabase _db;
     final ApiService _api;
   }
   ```

3. **Internationalization**
   ```dart
   // Structure prête pour l10n
   class AppLocalizations {
     static String of(BuildContext context, String key) => 
       _localizedValues[Localizations.localeOf(context)]![key]!;
   }
   ```

4. **Testing**
   ```dart
   // Structure testable avec injection de dépendances
   void main() {
     testWidgets('Dashboard displays metrics correctly', (tester) async {
       await tester.pumpWidget(
         ProviderScope(
           overrides: [
             farmDataProvider.overrideWith(() => MockFarmDataNotifier()),
           ],
           child: MaterialApp(home: ProducerDashboardPage()),
         ),
       );
     });
   }
   ```

## 📊 Métriques et Performance

### Optimisations Appliquées
- **const constructors** : Réduction des rebuilds
- **AnimatedBuilder** : Rebuilds ciblés
- **RepaintBoundary** : Isolation des repaints coûteux
- **Image caching** : Optimisation des assets

### Monitoring (Future)
- **Firebase Crashlytics** : Crash reporting
- **Firebase Performance** : Métriques de performance
- **Custom analytics** : Usage tracking

## 🔐 Sécurité et Qualité

### Standards de Code
- **Flutter Lints** : Règles strictes de qualité
- **Dart Format** : Formatage automatique
- **Documentation** : Dartdoc pour toutes les API publiques

### Sécurité
- **Permissions** : Demande explicite et justifiée
- **Data validation** : Validation côté client et serveur
- **Secure storage** : Chiffrement des données sensibles

## 🚀 Déploiement

### Build Configuration
```yaml
# android/app/build.gradle
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
    }
}
```

### CI/CD (Future)
- **GitHub Actions** : Build automatique
- **Firebase App Distribution** : Distribution beta
- **Play Store** : Déploiement automatisé

---

**Cette architecture garantit une application maintenable, performante et évolutive pour AgriShield AI** 🌱
