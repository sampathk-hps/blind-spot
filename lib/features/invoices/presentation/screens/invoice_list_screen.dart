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
import 'package:blindspot/features/invoices/domain/entities/invoice_entity.dart';
import 'package:blindspot/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:google_fonts/google_fonts.dart';

/// All filter tab labels in a single, centralised constant list.
const List<String> _kInvoiceFilters = [
  AppStrings.filterAll,
  AppStrings.filterUnpaid,
  AppStrings.filterPaid,
  AppStrings.filterOverdue,
];

class InvoiceListScreen extends ConsumerStatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  ConsumerState<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends ConsumerState<InvoiceListScreen> {
  String _filter = AppStrings.filterAll;

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: BSAppBar(
        title: AppStrings.invoices,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push('/invoices/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Summary header ───────────────────────────────────────────────
          invoicesAsync.when(
            data: (invoices) {
              final totalUnpaid = invoices
                  .where((i) => !i.isPaid)
                  .fold(0.0, (sum, i) => sum + i.amount);
              final overdueCount = invoices.where((i) => i.isOverdue).length;
              return Padding(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.totalUnpaid,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: context.secondaryTextColor,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(
                              totalUnpaid, AppStrings.defaultCurrency),
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    if (overdueCount > 0)
                      BSBadge.danger('$overdueCount ${AppStrings.filterOverdue}'),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // ── Filter chips ─────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding),
            child: Row(
              children: _kInvoiceFilters.map((f) {
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
          const SizedBox(height: AppSizes.md),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: invoicesAsync.when(
              data: (invoices) {
                final filtered = invoices.where((i) {
                  if (_filter == AppStrings.filterAll) return true;
                  if (_filter == AppStrings.filterUnpaid)
                    return !i.isPaid && !i.isOverdue;
                  if (_filter == AppStrings.filterPaid) return i.isPaid;
                  if (_filter == AppStrings.filterOverdue)
                    return i.isOverdue;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return BSEmptyState(
                    title: AppStrings.noInvoices,
                    subtitle: AppStrings.noInvoicesSubtitle,
                    icon: Icons.receipt_long_outlined,
                    actionLabel: AppStrings.addInvoice,
                    onAction: () => context.push('/invoices/add'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final invoice = filtered[index];
                    return Dismissible(
                      key: Key(invoice.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: AppColors.statusDanger,
                        child:
                            const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(invoiceNotifierProvider.notifier)
                            .deleteInvoice(invoice.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _InvoiceListTile(invoice: invoice),
                      ),
                    );
                  },
                );
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                itemCount: 3,
                itemBuilder: (_, __) => const BSShimmerCard(height: 80),
              ),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceListTile extends StatelessWidget {
  final InvoiceEntity invoice;
  const _InvoiceListTile({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return BSCard(
      onTap: () => context.push('/invoices/${invoice.id}'),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.brandAccentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(invoice.category.icon, color: AppColors.brandAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.vendor,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.toDisplay(invoice.dueDate),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(invoice.amount, invoice.currency),
                style: GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              if (invoice.isPaid)
                BSBadge.safe(AppStrings.filterPaid, small: true)
              else if (invoice.isOverdue)
                BSBadge.danger(AppStrings.filterOverdue, small: true)
              else
                BSBadge.warning(AppStrings.filterUnpaid, small: true),
            ],
          ),
        ],
      ),
    );
  }
}
