import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/theme/app_theme.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/bs_card.dart';

/// A metric summary card with a staggered entrance animation.
///
/// Use [animateIndex] to offset the delay for each card in a grid,
/// creating a cascading reveal effect.
class AnimatedMetricCard extends StatelessWidget {
  const AnimatedMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.iconBackgroundColor,
    this.onTap,
    this.isLoading = false,
    this.animateIndex = 0,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final int animateIndex;

  @override
  Widget build(BuildContext context) {
    return BSCard(
      onTap: onTap,
      padding: EdgeInsets.all(AppSizes.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: AppSizes.iconMd,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.md),

          // Value (or loading skeleton)
          if (isLoading)
            Container(
              width: 80,
              height: 28,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
            )
          else
            Text(
              value,
              style: AppTheme.monoStyle(
                fontSize: AppSizes.fontDisplayLg,
                weight: FontWeight.w700,
                color: context.primaryTextColor,
              ),
            ),
          SizedBox(height: AppSizes.xs),

          // Title
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSm,
              color: context.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Optional subtitle / trend
          if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontXs,
                color: accentColor,
              ),
            ),
        ],
      ),
    )
        .animate(
          delay: Duration(milliseconds: animateIndex * 80),
        )
        .fadeIn(duration: Duration(milliseconds: AppSizes.animSlow))
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }
}
