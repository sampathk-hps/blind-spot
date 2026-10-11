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
import 'package:blindspot/shared/widgets/bs_card.dart';
import 'package:blindspot/shared/widgets/bs_empty_state.dart';
import 'package:blindspot/shared/widgets/bs_loading.dart';
import 'package:blindspot/features/subscriptions/presentation/providers/subscription_provider.dart';

/// Filter tabs — all values sourced from [AppStrings].
const List<String> _kSubscriptionFilters = [
  AppStrings.filterAll,
  AppStrings.filterActive,
  AppStrings.filterCancelled,
];
import 'package:google_fonts/google_fonts.dart';

class SubscriptionListScreen extends ConsumerStatefulWidget {
  const SubscriptionListScreen({super.key});

  @override
  ConsumerState<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends ConsumerState<SubscriptionListScreen> {
  String _filter = AppStrings.filterAll;

  @override
  Widget build(BuildContext context) {
    final subscriptionsAsync = ref.watch(subscriptionsProvider);

    return Scaffold(
      appBar: BSAppBar(
        title: AppStrings.subscriptions,
        showBackButton: false,
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => context.push('/subscriptions/add')),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Row(
              children: _kSubscriptionFilters.map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: AppColors.brandAccentLight,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.brandAccentDark
                          : context.secondaryTextColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.brandAccent
                            : context.borderColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: subscriptionsAsync.when(
              data: (subscriptions) {
                final filtered = subscriptions.where((s) {
                  if (_filter == AppStrings.filterAll) return true;
                  if (_filter == AppStrings.filterActive) return s.isActive;
                  if (_filter == AppStrings.filterCancelled) return !s.isActive;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return BSEmptyState(
                    title: AppStrings.noSubscriptions,
                    subtitle: AppStrings.noSubscriptionsSubtitle,
                    icon: Icons.autorenew_rounded,
                    actionLabel: AppStrings.addSubscription,
                    onAction: () => context.push('/subscriptions/add'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final sub = filtered[index];
                    return Dismissible(
                      key: Key(sub.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: AppColors.statusDanger,
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (_) => ref.read(subscriptionNotifierProvider.notifier).deleteSubscription(sub.id),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BSCard(
                          onTap: () => context.push('/subscriptions/${sub.id}'),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(color: AppColors.brandAccentLight, borderRadius: BorderRadius.circular(12)),
                                child: Icon(sub.category.icon, color: AppColors.brandAccent),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sub.serviceName, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: context.primaryTextColor)),
                                    const SizedBox(height: 4),
                                    Text('Next: ${DateFormatter.toDisplay(sub.nextBillingDate)}', style: GoogleFonts.inter(fontSize: 12, color: context.secondaryTextColor)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(CurrencyFormatter.format(sub.amount, sub.currency), style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold, fontSize: 16, color: context.primaryTextColor)),
                                  const SizedBox(height: 4),
                                  Text('/${sub.billingCycle.shortLabel}', style: GoogleFonts.inter(fontSize: 12, color: context.secondaryTextColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => ListView.builder(itemCount: 3, itemBuilder: (_, __) => const BSShimmerCard(height: 80)),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
        ],
      ),
    );
  }
}
