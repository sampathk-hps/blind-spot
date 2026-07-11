import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';

/// A centered empty-state screen with icon, title, subtitle, and an optional CTA.
///
/// Animates in with a fade + slide-up on first render.
class BSEmptyState extends StatelessWidget {
  const BSEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: AppSizes.iconXxl + 16,
              height: AppSizes.iconXxl + 16,
              decoration: BoxDecoration(
                color: context.borderColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: AppSizes.iconXxl,
                  color: context.secondaryTextColor,
                ),
              ),
            ),
            SizedBox(height: AppSizes.lg),

            // Title
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: AppSizes.fontXl,
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.sm),

            // Subtitle
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontMd,
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),

            // CTA button
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSizes.lg),
              BSButton.primary(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: AppSizes.animNormal))
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }
}
