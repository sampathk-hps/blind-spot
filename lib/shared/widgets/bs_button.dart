import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';

enum _ButtonVariant { primary, secondary, ghost }

/// A styled button widget with three visual variants: primary, secondary, and ghost.
///
/// * [BSButton.primary] — gradient fill with white label.
/// * [BSButton.secondary] — outlined with [AppColors.brandAccent] border.
/// * [BSButton.ghost] — transparent with secondary text color.
class BSButton extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // Named constructors
  // ---------------------------------------------------------------------------

  const BSButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  }) : _variant = _ButtonVariant.primary;

  const BSButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  }) : _variant = _ButtonVariant.secondary;

  const BSButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  }) : _variant = _ButtonVariant.ghost;

  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final _ButtonVariant _variant;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: _variant == _ButtonVariant.primary
              ? AppColors.white
              : AppColors.brandAccent,
          strokeWidth: 2,
        ),
      );
    }

    final textColor = switch (_variant) {
      _ButtonVariant.primary => AppColors.white,
      _ButtonVariant.secondary => AppColors.brandAccent,
      _ButtonVariant.ghost => context.secondaryTextColor,
    };

    final labelWidget = Text(
      label,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: AppSizes.fontMd,
        color: textColor,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: textColor),
          SizedBox(width: AppSizes.sm),
          labelWidget,
        ],
      );
    }

    return labelWidget;
  }

  Widget _buildPrimary(BuildContext context) {
    Widget button = ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: SizedBox(
        height: height ?? AppSizes.buttonMd,
        child: Stack(
          children: [
            // Gradient background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  ),
                ),
              ),
            ),
            // InkWell ripple on top
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                onTap: isLoading ? null : onPressed,
                child: Center(child: _buildContent(context)),
              ),
            ),
          ],
        ),
      ),
    );

    if (onPressed == null && !isLoading) {
      button = Opacity(opacity: AppSizes.opacityDisabled, child: button);
    }

    return button;
  }

  Widget _buildSecondary(BuildContext context) {
    Widget button = SizedBox(
      height: height ?? AppSizes.buttonMd,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.brandAccent, width: AppSizes.borderThin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
        ),
        child: _buildContent(context),
      ),
    );

    if (onPressed == null && !isLoading) {
      button = Opacity(opacity: AppSizes.opacityDisabled, child: button);
    }

    return button;
  }

  Widget _buildGhost(BuildContext context) {
    Widget button = SizedBox(
      height: height ?? AppSizes.buttonMd,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
        ),
        child: _buildContent(context),
      ),
    );

    if (onPressed == null && !isLoading) {
      button = Opacity(opacity: AppSizes.opacityDisabled, child: button);
    }

    return button;
  }

  @override
  Widget build(BuildContext context) {
    Widget button = switch (_variant) {
      _ButtonVariant.primary => _buildPrimary(context),
      _ButtonVariant.secondary => _buildSecondary(context),
      _ButtonVariant.ghost => _buildGhost(context),
    };

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
