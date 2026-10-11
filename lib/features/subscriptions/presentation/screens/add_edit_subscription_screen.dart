import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/core/utils/currency_formatter.dart';
import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/models/billing_cycle.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';
import 'package:blindspot/shared/widgets/bs_text_field.dart';
import 'package:blindspot/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:blindspot/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:uuid/uuid.dart';

class AddEditSubscriptionScreen extends ConsumerStatefulWidget {
  final String? subscriptionId;
  const AddEditSubscriptionScreen({super.key, this.subscriptionId});

  @override
  ConsumerState<AddEditSubscriptionScreen> createState() =>
      _AddEditSubscriptionScreenState();
}

class _AddEditSubscriptionScreenState
    extends ConsumerState<AddEditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _currency = AppStrings.defaultCurrency;
  AppCategory _category = AppCategory.software;
  BillingCycle _billingCycle = BillingCycle.monthly;
  DateTime _nextBillingDate = DateTime.now().add(const Duration(days: 30));

  bool get _isEditing => widget.subscriptionId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final subscriptions =
            ref.read(subscriptionsProvider).valueOrNull ?? [];
        try {
          final sub = subscriptions
              .firstWhere((s) => s.id == widget.subscriptionId);
          setState(() {
            _serviceNameController.text = sub.serviceName;
            _amountController.text = sub.amount.toString();
            _notesController.text = sub.notes ?? '';
            _currency = sub.currency;
            _category = sub.category;
            _billingCycle = sub.billingCycle;
            _nextBillingDate = sub.nextBillingDate;
          });
        } catch (_) {}
      });
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _nextBillingDate = date);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final now = DateTime.now();
      final sub = SubscriptionEntity(
        id: widget.subscriptionId ?? const Uuid().v4(),
        serviceName: _serviceNameController.text.trim(),
        amount: amount,
        currency: _currency,
        billingCycle: _billingCycle,
        nextBillingDate: _nextBillingDate,
        category: _category,
        isActive: true,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      ref.read(subscriptionNotifierProvider.notifier).addSubscription(sub);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BSAppBar(
        title: _isEditing
            ? AppStrings.editSubscription
            : AppStrings.addSubscription,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service name
              BSTextField(
                label: AppStrings.serviceName,
                controller: _serviceNameController,
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Amount + Currency
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: BSTextField(
                      label: AppStrings.amount,
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (v) =>
                          v == null || v.isEmpty ? AppStrings.required : null,
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
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                      items: CurrencyFormatter.supportedCurrencies
                          .map((c) =>
                              DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _currency = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              // Billing Cycle
              DropdownButtonFormField<BillingCycle>(
                value: _billingCycle,
                decoration: InputDecoration(
                  labelText: AppStrings.billingCycleLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                items: BillingCycle.values
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c.label)))
                    .toList(),
                onChanged: (v) => setState(() => _billingCycle = v!),
              ),
              const SizedBox(height: AppSizes.md),

              // Category
              DropdownButtonFormField<AppCategory>(
                value: _category,
                decoration: InputDecoration(
                  labelText: AppStrings.category,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
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

              // Next billing date
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: BSTextField(
                    label: AppStrings.nextBillingDate,
                    controller: TextEditingController(
                        text: DateFormatter.toDisplay(_nextBillingDate)),
                    suffix: const Icon(Icons.calendar_today_rounded),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Notes
              BSTextField(
                label: AppStrings.notesOptional,
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: AppSizes.xl),

              BSButton.primary(
                label: AppStrings.saveSubscription,
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
