import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales nature-tech
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenLight = Color(0xFF4CAF50);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  
  static const Color accentGold = Color(0xFFFFB300);
  static const Color accentGoldLight = Color(0xFFFFE082);
  static const Color accentGoldDark = Color(0xFFFF8F00);
  
  static const Color backgroundBeige = Color(0xFFF5F5DC);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  
  // Couleurs statut (santé des plantes)
  static const Color statusHealthy = Color(0xFF4CAF50);
  static const Color statusWarning = Color(0xFFFF9800);
  static const Color statusDanger = Color(0xFFE53935);
  static const Color statusCritical = Color(0xFFD32F2F);
  
  // Couleurs UI
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color surfaceDark = Color(0xFF2D2D30);
  
  // Texte
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnLight = Color(0xFF000000);
  
  // Scanner UI
  static const Color scannerOverlay = Color(0x80000000);
  static const Color scannerFrame = Color(0xFF00E676);
  static const Color scannerGlow = Color(0x4000E676);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryGreenDark],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundBeige, backgroundLight],
  );
  
  static const LinearGradient scannerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [scannerGlow, Colors.transparent],
  );
  
  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}