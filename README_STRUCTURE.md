# AgriShield AI - Structure du Projet

## 🎯 Vue d'ensemble

AgriShield AI est une application Flutter moderne destinée à l'agriculture intelligente, avec deux espaces distincts :
- **Espace Producteur** : Gestion des cultures et surveillance des capteurs
- **Espace Consommateur** : Traçabilité des produits agricoles

## 📁 Architecture du Projet

```
lib/
├── config.dart                    # Configuration globale de l'app
├── main.dart                      # Point d'entrée de l'application
├── core/                          # Logique métier
│   ├── models/                    # Modèles de données
│   │   ├── sensor_data.dart       # Données des capteurs agricoles
│   │   └── scan_result.dart       # Résultats de scan IA
│   ├── providers/                 # Gestion d'état avec Riverpod
│   │   ├── router_provider.dart   # Configuration de navigation
│   │   ├── sensor_provider.dart   # Gestion des données capteurs
│   │   └── scan_provider.dart     # Gestion des scans IA
│   └── services/                  # Services externes
│       └── api_service.dart       # Communication avec le serveur
└── ui/                           # Interface utilisateur
    ├── pages/                    # Écrans de l'application
    │   ├── splash_screen.dart    # Écran de démarrage animé
    │   ├── home_screen.dart      # Écran d'accueil avec choix d'espace
    │   ├── producer/             # Espace producteur
    │   │   ├── producer_dashboard_screen.dart  # Tableau de bord
    │   │   ├── scan_screen.dart  # Scan IA des plantes
    │   │   └── reports_screen.dart # Génération de rapports PDF
    │   └── consumer/             # Espace consommateur
    │       └── consumer_screen.dart # Écran principal consommateur
    ├── widgets/                  # Composants réutilisables
    │   ├── animated_background.dart # Arrière-plan animé
    │   ├── space_card.dart       # Carte d'espace (accueil)
    │   ├── dashboard_card.dart   # Carte de tableau de bord
    │   ├── status_indicator.dart # Indicateur de statut
    │   ├── alert_banner.dart     # Bannière d'alerte
    │   ├── scan_progress_widget.dart # Progrès du scan
    │   ├── scan_result_card.dart # Carte de résultat de scan
    │   ├── report_card.dart      # Carte de rapport
    │   └── consumer_card.dart    # Carte consommateur
    └── theme/                    # Thème de l'application
        └── app_theme.dart        # Configuration Material 3
```

## 🎨 Design System

### Couleurs principales
- **Vert primaire** : `#2E7D32` (AgriShield Green)
- **Vert secondaire** : `#4CAF50` (Medium Green)
- **Vert accent** : `#81C784` (Light Green)
- **Orange d'avertissement** : `#FF9800`
- **Rouge d'erreur** : `#E53935`
- **Vert de succès** : `#4CAF50`
- **Bleu d'information** : `#2196F3`

### Typographie
- **Police principale** : Google Fonts Poppins
- **Hiérarchie claire** : Display, Headline, Title, Body, Label
- **Responsive** : Adaptation automatique selon la taille d'écran

## 🔧 Technologies Utilisées

### Gestion d'état
- **Riverpod** : Gestion d'état moderne et type-safe
- **Providers** : Organisation modulaire des données

### Navigation
- **GoRouter** : Navigation déclarative et type-safe
- **Transitions fluides** : Animations personnalisées

### UI/UX
- **Material 3** : Design system moderne
- **Flutter Animate** : Animations fluides et performantes
- **Google Fonts** : Typographie professionnelle

### Services
- **Dio** : Client HTTP robuste
- **Connectivity Plus** : Gestion de la connectivité
- **Image Picker** : Sélection d'images
- **PDF & Printing** : Génération de rapports

## 🚀 Fonctionnalités Principales

### Espace Producteur
1. **Tableau de bord en temps réel**
   - Données des capteurs (température, humidité, sol)
   - Alertes automatiques
   - Statistiques agrégées

2. **Scan IA des plantes**
   - Analyse d'images par IA
   - Diagnostic de maladies
   - Recommandations personnalisées

3. **Rapports PDF**
   - Génération automatique
   - Données structurées
   - Export professionnel

### Espace Consommateur
1. **Traçabilité des produits**
   - Scan de QR codes
   - Historique des produits
   - Informations sur les producteurs

2. **Recherche de producteurs**
   - Géolocalisation
   - Filtres avancés
   - Informations détaillées

## 🔌 API et Données

### Configuration
- **URL configurable** dans `config.dart`
- **Gestion d'erreurs** robuste
- **Timeouts** adaptés au contexte agricole

### Endpoints
- `GET /api/data` : Données des capteurs
- `POST /api/scan` : Analyse IA d'images
- `POST /api/report` : Génération de rapports

### Données en temps réel
- **Rafraîchissement automatique** toutes les 5 secondes
- **Gestion hors ligne** avec cache local
- **Synchronisation** lors du retour en ligne

## 📱 Ergonomie Mobile

### Principes de design
- **Gros boutons** pour agriculteurs peu technophiles
- **Feedback visuel** immédiat
- **Navigation intuitive** avec bottom navigation
- **Mode sombre** automatique

### Animations
- **Transitions fluides** entre écrans
- **Feedback tactile** sur les interactions
- **Chargement progressif** des données
- **Effets visuels** subtils mais efficaces

## 🛠️ Développement

### Structure Clean Architecture
- **Séparation des responsabilités** claire
- **Testabilité** optimale
- **Maintenabilité** facilitée
- **Évolutivité** garantie

### Code Quality
- **Nommage explicite** des variables et fonctions
- **Commentaires** pour les parties complexes
- **TODO** clairs pour les fonctionnalités futures
- **Gestion d'erreurs** complète

## 🚧 Fonctionnalités Futures

### TODO: Implémentations manquantes
- [ ] Historique détaillé des scans
- [ ] Détails des résultats de scan
- [ ] Historique des rapports
- [ ] Paramètres utilisateur
- [ ] Scanner QR code consommateur
- [ ] Recherche de producteurs
- [ ] Informations agricoles
- [ ] Intégration Google Maps
- [ ] Notifications push
- [ ] Mode hors ligne complet

## 📋 Installation et Lancement

1. **Cloner le projet**
   ```bash
   git clone [url-du-repo]
   cd agrishield_ai
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configurer l'API**
   - Modifier `lib/config.dart`
   - Remplacer l'URL de l'API par votre serveur

4. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🎯 Objectifs Atteints

✅ **Architecture Clean** avec séparation claire des couches  
✅ **Design moderne** inspiré Material 3 avec identité AgriShield  
✅ **Navigation fluide** avec GoRouter et transitions animées  
✅ **Gestion d'état** robuste avec Riverpod  
✅ **API externe** configurable et sécurisée  
✅ **Données temps réel** avec rafraîchissement automatique  
✅ **UI responsive** adaptée aux agriculteurs  
✅ **Animations élégantes** pour l'expérience utilisateur  
✅ **Code modulaire** et maintenable  
✅ **Documentation** complète de la structure  

L'application AgriShield AI est maintenant prête pour le développement des fonctionnalités spécifiques et l'intégration avec votre serveur backend !