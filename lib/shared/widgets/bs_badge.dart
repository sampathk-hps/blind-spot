import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';

enum _BadgeVariant { safe, danger, warning, info, neutral, premium }

/// A compact status badge with semantic color variants.
///
/// Use the named constructors to select the correct visual meaning:
/// [BSBadge.safe], [BSBadge.danger], [BSBadge.warning], [BSBadge.info],
/// [BSBadge.neutral], [BSBadge.premium].
class BSBadge extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // Named constructors
  // ---------------------------------------------------------------------------

  const BSBadge.safe(
    this.label, {
    super.key,
    this.icon,
    this.small = false,
  }) : _variant = _BadgeVariant.safe;

  const BSBadge.danger(
    this.label, {
    super.key,
    this.icon,
    this.small = false,
  }) : _variant = _BadgeVariant.danger;

  const BSBadge.warning(
    this.label, {
    super.key,
    this.icon,
    this.small = false,
  }) : _variant = _BadgeVariant.warning;

  const BSBadge.info(
    this.label, {
    super.key,
    this.icon,
    this.small = false,
  }) : _variant = _BadgeVariant.info;

  const BSBadge.neutral(
    this.label, {
    super.key,
    this.icon,
    this.small = false,
  }) : _variant = _BadgeVariant.neutral;

  const BSBadge.premium(
    this.label, {
    super.key,
    this.icon,
    this.small = false,
  }) : _variant = _BadgeVariant.premium;

  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  final String label;
  final IconData? icon;
  final bool small;
  final _BadgeVariant _variant;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Color _backgroundColor(BuildContext context) {
    final isDark = context.isDark;
    return switch (_variant) {
      _BadgeVariant.safe => isDark
          ? AppColors.statusSafeBackgroundDark
          : AppColors.statusSafeBackground,
      _BadgeVariant.danger => isDark
          ? AppColors.statusDangerBackgroundDark
          : AppColors.statusDangerBackground,
      _BadgeVariant.warning => isDark
          ? AppColors.statusWarningBackgroundDark
          : AppColors.statusWarningBackground,
      _BadgeVariant.info => isDark
          ? AppColors.brandAccentLight.withOpacity(0.15)
          : AppColors.statusInfoBackground,
      _BadgeVariant.neutral => isDark
          ? AppColors.borderDark
          : AppColors.borderSubtle,
      _BadgeVariant.premium => Colors.transparent, // handled by gradient
    };
  }

  Color _textColor(BuildContext context) {
    final isDark = context.isDark;
    return switch (_variant) {
      _BadgeVariant.safe =>
        isDark ? AppColors.statusSafeDark : AppColors.statusSafe,
      _BadgeVariant.danger =>
        isDark ? AppColors.statusDangerDark : AppColors.statusDanger,
      _BadgeVariant.warning =>
        isDark ? AppColors.statusWarningDark : AppColors.statusWarning,
      _BadgeVariant.info =>
        isDark ? AppColors.brandAccentLight : AppColors.brandAccent,
      _BadgeVariant.neutral =>
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      _BadgeVariant.premium => AppColors.white,
    };
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor(context);
    final fontSize = small ? AppSizes.fontXs : AppSizes.fontSm;
    final iconSize = small ? 10.0 : 12.0;

    Widget content;
    if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      );
    } else {
      content = Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      );
    }

    final horizontalPadding = small ? AppSizes.sm : AppSizes.md;
    final verticalPadding = small ? 2.0 : AppSizes.xs;

    Decoration decoration;
    if (_variant == _BadgeVariant.premium) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      );
    } else {
      decoration = BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: decoration,
      child: content,
    );
  }
}
