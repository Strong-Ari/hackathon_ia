# 🏗️ Guide d'Architecture - AgriShield AI

## Vue d'ensemble

AgriShield AI suit une architecture **Clean Architecture** avec **Feature-First** pour maintenir la séparation des préoccupations et faciliter la maintenance.

## 📁 Structure des dossiers

```
lib/
├── main.dart                           # Point d'entrée de l'application
├── core/                              # Couche de base (shared)
│   ├── constants/                     # Constantes globales
│   │   ├── app_colors.dart           # Palette de couleurs
│   │   └── app_dimensions.dart       # Dimensions et espacements
│   ├── models/                       # Modèles de données
│   │   └── plant_diagnosis.dart      # Modèle de diagnostic
│   ├── providers/                    # Providers Riverpod globaux
│   │   └── router_provider.dart      # Configuration navigation
│   └── services/                     # Services (à implémenter)
│       ├── ai_service.dart          # Service IA
│       ├── camera_service.dart      # Service caméra
│       └── storage_service.dart     # Service stockage
└── ui/                               # Couche présentation
    ├── pages/                        # Écrans de l'application
    │   ├── splash_page.dart         # Écran de démarrage
    │   ├── home_page.dart           # Écran d'accueil
    │   ├── scan_page.dart           # Scanner IA
    │   ├── diagnosis_page.dart      # Résultats diagnostic
    │   ├── actions_page.dart        # Recommandations IA
    │   ├── report_page.dart         # Génération rapport
    │   ├── map_page.dart            # Carte communautaire
    │   ├── sentinel_page.dart       # Mode surveillance
    │   └── history_page.dart        # Historique
    ├── widgets/                      # Composants réutilisables
    │   └── agri_button.dart         # Bouton personnalisé
    └── theme/                        # Configuration thème
        └── app_theme.dart           # Thème Material 3
```

## 🔄 Flow de données

### Pattern utilisé : **Riverpod + MVVM**

```
UI (View) ↔ Controller (Provider) ↔ Service ↔ Data Source
```

1. **UI (Pages/Widgets)** : Présentation pure, réactive aux changements d'état
2. **Controllers (Providers)** : Logique métier, gestion d'état
3. **Services** : Couche d'abstraction pour les APIs et fonctionnalités
4. **Data Sources** : Accès aux données (API, base locale, caméra, etc.)

### Exemple de flow pour le scanner
```dart
ScanPage → scanProvider → CameraService → AI Analysis → DiagnosisModel
```

## 🎨 Gestion du thème

### Material 3 avec personnalisation

Le thème suit une approche **design tokens** pour la cohérence :

```dart
// Couleurs sémantiques
primary: AppColors.primaryGreen        // Actions principales
secondary: AppColors.accentGold        // Actions secondaires
surface: AppColors.surfaceLight        // Arrière-plans
error: AppColors.statusDanger          // États d'erreur

// Mapping contextuel
healthy → statusHealthy                // Plante saine
warning → statusWarning                // Attention requise
danger → statusDanger                  // Action urgente
```

### Responsive design
- **Breakpoints** : Mobile-first (< 480px)
- **Dimensions** : Utilisation d'`AppDimensions` pour la cohérence
- **Densité** : Adaptation automatique selon l'écran

## 🧭 Navigation et routing

### go_router avec transitions custom

```dart
// Configuration centralisée dans router_provider.dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      // Routes avec transitions personnalisées
      GoRoute(
        path: '/scan',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ScanPage(),
          transitionsBuilder: slideUpTransition,
        ),
      ),
    ],
  );
});
```

### Types de transitions

| Transition | Usage | Animation |
|------------|-------|-----------|
| **Fade** | Splash → Home | Fondu simple |
| **Slide** | Navigation principale | Glissement |
| **Hero** | Scanner button | Transformation continue |
| **Scale** | Modal/Popup | Zoom depuis le centre |

## 🎭 Animations et micro-interactions

### Librairies utilisées
- **flutter_animate** : Animations déclaratives
- **AnimationController** : Animations custom complexes
- **Hero** : Transitions d'éléments partagés

### Pattern d'animation
```dart
class AnimatedPage extends StatefulWidget {
  @override
  _AnimatedPageState createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with TickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 200));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return widget
        .animate(controller: _controller)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0.0);
  }
}
```

## 🔧 Gestion d'état avec Riverpod

### Types de providers

```dart
// Provider simple (données immutables)
final configProvider = Provider<AppConfig>((ref) {
  return AppConfig();
});

// StateProvider (état mutable simple)
final scanningStateProvider = StateProvider<bool>((ref) => false);

// NotifierProvider (logique complexe)
final diagnosisProvider = NotifierProvider<DiagnosisNotifier, List<PlantDiagnosis>>(() {
  return DiagnosisNotifier();
});

// AsyncNotifierProvider (données asynchrones)
final plantAnalysisProvider = AsyncNotifierProvider<PlantAnalysisNotifier, PlantDiagnosis?>(() {
  return PlantAnalysisNotifier();
});
```

### Bonnes pratiques Riverpod

1. **Granularité** : Un provider par responsabilité
2. **Naming** : Suffixe Provider pour la clarté
3. **Composition** : Combinaison de providers simples
4. **Testing** : Override facile pour les tests

## 📱 Patterns UI

### Composants réutilisables

Tous les composants suivent le pattern **Configuration over Convention** :

```dart
// Exemple : AgriButton
AgriButton(
  text: 'Scanner une plante',
  type: AgriButtonType.scanner,     // Définit l'apparence
  size: AgriButtonSize.large,       // Définit les dimensions
  enableGlow: true,                 // Active l'effet glow
  enablePulse: true,                // Active l'animation pulse
  heroTag: 'scanner_button',        // Pour les Hero transitions
  onPressed: () => context.push('/scan'),
)
```

### Page structure standard

```dart
class StandardPage extends StatefulWidget {
  @override
  _StandardPageState createState() => _StandardPageState();
}

class _StandardPageState extends State<StandardPage>
    with TickerProviderStateMixin {

  // 1. Animation controllers
  late AnimationController _contentController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startAnimations();
  }

  // 2. Structure du build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildBackground(),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),      // En-tête avec navigation
              _buildContent(),     // Contenu principal animé
              _buildActions(),     // Actions utilisateur
            ],
          ),
        ),
      ),
    );
  }

  // 3. Méthodes de construction spécialisées
  Widget _buildHeader() => ...;
  Widget _buildContent() => ...;
  Widget _buildActions() => ...;
}
```

## ⚡ Performance et optimisation

### Optimisations implémentées

1. **Widget rebuilds** : Utilisation de `AnimatedBuilder` pour les animations
2. **Memory management** : Disposal automatique des controllers
3. **Lazy loading** : Chargement à la demande des pages
4. **Image optimization** : Compression et mise en cache

### Métriques surveillées
- **Frame rate** : 60 FPS constant
- **Memory usage** : < 100MB en utilisation normale
- **Battery impact** : Minimal grâce aux animations optimisées

## 🧪 Testing strategy

### Types de tests
```dart
// Widget tests
testWidgets('AgriButton should show loading state', (tester) async {
  await tester.pumpWidget(
    AgriButton(
      text: 'Test',
      isLoading: true,
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

// Provider tests
void main() {
  test('DiagnosisNotifier should add new diagnosis', () {
    final container = ProviderContainer();
    final notifier = container.read(diagnosisProvider.notifier);

    notifier.addDiagnosis(mockDiagnosis);

    expect(container.read(diagnosisProvider), contains(mockDiagnosis));
  });
}
```

## 🔮 Extensions futures

### Architecture modulaire préparée

L'architecture actuelle facilite l'ajout de :

1. **Modules IA** : Intégration Gemini/TensorFlow
2. **Backend services** : Firebase/Supabase
3. **Synchronisation** : Données multi-device
4. **Analytics** : Tracking comportement utilisateur
5. **Notifications** : Push notifications intelligentes

### Patterns à suivre

Pour ajouter une nouvelle fonctionnalité :

1. **Modèle** : Créer dans `core/models/`
2. **Service** : Implémenter dans `core/services/`
3. **Provider** : Ajouter dans `core/providers/`
4. **UI** : Page dans `ui/pages/` + widgets dans `ui/widgets/`
5. **Navigation** : Route dans `router_provider.dart`

## 📋 Checklist développement

### Avant chaque commit
- [ ] Tests passent (widget + unit)
- [ ] Pas de warnings lint
- [ ] Performance acceptable (no jank)
- [ ] Animations fluides
- [ ] Navigation cohérente
- [ ] Gestion d'erreurs implémentée

### Code review
- [ ] Architecture respectée
- [ ] Patterns suivis
- [ ] Documentation à jour
- [ ] Accessibilité prise en compte
- [ ] Responsive design validé

---

Cette architecture garantit une base solide pour l'évolution d'AgriShield AI tout en maintenant la qualité et les performances.
