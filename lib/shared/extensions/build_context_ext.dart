import 'package:flutter/material.dart';
import 'package:blindspot/core/constants/app_colors.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDark => theme.brightness == Brightness.dark;

  Color get cardColor => isDark ? AppColors.cardDark : AppColors.cardSurface;
  Color get canvasColor => isDark ? AppColors.canvasDark : AppColors.canvasBackground;
  Color get primaryTextColor => isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get secondaryTextColor => isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  Color get textTertiary => isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
  Color get borderColor => isDark ? AppColors.borderDark : AppColors.borderSubtle;


  Color get statusSafeColor => isDark ? AppColors.statusSafeDark : AppColors.statusSafe;
  Color get statusSafeBackgroundColor => isDark ? AppColors.statusSafeBackgroundDark : AppColors.statusSafeBackground;
  
  Color get statusDangerColor => isDark ? AppColors.statusDangerDark : AppColors.statusDanger;
  Color get statusDangerBackgroundColor => isDark ? AppColors.statusDangerBackgroundDark : AppColors.statusDangerBackground;
  
  Color get statusWarningColor => isDark ? AppColors.statusWarningDark : AppColors.statusWarning;
  Color get statusWarningBackgroundColor => isDark ? AppColors.statusWarningBackgroundDark : AppColors.statusWarningBackground;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: isError ? statusDangerColor : AppColors.brandAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
