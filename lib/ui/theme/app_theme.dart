import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          brightness: Brightness.light,
          primary: AppColors.primaryGreen,
          secondary: AppColors.accentGold,
          surface: AppColors.surfaceLight,
          background: AppColors.backgroundLight,
          error: AppColors.statusDanger,
        ),
        textTheme: _buildTextTheme(Brightness.light),
        appBarTheme: _buildAppBarTheme(Brightness.light),
        elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
        filledButtonTheme: _buildFilledButtonTheme(Brightness.light),
        outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
        cardTheme: _buildCardTheme(Brightness.light),
        inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
        bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.light),
        floatingActionButtonTheme: _buildFABTheme(Brightness.light),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          brightness: Brightness.dark,
          primary: AppColors.primaryGreenLight,
          secondary: AppColors.accentGoldLight,
          surface: AppColors.surfaceDark,
          background: AppColors.backgroundDark,
          error: AppColors.statusDanger,
        ),
        textTheme: _buildTextTheme(Brightness.dark),
        appBarTheme: _buildAppBarTheme(Brightness.dark),
        elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
        filledButtonTheme: _buildFilledButtonTheme(Brightness.dark),
        outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
        cardTheme: _buildCardTheme(Brightness.dark),
        inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
        bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.dark),
        floatingActionButtonTheme: _buildFABTheme(Brightness.dark),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTheme = GoogleFonts.poppinsTextTheme();
    final textColor = brightness == Brightness.light
        ? AppColors.textPrimary
        : AppColors.textOnDark;
    final secondaryColor = brightness == Brightness.light
        ? AppColors.textSecondary
        : AppColors.textOnDark.withOpacity(0.7);

    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
      ),
      displaySmall: baseTheme.displaySmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: baseTheme.headlineLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: baseTheme.titleSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(color: textColor, height: 1.5),
      bodyMedium: baseTheme.bodyMedium?.copyWith(color: textColor, height: 1.5),
      bodySmall: baseTheme.bodySmall?.copyWith(
        color: secondaryColor,
        height: 1.4,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        color: secondaryColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        color: secondaryColor,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    return AppBarTheme(
      elevation: AppDimensions.appBarElevation,
      centerTitle: true,
      backgroundColor: brightness == Brightness.light
          ? AppColors.primaryGreen
          : AppColors.cardDark,
      foregroundColor: brightness == Brightness.light
          ? AppColors.textOnDark
          : AppColors.textOnDark,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnDark,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textOnDark,
        size: AppDimensions.iconMD,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    Brightness brightness,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          AppDimensions.buttonMinWidth,
          AppDimensions.buttonHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        elevation: AppDimensions.cardElevationSM,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(Brightness brightness) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(
          AppDimensions.buttonMinWidth,
          AppDimensions.buttonHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    Brightness brightness,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(
          AppDimensions.buttonMinWidth,
          AppDimensions.buttonHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        side: BorderSide(
          color: brightness == Brightness.light
              ? AppColors.primaryGreen
              : AppColors.primaryGreenLight,
          width: 2,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static CardThemeData _buildCardTheme(Brightness brightness) {
    return CardThemeData(
      elevation: AppDimensions.cardElevation,
      color: brightness == Brightness.light
          ? AppColors.cardLight
          : AppColors.cardDark,
      shadowColor: brightness == Brightness.light
          ? AppColors.shadowMedium
          : AppColors.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      margin: const EdgeInsets.all(AppDimensions.marginSM),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    Brightness brightness,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light
          ? AppColors.surfaceLight
          : AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? AppColors.textSecondary
              : AppColors.textOnDark.withOpacity(0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? AppColors.textSecondary.withOpacity(0.3)
              : AppColors.textOnDark.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? AppColors.primaryGreen
              : AppColors.primaryGreenLight,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingMD,
      ),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavTheme(
    Brightness brightness,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: brightness == Brightness.light
          ? AppColors.cardLight
          : AppColors.cardDark,
      selectedItemColor: brightness == Brightness.light
          ? AppColors.primaryGreen
          : AppColors.primaryGreenLight,
      unselectedItemColor: brightness == Brightness.light
          ? AppColors.textSecondary
          : AppColors.textOnDark.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: AppDimensions.cardElevation,
    );
  }

  static FloatingActionButtonThemeData _buildFABTheme(Brightness brightness) {
    return FloatingActionButtonThemeData(
      backgroundColor: brightness == Brightness.light
          ? AppColors.primaryGreen
          : AppColors.primaryGreenLight,
      foregroundColor: AppColors.textOnDark,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
    );
  }
}
