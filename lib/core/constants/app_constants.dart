class AppConstants {
  // Informations de l'application
  static const String appName = 'AgriShield AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'L\'IA veille sur vos cultures';
  static const String copyright = '© 2024 AgriShield AI';

  // Messages d'interface
  static const String welcomeMessage = 'Choisissez votre espace';
  static const String producerTitle = 'Espace Producteur';
  static const String producerSubtitle = 'Surveillez vos cultures avec l\'IA';
  static const String consumerTitle = 'Espace Consommateur';
  static const String consumerSubtitle = 'Découvrez des produits de qualité';

  // Messages du tableau de bord producteur
  static const String dashboardTitle = 'Tableau de bord';
  static const String farmName = 'Exploitation AgriShield';
  static const String onlineStatus = 'En ligne';
  static const String healthGaugeTitle = 'Santé Globale des Cultures';
  static const String quickActionsTitle = 'Actions Rapides';
  static const String lastScanTitle = 'Dernier Scan IA';

  // Messages du scanner
  static const String scannerTitle = 'Scanner IA des Plantes';
  static const String scannerSubtitle = 'Prenez une photo pour un diagnostic instantané';
  static const String openCameraButton = 'Ouvrir Caméra';

  // Messages des rapports
  static const String reportsTitle = 'Rapports PDF';
  static const String reportsSubtitle = 'Générez des rapports détaillés avec recommandations IA';
  static const String generateReportButton = 'Générer Rapport';

  // Messages consommateur
  static const String consumerWelcome = 'Bonjour ! 🛒';
  static const String consumerDescription = 'Découvrez des produits locaux de qualité';
  static const String searchHint = 'Rechercher des produits...';
  static const String categoriesTitle = 'Catégories';
  static const String recommendedProductsTitle = 'Produits Recommandés';
  static const String viewAllButton = 'Voir tout';
  static const String addToCartButton = 'Ajouter';

  // Garantie qualité
  static const String qualityGuaranteeTitle = 'Garantie AgriShield';
  static const String qualityGuaranteeSubtitle = 'Tous nos producteurs sont certifiés IA';
  static const String certificationLabel = 'AgriShield Certifié';

  // Catégories de produits
  static const List<String> productCategories = [
    'Tous',
    'Légumes',
    'Fruits',
    'Céréales',
    'Bio',
  ];

  // Métriques du dashboard
  static const String temperatureLabel = 'Température';
  static const String humidityLabel = 'Humidité';
  static const String soilLabel = 'Sol';
  static const String sensorsLabel = 'Capteurs';

  // Status de santé
  static const String healthExcellent = 'Excellent';
  static const String healthGood = 'Bon';
  static const String healthWarning = 'Attention';
  static const String healthCritical = 'Critique';

  // Actions rapides
  static const String scanAction = 'Scanner IA';
  static const String scanActionSubtitle = 'Analyser une plante';
  static const String reportAction = 'Générer Rapport';
  static const String reportActionSubtitle = 'PDF automatique';

  // Navigation
  static const String dashboardTab = 'Dashboard';
  static const String scannerTab = 'Scanner';
  static const String reportsTab = 'Rapports';

  // Messages d'erreur et succès
  static const String loadingMessage = 'Chargement...';
  static const String initializingAI = 'Initialisation de l\'IA...';
  static const String productAddedToCart = 'ajouté au panier';
  static const String notificationsAlert = 'Notifications : 2 alertes en attente';
  static const String cartItems = 'Panier : 3 articles';
  static const String userProfile = 'Profil utilisateur';

  // Données de démonstration
  static const String lastScanResult = 'Tomate - Santé excellente';
  static const String lastScanTime = 'Il y a 2h';

  // Stats qualité consommateur
  static const String qualityPercentage = '98%';
  static const String qualityLabel = 'Qualité';
  static const String freshnessTime = '24h';
  static const String freshnessLabel = 'Fraîcheur';
  static const String originLocal = 'Local';
  static const String originLabel = 'Origine';

  // Unités de mesure
  static const String temperatureUnit = '°C';
  static const String percentageUnit = '%';
  static const String distanceUnit = 'km';
  static const String priceUnit = '€';

  // Tendances
  static const String trendOptimal = 'Optimal';
  static const String trendActive = 'Actifs';
  static const String trendStable = 'Stable';

  // Qualité des produits
  static const String qualityAPlus = 'A+';
  static const String qualityA = 'A';
  static const String qualityB = 'B';

  // Émojis pour l'interface
  static const String plantEmoji = '🌱';
  static const String shoppingEmoji = '🛒';
  static const String tomatoEmoji = '🍅';
  static const String carrotEmoji = '🥕';
  static const String potatoEmoji = '🥔';
  static const String saladEmoji = '🥬';

  // Configuration IA (TODO: à intégrer)
  static const double aiConfidenceThreshold = 0.8;
  static const int maxScanRetries = 3;
  static const int scanTimeoutSeconds = 30;

  // Configuration PDF (TODO: à intégrer)
  static const String pdfAuthor = 'AgriShield AI';
  static const String pdfSubject = 'Rapport d\'exploitation agricole';
  static const String pdfKeywords = 'agriculture, IA, diagnostic, rapport';

  // Configuration Maps (TODO: à intégrer)
  static const double defaultLatitude = 46.603354;
  static const double defaultLongitude = 1.888334;
  static const double mapZoomLevel = 12.0;

  // Animations
  static const int splashDurationMs = 3000;
  static const int animationDelayMs = 100;
  static const int particleAnimationMs = 20000;

  // Limites de l'interface
  static const int maxProductsPerPage = 20;
  static const int maxScanHistory = 100;
  static const int maxNotifications = 50;

  // Configuration réseau (TODO: à intégrer)
  static const int networkTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  static const String apiBaseUrl = 'https://api.agrishield.ai/v1';

  // Stockage local
  static const String userPrefsKey = 'user_preferences';
  static const String scanHistoryKey = 'scan_history';
  static const String farmDataKey = 'farm_data';
  static const String cartItemsKey = 'cart_items';
}

// Énumérations pour une meilleure organisation
enum UserType {
  producer,
  consumer,
}

enum PlantHealthStatus {
  excellent,
  good,
  warning,
  critical,
}

enum ProductQuality {
  aPlus,
  a,
  b,
  c,
}

enum ScanStatus {
  idle,
  scanning,
  processing,
  completed,
  error,
}

enum ReportType {
  daily,
  weekly,
  monthly,
  custom,
}

// Extensions pour les énumérations
extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.producer:
        return AppConstants.producerTitle;
      case UserType.consumer:
        return AppConstants.consumerTitle;
    }
  }

  String get description {
    switch (this) {
      case UserType.producer:
        return AppConstants.producerSubtitle;
      case UserType.consumer:
        return AppConstants.consumerSubtitle;
    }
  }
}

extension PlantHealthStatusExtension on PlantHealthStatus {
  String get displayName {
    switch (this) {
      case PlantHealthStatus.excellent:
        return AppConstants.healthExcellent;
      case PlantHealthStatus.good:
        return AppConstants.healthGood;
      case PlantHealthStatus.warning:
        return AppConstants.healthWarning;
      case PlantHealthStatus.critical:
        return AppConstants.healthCritical;
    }
  }

  double get percentage {
    switch (this) {
      case PlantHealthStatus.excellent:
        return 90.0;
      case PlantHealthStatus.good:
        return 75.0;
      case PlantHealthStatus.warning:
        return 50.0;
      case PlantHealthStatus.critical:
        return 25.0;
    }
  }
}

extension ProductQualityExtension on ProductQuality {
  String get displayName {
    switch (this) {
      case ProductQuality.aPlus:
        return AppConstants.qualityAPlus;
      case ProductQuality.a:
        return AppConstants.qualityA;
      case ProductQuality.b:
        return AppConstants.qualityB;
      case ProductQuality.c:
        return 'C';
    }
  }
}