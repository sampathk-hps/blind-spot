import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/utils/date_formatter.dart';
import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';
import 'package:blindspot/shared/widgets/bs_text_field.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/features/insurances/domain/entities/insurance_entity.dart';
import 'package:blindspot/features/insurances/presentation/providers/insurance_provider.dart';
import 'package:uuid/uuid.dart';

class AddEditInsuranceScreen extends ConsumerStatefulWidget {
  final String? insuranceId;
  const AddEditInsuranceScreen({super.key, this.insuranceId});

  @override
  ConsumerState<AddEditInsuranceScreen> createState() => _AddEditInsuranceScreenState();
}

class _AddEditInsuranceScreenState extends ConsumerState<AddEditInsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _providerController = TextEditingController();
  final _policyNumberController = TextEditingController();
  final _premiumController = TextEditingController();
  final _notesController = TextEditingController();
  
  InsuranceType _type = InsuranceType.health;
  DateTime _renewalDate = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    if (widget.insuranceId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final insurances = ref.read(insurancesProvider).valueOrNull ?? [];
        try {
          final ins = insurances.firstWhere((i) => i.id == widget.insuranceId);
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
      final ins = InsuranceEntity(
        id: widget.insuranceId ?? const Uuid().v4(),
        provider: _providerController.text,
        policyNumber: _policyNumberController.text,
        type: _type,
        premium: premium,
        renewalDate: _renewalDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      ref.read(insuranceNotifierProvider.notifier).addInsurance(ins);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BSAppBar(title: widget.insuranceId == null ? 'Add Insurance' : 'Edit Insurance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BSTextField(
                label: 'Provider Name',
                controller: _providerController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              BSTextField(
                label: 'Policy Number',
                controller: _policyNumberController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              BSTextField(
                label: 'Premium Amount',
                controller: _premiumController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<InsuranceType>(
                value: _type,
                decoration: InputDecoration(
                  labelText: 'Insurance Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: InsuranceType.values.map((c) => DropdownMenuItem(value: c, child: Row(children: [Icon(c.icon, size: 16), const SizedBox(width: 8), Text(c.label)]))).toList(),
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: AppSizes.md),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: BSTextField(
                    label: 'Renewal Date',
                    controller: TextEditingController(text: DateFormatter.toDisplay(_renewalDate)),
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
              BSButton.primary(label: 'Save Policy', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
