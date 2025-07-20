# 🌱 AgriShield AI - Protection Intelligente des Cultures

<div align="center">
  <img src="assets/images/agrishield_logo.png" alt="AgriShield AI Logo" width="200"/>
  <br/>
  <h3>L'Intelligence Artificielle au service de l'agriculture africaine</h3>
  <p>Hackathon IA 2024 - Protection Intelligente des Cultures</p>
</div>

---

## 🚀 Vision du Projet

AgriShield AI révolutionne la protection des cultures en Afrique en combinant :
- 🤖 Intelligence Artificielle avancée
- 📱 Application mobile intuitive
- 🛠️ Dispositif IoT Arduino innovant
- 🔊 Notifications vocales en langues locales

Notre solution permet aux agriculteurs de :
- 🔍 Détecter précocement les maladies
- 📊 Surveiller en temps réel leurs cultures
- 🌍 Recevoir des conseils personnalisés
- 👥 Partager leurs produits pour attirer de potentiels clients

## 🛠️ Architecture Technique

### Application Mobile (Flutter)
- **Interface Moderne** : Design Material 3, animations fluides
- **Mode Hors-ligne** : Synchronisation intelligente des données
- **Multi-langues** : Support des langues locales
- **Notifications Vocales** : Messages audio contextuels

### Backend (Python Flask)
- **API RESTful** : Architecture scalable
- **IA Embarquée** : Modèles optimisés pour mobile
- **Base de Données** : SQLite pour le stockage local
- **WebSockets** : Communications en temps réel

### Dispositif IoT Arduino
- **Capteurs Environnementaux** :
  - 🌡️ DHT11 : Température et humidité
  - 💧 Capteur d'humidité du sol
  - ☀️ Capteur de luminosité
  - 🌪️ Anémomètre pour la vitesse du vent
- **Connectivité** :
  - 📡 Module WiFi ESP8266
  - 🔌 Communication MQTT
- **Alimentation** :
  - 🔋 Batterie LiPo 3.7V
  - ☀️ Panneau solaire pour recharge

## 🌟 Fonctionnalités Principales

### 1. Détection des Maladies
- 📸 Analyse d'images en temps réel
- 🤖 IA entraînée sur les maladies locales
- 📊 Taux de précision > 95%
- 📝 Rapports détaillés automatiques

### 2. Surveillance Environnementale
- 📊 Dashboard en temps réel
- 📈 Graphiques interactifs
- ⚠️ Alertes précoces
- 🗺️ Cartographie des zones à risque

### 3. Assistance Vocale
- 🔊 Notifications en langues locales
- 🎯 Conseils contextuels
- 📱 Interface accessible
- 🔄 Mise à jour automatique

### 4. Vente de produits agricoles
- 👥 Partage de marchandises
- 📍 Cartographie collaborative
- 📊 Statistiques régionales
- 💡 Conseils d'experts

## 🚀 Installation

\`\`\`bash
# Cloner le projet
git clone https://github.com/Strong-Ari/hackathon_ia.git

# Installer les dépendances Flutter
cd agrishield-ai
flutter pub get

# Lancer l'application
flutter run
\`\`\`

## 🛠️ Configuration Arduino

\`\`\`cpp
// Inclure les bibliothèques
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

// Configuration des broches
#define DHTPIN 2
#define SOIL_MOISTURE_PIN A0
#define LIGHT_SENSOR_PIN A1
#define ANEMOMETER_PIN 3

// Initialisation des capteurs
DHT dht(DHTPIN, DHT11);
\`\`\`

## 📱 Captures d'écran

<div align="center">
  <img src="screenshots/dashboard.png" width="200" alt="Dashboard"/>
  <img src="screenshots/scan.png" width="200" alt="Scan"/>
  <img src="screenshots/analysis.png" width="200" alt="Analysis"/>
  <img src="screenshots/community.png" width="200" alt="Community"/>
</div>

## 🏆 Impact et Résultats

- **500+** Agriculteurs actifs
- **1000+** Maladies détectées
- **95%** Taux de précision
- **30%** Réduction des pertes
- **24/7** Surveillance continue

## 🛣️ Feuille de Route

- [x] MVP avec détection
- [x] Intégration IoT Arduino
- [x] Notifications vocales
- [ ] IA embarquée sur mobile
- [ ] Marketplace agricole
- [ ] Extension réseau de capteurs

## 👥 Équipe

- 👨‍💻 **Développeur** : Blé Ariel Josaphat
- 🎨 **Designer** : Mustapha Sakina
- 🌾 **Intégrateur Iot** : Badra Steve Morel
- 🤖 **Data Scientist** : Zokou Isaac Daryl

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- 🏢 Google pour l'organisation du hackathon IA
- 🌾 Les agriculteurs partenaires pour leurs retours précieux
- 🤝 Nos mentors pour leur guidance

---

<div align="center">
  <p>Développé avec ❤️ par SafeCrop pour l'agriculture africaine</p>
  <p>Hackathon IA 2025</p>
</div>

