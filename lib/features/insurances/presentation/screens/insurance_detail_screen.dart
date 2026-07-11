import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/utils/currency_formatter.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/shared/widgets/bs_badge.dart';
import 'package:blindspot/shared/widgets/bs_card.dart';
import 'package:blindspot/features/insurances/presentation/providers/insurance_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class InsuranceDetailScreen extends ConsumerWidget {
  final String insuranceId;
  const InsuranceDetailScreen({super.key, required this.insuranceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insurancesAsync = ref.watch(insurancesProvider);

    return insurancesAsync.when(
      data: (insurances) {
        final insurance = insurances.firstWhere((i) => i.id == insuranceId, orElse: () => throw Exception('Not found'));
        return Scaffold(
          appBar: BSAppBar(
            title: 'Insurance Details',
            actions: [
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.push('/insurances/$insuranceId/edit')),
              IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.statusDanger), onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Delete Insurance'),
                    content: const Text('Are you sure you want to delete this policy?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                      TextButton(onPressed: () {
                        ref.read(insuranceNotifierProvider.notifier).deleteInsurance(insuranceId);
                        Navigator.pop(c);
                        context.pop();
                      }, child: const Text('Delete', style: TextStyle(color: AppColors.statusDanger))),
                    ],
                  ),
                );
              }),
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
                        Text(insurance.provider, style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(CurrencyFormatter.format(insurance.premium, 'USD'), style: GoogleFonts.jetBrainsMono(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 12),
                        if (insurance.isExpired) BSBadge.danger('Expired')
                        else if (insurance.isExpiringSoon) BSBadge.warning('Expiring Soon')
                        else BSBadge.safe('Active'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                BSCard(
                  child: Column(
                    children: [
                      _DetailRow('Policy Number', insurance.policyNumber),
                      const Divider(height: 32),
                      _DetailRow('Type', insurance.type.label),
                      const Divider(height: 32),
                      _DetailRow('Renewal Date', DateFormatter.toDisplay(insurance.renewalDate)),
                      if (insurance.notes != null && insurance.notes!.isNotEmpty) ...[
                        const Divider(height: 32),
                        _DetailRow('Notes', insurance.notes!),
                      ],
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
  final Color? valueColor;
  const _DetailRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: context.secondaryTextColor)),
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: valueColor ?? context.primaryTextColor)),
      ],
    );
  }
}
