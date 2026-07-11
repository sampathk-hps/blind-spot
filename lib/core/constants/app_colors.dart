import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors

abstract final class AppColors {
  static const Color canvasBackground = Color(0xFFF8FAFC);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color brandAccent = Color(0xFF4F46E5);
  static const Color brandAccentLight = Color(0xFFEEF2FF);
  static const Color brandAccentDark = Color(0xFF4338CA);

  static const Color statusSafe = Color(0xFF059669);
  static const Color statusSafeBackground = Color(0xFFECFDF5);
  static const Color statusDanger = Color(0xFFBE123C);
  static const Color statusDangerBackground = Color(0xFFFFF1F2);
  static const Color statusWarning = Color(0xFFB45309);
  static const Color statusWarningBackground = Color(0xFFFFFBEB);
  static const Color statusInfo = Color(0xFF2563EB);
  static const Color statusInfoBackground = Color(0xFFEFF6FF);

  static const Color canvasDark = Color(0xFF090D16);
  static const Color cardDark = Color(0xFF121824);
  static const Color borderDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF475569);

  static const Color statusSafeDark = Color(0xFF34D399);
  static const Color statusSafeBackgroundDark = Color(0x1A34D399);
  static const Color statusDangerDark = Color(0xFFFB7185);
  static const Color statusDangerBackgroundDark = Color(0x1AFB7185);
  static const Color statusWarningDark = Color(0xFFFBBF24);
  static const Color statusWarningBackgroundDark = Color(0x1AFBBF24);

  static const Color gradientStart = Color(0xFF6366F1);
  static const Color gradientEnd = Color(0xFFA855F7);

  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);
  static const Color shimmerBaseDark = Color(0xFF1E293B);
  static const Color shimmerHighlightDark = Color(0xFF334155);

  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // ── Dashboard metric card accent colours ────────────────────────────────────
  /// Used for the "Total Due" (invoices) metric card.
  static Color get metricInvoiceColor => const Color(0xFFEC4899); // pink-500
  static Color get metricInvoiceBackground =>
      const Color(0xFFEC4899).withOpacity(0.10);

  /// Used for the "Active Insurances" metric card.
  static Color get metricInsuranceColor => const Color(0xFF0D9488); // teal-600
  static Color get metricInsuranceBackground =>
      const Color(0xFF0D9488).withOpacity(0.10);

  /// Used for the "Overdue" metric card.
  static Color get metricOverdueColor => const Color(0xFFB45309); // amber-700
  static Color get metricOverdueBackground =>
      const Color(0xFFFFFBEB); // amber-50
}
