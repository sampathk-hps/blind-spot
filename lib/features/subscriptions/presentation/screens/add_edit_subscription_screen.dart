import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/core/utils/currency_formatter.dart';
import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/models/billing_cycle.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';
import 'package:blindspot/shared/widgets/bs_text_field.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:blindspot/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:uuid/uuid.dart';

class AddEditSubscriptionScreen extends ConsumerStatefulWidget {
  final String? subscriptionId;
  const AddEditSubscriptionScreen({super.key, this.subscriptionId});

  @override
  ConsumerState<AddEditSubscriptionScreen> createState() => _AddEditSubscriptionScreenState();
}

class _AddEditSubscriptionScreenState extends ConsumerState<AddEditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _currency = 'USD';
  AppCategory _category = AppCategory.software;
  BillingCycle _billingCycle = BillingCycle.monthly;
  DateTime _nextBillingDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    if (widget.subscriptionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final subscriptions = ref.read(subscriptionsProvider).valueOrNull ?? [];
        try {
          final sub = subscriptions.firstWhere((s) => s.id == widget.subscriptionId);
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
      final sub = SubscriptionEntity(
        id: widget.subscriptionId ?? const Uuid().v4(),
        serviceName: _serviceNameController.text,
        amount: amount,
        currency: _currency,
        billingCycle: _billingCycle,
        nextBillingDate: _nextBillingDate,
        category: _category,
        isActive: true,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      ref.read(subscriptionNotifierProvider.notifier).addSubscription(sub);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BSAppBar(title: widget.subscriptionId == null ? 'Add Subscription' : 'Edit Subscription'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BSTextField(
                label: 'Service Name',
                controller: _serviceNameController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: BSTextField(
                      label: 'Amount',
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _currency,
                      decoration: InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: CurrencyFormatter.supportedCurrencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _currency = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<BillingCycle>(
                value: _billingCycle,
                decoration: InputDecoration(
                  labelText: 'Billing Cycle',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: BillingCycle.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
                onChanged: (v) => setState(() => _billingCycle = v!),
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<AppCategory>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: AppCategory.values.map((c) => DropdownMenuItem(value: c, child: Row(children: [Icon(c.icon, size: 16), const SizedBox(width: 8), Text(c.label)]))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: AppSizes.md),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: BSTextField(
                    label: 'Next Billing Date',
                    controller: TextEditingController(text: DateFormatter.toDisplay(_nextBillingDate)),
                    suffix: const Icon(Icons.calendar_today_rounded),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              BSTextField(
                label: 'Notes (Optional)',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: AppSizes.xl),
              BSButton.primary(label: 'Save Subscription', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
