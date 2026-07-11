import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';

/// Central theme factory for BlindSpot.
/// Call [AppTheme.light()] or [AppTheme.dark()] in [MaterialApp].
abstract final class AppTheme {
  // ─────────────────────────────────────────
  // Light theme
  // ─────────────────────────────────────────
  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.brandAccent,
      brightness: Brightness.light,
    ).copyWith(
      background: AppColors.canvasBackground,
      surface: AppColors.cardSurface,
      outline: AppColors.borderSubtle,
      primary: AppColors.brandAccent,
      onPrimary: Colors.white,
      error: AppColors.statusDanger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: AppColors.canvasBackground,
      textTheme: _buildTextTheme(isDark: false),
      appBarTheme: _appBarTheme(isDark: false),
      cardTheme: _cardTheme(isDark: false),
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      bottomNavigationBarTheme: _bottomNavTheme(isDark: false),
      dividerTheme: _dividerTheme(isDark: false),
      dialogTheme: _dialogTheme(isDark: false),
      snackBarTheme: _snackBarTheme(),
      listTileTheme: _listTileTheme(),
      chipTheme: _chipTheme(isDark: false),
      switchTheme: _switchTheme(),
      floatingActionButtonTheme: _fabTheme(),
    );
  }

  // ─────────────────────────────────────────
  // Dark theme — "Encrypted Obsidian"
  // ─────────────────────────────────────────
  static ThemeData dark() {
    final base = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.brandAccent,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF3730A3),
      onPrimaryContainer: const Color(0xFFE0E7FF),
      secondary: AppColors.gradientEnd,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFF6B21A8),
      onSecondaryContainer: const Color(0xFFF3E8FF),
      tertiary: AppColors.statusSafe,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFF064E3B),
      onTertiaryContainer: const Color(0xFFD1FAE5),
      error: AppColors.statusDanger,
      onError: Colors.white,
      errorContainer: const Color(0xFF881337),
      onErrorContainer: const Color(0xFFFFE4E6),
      background: AppColors.canvasDark,
      onBackground: AppColors.textPrimaryDark,
      surface: AppColors.cardDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceVariant: const Color(0xFF1E293B),
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.borderDark,
      outlineVariant: const Color(0xFF334155),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.textPrimaryDark,
      onInverseSurface: AppColors.canvasDark,
      inversePrimary: AppColors.brandAccent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: AppColors.canvasDark,
      textTheme: _buildTextTheme(isDark: true),
      appBarTheme: _appBarTheme(isDark: true),
      cardTheme: _cardTheme(isDark: true),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      bottomNavigationBarTheme: _bottomNavTheme(isDark: true),
      dividerTheme: _dividerTheme(isDark: true),
      dialogTheme: _dialogTheme(isDark: true),
      snackBarTheme: _snackBarTheme(),
      listTileTheme: _listTileTheme(),
      chipTheme: _chipTheme(isDark: true),
      switchTheme: _switchTheme(),
      floatingActionButtonTheme: _fabTheme(),
    );
  }

  // ─────────────────────────────────────────
  // Mono style — monetary values, policy numbers, dates
  // ─────────────────────────────────────────
  static TextStyle monoStyle({
    double? fontSize,
    FontWeight? weight,
    Color? color,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: weight,
        color: color,
      );

  // ─────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────

  static TextTheme _buildTextTheme({required bool isDark}) {
    final primaryColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return TextTheme(
      // ── Display / Headline → SpaceGrotesk ──
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: AppSizes.fontDisplayLg, // 28
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: AppSizes.fontDisplay, // 24
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.25,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: AppSizes.fontXxl, // 20
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      // ── Title / Body / Label → Inter ──
      titleLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontXl, // 18
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontLg, // 16
        fontWeight: FontWeight.w500,
        color: primaryColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: AppSizes.fontMd, // 14
        fontWeight: FontWeight.w500,
        color: primaryColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontLg, // 16
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontMd, // 14
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: AppSizes.fontSm, // 12
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontMd, // 14
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontSm, // 12
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }

  static AppBarTheme _appBarTheme({required bool isDark}) => AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: AppSizes.fontXl, // 18
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          size: 22,
        ),
        actionsIconTheme: IconThemeData(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          size: 22,
        ),
      );

  static CardTheme _cardTheme({required bool isDark}) => CardTheme(
        elevation: 0,
        color: isDark ? AppColors.cardDark : AppColors.cardSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppSizes.radiusLg), // 16
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderSubtle,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      );

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.cardDark : AppColors.canvasBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, // 16
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd), // 12
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderSubtle,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderSubtle,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.brandAccent,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.statusDanger,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.statusDanger,
            width: 1.5,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontMd,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontMd,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontSm,
          color: AppColors.brandAccent,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontSm,
          color: AppColors.statusDanger,
          fontWeight: FontWeight.w400,
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.brandAccent.withOpacity(0.38);
            }
            return AppColors.brandAccent;
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.12),
          ),
          elevation: MaterialStateProperty.all(0),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(double.infinity, AppSizes.buttonMd),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg), // 16
            ),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.inter(
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(AppColors.brandAccent),
          overlayColor: MaterialStateProperty.all(
            AppColors.brandAccent.withOpacity(0.08),
          ),
          elevation: MaterialStateProperty.all(0),
          side: MaterialStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(
                color: AppColors.brandAccent.withOpacity(0.38),
                width: 1.5,
              );
            }
            return const BorderSide(
              color: AppColors.brandAccent,
              width: 1.5,
            );
          }),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(double.infinity, AppSizes.buttonMd),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.inter(
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(AppColors.brandAccent),
          overlayColor: MaterialStateProperty.all(
            AppColors.brandAccent.withOpacity(0.08),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.inter(
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );

  static BottomNavigationBarThemeData _bottomNavTheme({required bool isDark}) =>
      BottomNavigationBarThemeData(
        backgroundColor:
            isDark ? AppColors.cardDark : AppColors.cardSurface,
        selectedItemColor: AppColors.brandAccent,
        unselectedItemColor:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontSm,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontSm,
          fontWeight: FontWeight.w400,
        ),
      );

  static DividerThemeData _dividerTheme({required bool isDark}) =>
      DividerThemeData(
        color: isDark ? AppColors.borderDark : AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      );

  static DialogTheme _dialogTheme({required bool isDark}) => DialogTheme(
        backgroundColor:
            isDark ? AppColors.cardDark : AppColors.cardSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl), // 20
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderSubtle,
            width: 1,
          ),
        ),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: AppSizes.fontXl,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontMd,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      );

  static SnackBarThemeData _snackBarTheme() => SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd), // 12
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontMd,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        actionTextColor: AppColors.gradientStart,
      );

  static ListTileThemeData _listTileTheme() => const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.screenPadding, // 20
          vertical: AppSizes.xs, // 4
        ),
        minLeadingWidth: 0,
      );

  static ChipThemeData _chipTheme({required bool isDark}) => ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull), // 100 (pill)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontSm,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderSubtle,
          width: 1,
        ),
        backgroundColor:
            isDark ? AppColors.cardDark : AppColors.canvasBackground,
      );

  static SwitchThemeData _switchTheme() => SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.brandAccent.withOpacity(0.5); // brandAccentLight
          }
          return AppColors.borderSubtle;
        }),
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.brandAccent;
          }
          return Colors.white;
        }),
      );

  static FloatingActionButtonThemeData _fabTheme() =>
      const FloatingActionButtonThemeData(
        backgroundColor: AppColors.brandAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      );
}
