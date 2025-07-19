import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config.dart';

// Thème de l'application AgriShield AI
class AppTheme {
  // Couleurs principales
  static const Color primaryColor = Color(AppConfig.primaryGreen);
  static const Color secondaryColor = Color(AppConfig.secondaryGreen);
  static const Color accentColor = Color(AppConfig.accentGreen);
  static const Color warningColor = Color(AppConfig.warningOrange);
  static const Color errorColor = Color(AppConfig.errorRed);
  static const Color successColor = Color(AppConfig.successGreen);
  static const Color infoColor = Color(AppConfig.infoBlue);

  // Thème clair
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: Colors.white,
        background: const Color(0xFFFAFAFA),
      ),
      
      // Typographie
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        iconTheme: const IconThemeData(
          color: primaryColor,
          size: 24,
        ),
      ),

      // Card
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.cardRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConfig.defaultPadding,
          vertical: AppConfig.defaultPadding / 2,
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey.shade600,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey.shade400,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
        space: 1,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: primaryColor.withOpacity(0.1),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Thème sombre
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
      ),
      
      // Typographie (adaptée pour le mode sombre)
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade300,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade300,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),

      // AppBar (mode sombre)
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),

      // Card (mode sombre)
      cardTheme: CardTheme(
        color: const Color(0xFF2A2A2A),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.cardRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConfig.defaultPadding,
          vertical: AppConfig.defaultPadding / 2,
        ),
      ),

      // InputDecoration (mode sombre)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey.shade300,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey.shade500,
        ),
      ),

      // BottomNavigationBar (mode sombre)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
