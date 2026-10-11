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
import 'package:blindspot/shared/widgets/bs_empty_state.dart';
import 'package:blindspot/shared/widgets/bs_loading.dart';
import 'package:blindspot/features/insurances/domain/entities/insurance_entity.dart';
import 'package:blindspot/features/insurances/presentation/providers/insurance_provider.dart';

/// Filter tabs — all values sourced from [AppStrings].
const List<String> _kInsuranceFilters = [
  AppStrings.filterAll,
  AppStrings.filterActive,
  AppStrings.filterExpiringSoon,
  AppStrings.filterExpired,
];
import 'package:google_fonts/google_fonts.dart';

class InsuranceListScreen extends ConsumerStatefulWidget {
  const InsuranceListScreen({super.key});

  @override
  ConsumerState<InsuranceListScreen> createState() => _InsuranceListScreenState();
}

class _InsuranceListScreenState extends ConsumerState<InsuranceListScreen> {
  String _filter = AppStrings.filterAll;

  @override
  Widget build(BuildContext context) {
    final insurancesAsync = ref.watch(insurancesProvider);

    return Scaffold(
      appBar: BSAppBar(
        title: AppStrings.insurances,
        showBackButton: false,
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => context.push('/insurances/add')),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Row(
              children: _kInsuranceFilters.map((f) {
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
            child: insurancesAsync.when(
              data: (insurances) {
                final filtered = insurances.where((i) {
                  if (_filter == AppStrings.filterAll) return true;
                  if (_filter == AppStrings.filterActive)
                    return i.computedStatus == InsuranceStatus.active;
                  if (_filter == AppStrings.filterExpiringSoon)
                    return i.isExpiringSoon;
                  if (_filter == AppStrings.filterExpired) return i.isExpired;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return BSEmptyState(
                    title: AppStrings.noInsurances,
                    subtitle: AppStrings.noInsurancesSubtitle,
                    icon: Icons.shield_outlined,
                    actionLabel: AppStrings.addInsurance,
                    onAction: () => context.push('/insurances/add'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final ins = filtered[index];
                    return Dismissible(
                      key: Key(ins.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: AppColors.statusDanger,
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (_) => ref.read(insuranceNotifierProvider.notifier).deleteInsurance(ins.id),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BSCard(
                          onTap: () => context.push('/insurances/${ins.id}'),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.metricInsuranceBackground,
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.radiusMd),
                                ),
                                child: Icon(ins.type.icon,
                                    color: AppColors.metricInsuranceColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ins.provider, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: context.primaryTextColor)),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Renews ${DateFormatter.toDisplay(ins.renewalDate)}',
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: context.secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(
                                        ins.premium,
                                        AppStrings.defaultCurrency),
                                    style: GoogleFonts.jetBrainsMono(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: context.primaryTextColor),
                                  ),
                                  const SizedBox(height: 4),
                                  if (ins.isExpired)
                                    BSBadge.danger(AppStrings.filterExpired,
                                        small: true)
                                  else if (ins.isExpiringSoon)
                                    BSBadge.warning(
                                        AppStrings.filterExpiringSoon,
                                        small: true)
                                  else
                                    BSBadge.safe(AppStrings.filterActive,
                                        small: true),
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
