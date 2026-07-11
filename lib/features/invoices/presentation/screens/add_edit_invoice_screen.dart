import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/core/utils/currency_formatter.dart';
import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';
import 'package:blindspot/shared/widgets/bs_premium_gate.dart';
import 'package:blindspot/shared/widgets/bs_text_field.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/features/invoices/domain/entities/invoice_entity.dart';
import 'package:blindspot/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditInvoiceScreen extends ConsumerStatefulWidget {
  final String? invoiceId;
  const AddEditInvoiceScreen({super.key, this.invoiceId});

  @override
  ConsumerState<AddEditInvoiceScreen> createState() =>
      _AddEditInvoiceScreenState();
}

class _AddEditInvoiceScreenState extends ConsumerState<AddEditInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vendorController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _currency = AppStrings.defaultCurrency;
  AppCategory _category = AppCategory.other;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  InvoiceStatus _status = InvoiceStatus.unpaid;

  bool get _isEditing => widget.invoiceId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final invoices = ref.read(invoicesProvider).valueOrNull ?? [];
        try {
          final invoice =
              invoices.firstWhere((i) => i.id == widget.invoiceId);
          setState(() {
            _vendorController.text = invoice.vendor;
            _amountController.text = invoice.amount.toString();
            _notesController.text = invoice.notes ?? '';
            _currency = invoice.currency;
            _category = invoice.category;
            _dueDate = invoice.dueDate;
            _status = invoice.status;
          });
        } catch (_) {}
      });
    }
  }

  @override
  void dispose() {
    _vendorController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final now = DateTime.now();
      final invoice = InvoiceEntity(
        id: widget.invoiceId ?? const Uuid().v4(),
        vendor: _vendorController.text.trim(),
        amount: amount,
        currency: _currency,
        dueDate: _dueDate,
        status: _status,
        category: _category,
        tags: [],
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      ref.read(invoiceNotifierProvider.notifier).addInvoice(invoice);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: BSAppBar(
        title: _isEditing ? AppStrings.editInvoice : AppStrings.addInvoice,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vendor
              BSTextField(
                label: AppStrings.vendorName,
                controller: _vendorController,
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Amount + Currency row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: BSTextField(
                      label: AppStrings.amount,
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return AppStrings.required;
                        if (double.tryParse(v) == null)
                          return AppStrings.invalidNumber;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _currency,
                      decoration: InputDecoration(
                        labelText: AppStrings.currency,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: CurrencyFormatter.supportedCurrencies
                          .map((c) => DropdownMenuItem(
                              value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _currency = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              // Due Date
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: BSTextField(
                    label: AppStrings.dueDate,
                    controller: TextEditingController(
                        text: DateFormatter.toDisplay(_dueDate)),
                    suffix: const Icon(Icons.calendar_today_rounded),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Category
              DropdownButtonFormField<AppCategory>(
                value: _category,
                decoration: InputDecoration(
                  labelText: AppStrings.category,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: AppCategory.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Row(children: [
                            Icon(c.icon, size: 16),
                            const SizedBox(width: 8),
                            Text(c.label),
                          ]),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: AppSizes.md),

              // Status segmented button
              Text(
                AppStrings.status,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              SegmentedButton<InvoiceStatus>(
                segments: [
                  ButtonSegment(
                    value: InvoiceStatus.unpaid,
                    label: Text(AppStrings.filterUnpaid),
                  ),
                  ButtonSegment(
                    value: InvoiceStatus.paid,
                    label: Text(AppStrings.filterPaid),
                  ),
                ],
                selected: {
                  _status == InvoiceStatus.overdue
                      ? InvoiceStatus.unpaid
                      : _status
                },
                onSelectionChanged: (s) => setState(() => _status = s.first),
              ),
              const SizedBox(height: AppSizes.md),

              // Notes
              BSTextField(
                label: AppStrings.notesOptional,
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: AppSizes.md),

              // Smart Auto-Tagging (Premium gate)
              BSPremiumGate(
                isPremium: isPremium,
                featureLabel: AppStrings.smartAutoTagging,
                onUpgradeTap: () => context.push('/premium'),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.tagsPlaceholder,
                      style: GoogleFonts.inter(
                          color: context.secondaryTextColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              BSButton.primary(
                label: AppStrings.saveInvoice,
                onPressed: _save,
              ),
              const SizedBox(height: AppSizes.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
