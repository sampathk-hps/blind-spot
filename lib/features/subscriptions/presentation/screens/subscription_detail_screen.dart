import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/utils/currency_formatter.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/shared/widgets/bs_badge.dart';
import 'package:blindspot/shared/widgets/bs_card.dart';
import 'package:blindspot/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionDetailScreen extends ConsumerWidget {
  final String subscriptionId;
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsAsync = ref.watch(subscriptionsProvider);

    return subscriptionsAsync.when(
      data: (subscriptions) {
        final sub = subscriptions.firstWhere((s) => s.id == subscriptionId, orElse: () => throw Exception('Not found'));
        return Scaffold(
          appBar: BSAppBar(
            title: AppStrings.subscriptionDetails,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push(
                    '/subscriptions/$subscriptionId/edit'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.statusDanger),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      title:
                          const Text(AppStrings.deleteSubscription),
                      content: const Text(
                          AppStrings.deleteSubscriptionConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text(AppStrings.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(
                                    subscriptionNotifierProvider.notifier)
                                .deleteSubscription(subscriptionId);
                            Navigator.pop(c);
                            context.pop();
                          },
                          child: const Text(AppStrings.delete,
                              style: TextStyle(
                                  color: AppColors.statusDanger)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Column(
              children: [
                BSCard(
                  gradient: const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                  child: Center(
                    child: Column(
                      children: [
                        Text(sub.serviceName, style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text('${CurrencyFormatter.format(sub.amount, sub.currency)}/${sub.billingCycle.shortLabel}', style: GoogleFonts.jetBrainsMono(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 12),
                        if (sub.isActive)
                          BSBadge.safe(AppStrings.filterActive)
                        else
                          BSBadge.warning(AppStrings.filterCancelled),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                BSCard(
                  child: Column(
                    children: [
                      _DetailRow(AppStrings.billingCycleLabel,
                          sub.billingCycle.label),
                      const Divider(height: 32),
                      _DetailRow(AppStrings.nextBillingDate,
                          DateFormatter.toDisplay(sub.nextBillingDate)),
                      const Divider(height: 32),
                      _DetailRow(
                        'Monthly Equivalent',
                        CurrencyFormatter.format(
                            sub.monthlyEquivalent, sub.currency),
                      ),
                      const Divider(height: 32),
                      _DetailRow(AppStrings.category, sub.category.label),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: context.secondaryTextColor)),
        Text(value,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: context.primaryTextColor)),
      ],
    );
  }
}
