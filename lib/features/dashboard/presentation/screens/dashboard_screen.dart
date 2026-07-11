import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/utils/currency_formatter.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/animated_metric_card.dart';
import 'package:blindspot/shared/widgets/bs_card.dart';
import 'package:blindspot/shared/widgets/bs_loading.dart';
import 'package:blindspot/features/auth/presentation/providers/auth_provider.dart';
import 'package:blindspot/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:blindspot/features/insurances/presentation/providers/insurance_provider.dart';
import 'package:blindspot/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  /// Derives the greeting string from the current hour.
  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(currentUserNameProvider);
    final invoicesAsync = ref.watch(invoicesProvider);
    final insurancesAsync = ref.watch(insurancesProvider);
    final subscriptionsAsync = ref.watch(subscriptionsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.gradientStart,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Row(
                children: [
                  const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.appName,
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  ),
                ),
                padding: const EdgeInsets.only(left: 20, bottom: 60, right: 20),
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: GoogleFonts.inter(
                              color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          userName,
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      radius: 24,
                      child: Text(
                        userName.isNotEmpty
                            ? userName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.inter(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white),
                onPressed: () =>
                    context.showSnackBar(AppStrings.comingSoon),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    // Total Due — invoice amounts not yet paid
                    _buildMetricCard(
                      context,
                      invoicesAsync,
                      AppStrings.totalDue,
                      Icons.receipt_long_rounded,
                      AppColors.metricInvoiceColor,
                      AppColors.metricInvoiceBackground,
                      (data) {
                        final total = data
                            .where((i) => !i.isPaid)
                            .fold(0.0, (sum, i) => sum + i.amount);
                        return CurrencyFormatter.formatCompact(
                            total, AppStrings.defaultCurrency);
                      },
                      0,
                    ),
                    // Monthly Spend — active subscriptions monthly equivalent
                    _buildMetricCard(
                      context,
                      subscriptionsAsync,
                      AppStrings.monthlySpend,
                      Icons.autorenew_rounded,
                      AppColors.brandAccent,
                      AppColors.brandAccentLight,
                      (data) {
                        final total = data
                            .where((s) => s.isActive)
                            .fold(
                                0.0, (sum, s) => sum + s.monthlyEquivalent);
                        return CurrencyFormatter.formatCompact(
                            total, AppStrings.defaultCurrency);
                      },
                      1,
                    ),
                    // Active Insurances count
                    _buildMetricCard(
                      context,
                      insurancesAsync,
                      AppStrings.activeInsurances,
                      Icons.shield_rounded,
                      AppColors.metricInsuranceColor,
                      AppColors.metricInsuranceBackground,
                      (data) => data
                          .where((i) => !i.isExpired)
                          .length
                          .toString(),
                      2,
                    ),
                    // Overdue invoices count
                    _buildMetricCard(
                      context,
                      invoicesAsync,
                      AppStrings.overdue,
                      Icons.warning_rounded,
                      AppColors.metricOverdueColor,
                      AppColors.metricOverdueBackground,
                      (data) => data
                          .where((i) => i.isOverdue)
                          .length
                          .toString(),
                      3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.upcomingDeadlines,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.primaryTextColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppStrings.viewAll,
                        style:
                            GoogleFonts.inter(color: AppColors.brandAccent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Text(
                      AppStrings.noUpcomingDeadlines,
                      style: GoogleFonts.inter(
                          color: context.secondaryTextColor),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    AsyncValue asyncValue,
    String title,
    IconData icon,
    Color color,
    Color bg,
    String Function(List<dynamic>) extract,
    int index,
  ) {
    return asyncValue.when(
      data: (data) => AnimatedMetricCard(
        title: title,
        value: extract(data),
        icon: icon,
        accentColor: color,
        iconBackgroundColor: bg,
        animateIndex: index,
      ),
      loading: () => const BSShimmerCard(),
      error: (_, __) =>
          BSCard(child: const Center(child: Icon(Icons.error_outline))),
    );
  }
}
