import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/bs_badge.dart';

// ---------------------------------------------------------------------------
// DeadlineType
// ---------------------------------------------------------------------------

/// Classifies the entity that the deadline belongs to.
enum DeadlineType { invoice, insurance, subscription }

// ---------------------------------------------------------------------------
// DeadlineTimelineCard
// ---------------------------------------------------------------------------

/// A compact row card used in the deadline timeline list.
///
/// The left accent bar and badge color shift based on how many days remain
/// before [dueDate]:
/// * overdue (< 0) → danger red
/// * ≤ 7 days → warning amber
/// * otherwise → safe green
class DeadlineTimelineCard extends StatelessWidget {
  const DeadlineTimelineCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.amount,
    required this.type,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final DateTime dueDate;
  final String amount;
  final DeadlineType type;
  final VoidCallback? onTap;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  IconData get _typeIcon => switch (type) {
        DeadlineType.invoice => Icons.receipt_long_rounded,
        DeadlineType.insurance => Icons.shield_rounded,
        DeadlineType.subscription => Icons.autorenew_rounded,
      };

  Color _statusColor(BuildContext context) {
    final days = DateFormatter.daysUntil(dueDate);
    if (days < 0) return context.statusDangerColor;
    if (days <= 7) return context.statusWarningColor;
    return context.statusSafeColor;
  }

  Color _iconBgColor(BuildContext context) =>
      _statusColor(context).withOpacity(0.12);

  BSBadge _buildBadge(BuildContext context) {
    final days = DateFormatter.daysUntil(dueDate);
    final label = DateFormatter.toRelativeLabel(dueDate);
    if (days < 0) return BSBadge.danger(label, small: true);
    if (days <= 7) return BSBadge.warning(label, small: true);
    return BSBadge.safe(label, small: true);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);
    final iconBg = _iconBgColor(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.timelineCardHeight,
        margin: EdgeInsets.symmetric(vertical: AppSizes.xs),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: context.borderColor, width: AppSizes.borderThin),
          boxShadow: [
            BoxShadow(
              color: context.isDark
                  ? Colors.black38
                  : Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd),
                  bottomLeft: Radius.circular(AppSizes.radiusMd),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                child: Row(
                  children: [
                    // Type icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Center(
                        child: Icon(
                          _typeIcon,
                          size: AppSizes.iconSm,
                          color: statusColor,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),

                    // Title + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: AppSizes.fontMd,
                              fontWeight: FontWeight.w600,
                              color: context.primaryTextColor,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: AppSizes.fontXs,
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),

                    // Amount + badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          amount,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: AppSizes.fontMd,
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        _buildBadge(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: AppSizes.animNormal))
        .slideX(begin: 0.05, curve: Curves.easeOut);
  }
}
