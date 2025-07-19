// Configuration de l'application AgriShield AI
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://mon-serveur-agriculture.com/api';
  static const String apiDataEndpoint = '/data';
  static const String apiScanEndpoint = '/scan';
  static const String apiReportEndpoint = '/report';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration refreshInterval = Duration(seconds: 5);
  
  // App Configuration
  static const String appName = 'AgriShield AI';
  static const String appVersion = '1.0.0';
  
  // Animation Durations
  static const Duration splashAnimationDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration cardAnimationDuration = Duration(milliseconds: 200);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
  
  // Colors (Material 3 inspired with AgriShield touch)
  static const int primaryGreen = 0xFF2E7D32; // Deep Green
  static const int secondaryGreen = 0xFF4CAF50; // Medium Green
  static const int accentGreen = 0xFF81C784; // Light Green
  static const int warningOrange = 0xFFFF9800; // Warning
  static const int errorRed = 0xFFE53935; // Error
  static const int successGreen = 0xFF4CAF50; // Success
  static const int infoBlue = 0xFF2196F3; // Info
  
  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'AgriShield-AI-Mobile/1.0.0',
  };
}