import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/models/billing_cycle.dart';

enum InsuranceStatus {
  active,
  expiringSoon,
  expired;

  String get displayLabel {
    switch (this) {
      case InsuranceStatus.active:
        return 'Active';
      case InsuranceStatus.expiringSoon:
        return 'Expiring Soon';
      case InsuranceStatus.expired:
        return 'Expired';
    }
  }

  String toJson() => name;

  static InsuranceStatus fromJson(String? value) =>
      InsuranceStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => InsuranceStatus.active,
      );
}

final class InsuranceEntity {
  final String id;
  final String provider;
  final String policyNumber;
  final InsuranceType type;
  final double premium;
  final BillingCycle billingCycle;
  final DateTime renewalDate;
  final double? coverageAmount;
  final InsuranceStatus status;
  final String? attachmentPath;
  final String? notes;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InsuranceEntity({
    required this.id,
    required this.provider,
    required this.policyNumber,
    required this.type,
    required this.premium,
    required this.billingCycle,
    required this.renewalDate,
    this.coverageAmount,
    required this.status,
    this.attachmentPath,
    this.notes,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns true when the renewal date has already passed.
  bool get isExpired => renewalDate.isBefore(DateTime.now());

  /// Returns true when renewal is within 30 days and not yet expired.
  bool get isExpiringSoon {
    if (isExpired) return false;
    final daysUntilRenewal = renewalDate.difference(DateTime.now()).inDays;
    return daysUntilRenewal <= 30;
  }

  /// Monthly-equivalent premium based on the billing cycle.
  double get monthlyEquivalentPremium => billingCycle.toMonthlyAmount(premium);

  /// Derives the current status from [renewalDate] at call time.
  InsuranceStatus get computedStatus {
    if (isExpired) return InsuranceStatus.expired;
    if (isExpiringSoon) return InsuranceStatus.expiringSoon;
    return InsuranceStatus.active;
  }

  InsuranceEntity copyWith({
    String? id,
    String? provider,
    String? policyNumber,
    InsuranceType? type,
    double? premium,
    BillingCycle? billingCycle,
    DateTime? renewalDate,
    double? coverageAmount,
    InsuranceStatus? status,
    String? attachmentPath,
    String? notes,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InsuranceEntity(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      policyNumber: policyNumber ?? this.policyNumber,
      type: type ?? this.type,
      premium: premium ?? this.premium,
      billingCycle: billingCycle ?? this.billingCycle,
      renewalDate: renewalDate ?? this.renewalDate,
      coverageAmount: coverageAmount ?? this.coverageAmount,
      status: status ?? this.status,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
