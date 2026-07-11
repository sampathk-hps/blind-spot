import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';

/// Conditionally gates [child] behind a premium paywall overlay.
///
/// When [isPremium] is `true` the [child] is rendered normally.
/// Otherwise the child is dimmed and blurred, and a lock icon with an upgrade
/// CTA is shown on top.
class BSPremiumGate extends StatelessWidget {
  const BSPremiumGate({
    super.key,
    required this.child,
    required this.isPremium,
    this.onUpgradeTap,
    this.featureLabel,
  });

  final Widget child;
  final bool isPremium;
  final VoidCallback? onUpgradeTap;
  final String? featureLabel;

  @override
  Widget build(BuildContext context) {
    if (isPremium) return child;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // 1. Dimmed child
        Opacity(opacity: 0.25, child: child),

        // 2. Blur + gradient overlay
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gradientStart.withOpacity(0.15),
                      AppColors.gradientEnd.withOpacity(0.20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 3. Lock UI centred over the content
        Positioned.fill(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lock icon in gradient circle
                  Container(
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientEnd,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.white,
                      size: AppSizes.iconXl,
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),

                  // "Premium Feature" headline
                  Text(
                    AppStrings.premiumFeature,
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: AppSizes.fontLg,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.xs),

                  // Description / feature name
                  Text(
                    featureLabel ?? AppStrings.premiumLockMessage,
                    style: GoogleFonts.inter(
                      color: AppColors.white.withOpacity(0.80),
                      fontSize: AppSizes.fontSm,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.md),

                  // Upgrade CTA
                  BSButton.primary(
                    label: AppStrings.upgradeToPremium,
                    onPressed: onUpgradeTap,
                    isFullWidth: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
