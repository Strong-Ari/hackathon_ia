class ApiConstants {
  // Configuration de l'API Flask
  static const String baseUrl =
      'http://192.168.1.11:8000'; // Mettez à jour avec votre adresse IP locale
  static const String notificationsEndpoint = '/notifications/';

  // Configuration du polling
  static const Duration pollingInterval = Duration(seconds: 10);

  // Configuration audio
  static const String alertSoundAsset = 'assets/audio/bling.mp3';

  // URLs complètes
  static String get notificationsUrl => '$baseUrl$notificationsEndpoint';

  static String getAudioUrl(String audioFile) => '$baseUrl/$audioFile';
}
