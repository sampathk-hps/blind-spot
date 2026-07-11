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
import 'package:blindspot/shared/widgets/bs_button.dart';
import 'package:blindspot/shared/widgets/bs_card.dart';
import 'package:blindspot/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return invoicesAsync.when(
      data: (invoices) {
        final invoice = invoices.firstWhere((i) => i.id == invoiceId, orElse: () => throw Exception('Not found'));
        return Scaffold(
          appBar: BSAppBar(
            title: 'Invoice Details',
            actions: [
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.push('/invoices/$invoiceId/edit')),
              IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.statusDanger), onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Delete Invoice'),
                    content: const Text('Are you sure you want to delete this invoice?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                      TextButton(onPressed: () {
                        ref.read(invoiceNotifierProvider.notifier).deleteInvoice(invoiceId);
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
                        Text(invoice.vendor, style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(CurrencyFormatter.format(invoice.amount, invoice.currency), style: GoogleFonts.jetBrainsMono(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 12),
                        if (invoice.isPaid) BSBadge.safe('Paid')
                        else if (invoice.isOverdue) BSBadge.danger('Overdue')
                        else BSBadge.warning('Unpaid'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                BSCard(
                  child: Column(
                    children: [
                      _DetailRow('Due Date', DateFormatter.toDisplay(invoice.dueDate)),
                      const Divider(height: 32),
                      _DetailRow('Category', invoice.category.label),
                      const Divider(height: 32),
                      _DetailRow('Currency', invoice.currency),
                      if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                        const Divider(height: 32),
                        _DetailRow('Notes', invoice.notes!),
                      ],
                      if (invoice.isPaid && invoice.paidAt != null) ...[
                        const Divider(height: 32),
                        _DetailRow('Paid On', DateFormatter.toDisplay(invoice.paidAt!), valueColor: AppColors.statusSafe),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
                if (!invoice.isPaid)
                  BSButton.primary(
                    label: 'Mark as Paid',
                    onPressed: () {
                      ref.read(invoiceNotifierProvider.notifier).markAsPaid(invoiceId);
                      context.pop();
                    },
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
