import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium paywall / subscription plan screen.
///
/// All display strings come from [AppStrings] and all colours from [AppColors].
/// Exported as [PremiumScreen] so the router can reference a stable name.
class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: Column(
                    children: [
                      const Icon(Icons.diamond_outlined,
                          size: 80, color: Colors.white),
                      const SizedBox(height: AppSizes.lg),
                      Text(
                        AppStrings.unlockPremium,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        AppStrings.premiumSubtitle,
                        style: GoogleFonts.inter(
                            fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.xxl),

                      // ── Feature highlights ───────────────────────────────
                      _FeatureItem(
                        icon: Icons.cloud_sync_rounded,
                        title: AppStrings.featureCloudSync,
                        subtitle: AppStrings.featureCloudSyncDesc,
                      ),
                      const SizedBox(height: AppSizes.md),
                      _FeatureItem(
                        icon: Icons.auto_awesome_rounded,
                        title: AppStrings.featureAi,
                        subtitle: AppStrings.featureAiDesc,
                      ),
                      const SizedBox(height: AppSizes.md),
                      _FeatureItem(
                        icon: Icons.devices_rounded,
                        title: AppStrings.featureMultiDevice,
                        subtitle: AppStrings.featureMultiDeviceDesc,
                      ),
                      const SizedBox(height: AppSizes.xxl),

                      // ── Annual plan card ─────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.planAnnualLabel,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  AppStrings.planAnnualPrice,
                                  style: GoogleFonts.inter(
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                AppStrings.planAnnualSavings,
                                style: GoogleFonts.inter(
                                  color: AppColors.brandAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),

                      // ── Monthly plan card ────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.planMonthlyLabel,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  AppStrings.planMonthlyPrice,
                                  style: GoogleFonts.inter(
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── CTA ───────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.brandAccent,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusLg),
                          ),
                        ),
                        onPressed: () {
                          context.showSnackBar(
                              AppStrings.iapPlaceholderPurchasing);
                        },
                        child: Text(
                          AppStrings.startFreeTrial,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    TextButton(
                      onPressed: () => context.showSnackBar(
                          AppStrings.iapPlaceholderRestoring),
                      child: Text(
                        AppStrings.restorePurchases,
                        style: GoogleFonts.inter(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FeatureItem  (private)
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style:
                    GoogleFonts.inter(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
