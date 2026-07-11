import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';

// ---------------------------------------------------------------------------
// BSLoading
// ---------------------------------------------------------------------------

/// A centered adaptive loading indicator with an optional descriptive message.
class BSLoading extends StatelessWidget {
  const BSLoading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.brandAccent),
          ),
          if (message != null) ...[
            SizedBox(height: AppSizes.md),
            Text(
              message!,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontMd,
                color: context.secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BSShimmerCard
// ---------------------------------------------------------------------------

/// A skeleton placeholder card that plays a shimmer animation in a loop.
///
/// Use this while async data is loading to prevent layout shifts.
class BSShimmerCard extends StatelessWidget {
  const BSShimmerCard({
    super.key,
    this.height,
    this.width,
    this.margin,
  });

  final double? height;
  final double? width;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          EdgeInsets.symmetric(vertical: AppSizes.xs),
      width: width ?? double.infinity,
      height: height ?? AppSizes.metricCardHeight,
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.shimmerBaseDark
            : AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1200),
          color: context.isDark
              ? AppColors.shimmerHighlightDark
              : AppColors.shimmerHighlight,
        );
  }
}
