import 'package:blindspot/features/insurances/domain/entities/insurance_entity.dart';
import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/models/billing_cycle.dart';

/// Data-layer representation of an [InsuranceEntity] with Hive serialisation.
final class InsuranceModel extends InsuranceEntity {
  const InsuranceModel({
    required super.id,
    required super.provider,
    required super.policyNumber,
    required super.type,
    required super.premium,
    required super.billingCycle,
    required super.renewalDate,
    super.coverageAmount,
    required super.status,
    super.attachmentPath,
    super.notes,
    required super.tags,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Promotes a pure domain entity to an [InsuranceModel].
  factory InsuranceModel.fromEntity(InsuranceEntity e) => InsuranceModel(
        id: e.id,
        provider: e.provider,
        policyNumber: e.policyNumber,
        type: e.type,
        premium: e.premium,
        billingCycle: e.billingCycle,
        renewalDate: e.renewalDate,
        coverageAmount: e.coverageAmount,
        status: e.status,
        attachmentPath: e.attachmentPath,
        notes: e.notes,
        tags: e.tags,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  /// Serialises this model to a plain [Map] suitable for Hive storage.
  Map<String, dynamic> toMap() => {
        'id': id,
        'provider': provider,
        'policyNumber': policyNumber,
        'type': type.toJson(),
        'premium': premium,
        'billingCycle': billingCycle.toJson(),
        'renewalDate': renewalDate.toIso8601String(),
        'coverageAmount': coverageAmount,
        'status': status.toJson(),
        'attachmentPath': attachmentPath,
        'notes': notes,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Deserialises an [InsuranceModel] from a Hive map.
  factory InsuranceModel.fromMap(Map<String, dynamic> map) => InsuranceModel(
        id: map['id'] as String,
        provider: map['provider'] as String,
        policyNumber: map['policyNumber'] as String,
        type: InsuranceType.fromJson(map['type'] as String?),
        premium: (map['premium'] as num).toDouble(),
        billingCycle: BillingCycle.fromJson(map['billingCycle'] as String?),
        renewalDate: DateTime.parse(map['renewalDate'] as String),
        coverageAmount: map['coverageAmount'] != null
            ? (map['coverageAmount'] as num).toDouble()
            : null,
        status: InsuranceStatus.fromJson(map['status'] as String?),
        attachmentPath: map['attachmentPath'] as String?,
        notes: map['notes'] as String?,
        tags: List<String>.from(map['tags'] as List? ?? []),
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
