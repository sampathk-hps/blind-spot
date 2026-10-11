import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';
import 'package:blindspot/shared/widgets/bs_text_field.dart';
import 'package:blindspot/features/insurances/domain/entities/insurance_entity.dart';
import 'package:blindspot/features/insurances/presentation/providers/insurance_provider.dart';
import 'package:uuid/uuid.dart';

class AddEditInsuranceScreen extends ConsumerStatefulWidget {
  final String? insuranceId;
  const AddEditInsuranceScreen({super.key, this.insuranceId});

  @override
  ConsumerState<AddEditInsuranceScreen> createState() =>
      _AddEditInsuranceScreenState();
}

class _AddEditInsuranceScreenState
    extends ConsumerState<AddEditInsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _providerController = TextEditingController();
  final _policyNumberController = TextEditingController();
  final _premiumController = TextEditingController();
  final _notesController = TextEditingController();

  InsuranceType _type = InsuranceType.health;
  DateTime _renewalDate = DateTime.now().add(const Duration(days: 365));

  bool get _isEditing => widget.insuranceId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final insurances = ref.read(insurancesProvider).valueOrNull ?? [];
        try {
          final ins =
              insurances.firstWhere((i) => i.id == widget.insuranceId);
          setState(() {
            _providerController.text = ins.provider;
            _policyNumberController.text = ins.policyNumber;
            _premiumController.text = ins.premium.toString();
            _notesController.text = ins.notes ?? '';
            _type = ins.type;
            _renewalDate = ins.renewalDate;
          });
        } catch (_) {}
      });
    }
  }

  @override
  void dispose() {
    _providerController.dispose();
    _policyNumberController.dispose();
    _premiumController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _renewalDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _renewalDate = date);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final premium = double.tryParse(_premiumController.text) ?? 0.0;
      final now = DateTime.now();
      final ins = InsuranceEntity(
        id: widget.insuranceId ?? const Uuid().v4(),
        provider: _providerController.text.trim(),
        policyNumber: _policyNumberController.text.trim(),
        type: _type,
        premium: premium,
        renewalDate: _renewalDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      ref.read(insuranceNotifierProvider.notifier).addInsurance(ins);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BSAppBar(
        title: _isEditing
            ? AppStrings.editInsurance
            : AppStrings.addInsurance,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider
              BSTextField(
                label: AppStrings.provider,
                controller: _providerController,
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Policy Number
              BSTextField(
                label: AppStrings.policyNumber,
                controller: _policyNumberController,
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Premium
              BSTextField(
                label: AppStrings.premium,
                controller: _premiumController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.required : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Insurance Type
              DropdownButtonFormField<InsuranceType>(
                value: _type,
                decoration: InputDecoration(
                  labelText: AppStrings.insuranceType,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                items: InsuranceType.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Row(children: [
                            Icon(c.icon, size: 16),
                            const SizedBox(width: 8),
                            Text(c.label),
                          ]),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: AppSizes.md),

              // Renewal Date
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: BSTextField(
                    label: AppStrings.renewalDate,
                    controller: TextEditingController(
                        text: DateFormatter.toDisplay(_renewalDate)),
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
                label: AppStrings.saveInsurance,
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
