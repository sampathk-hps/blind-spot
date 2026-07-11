import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/models/billing_cycle.dart';

enum SubscriptionStatus {
  active,
  paused,
  cancelled;

  String get displayLabel {
    switch (this) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.paused:
        return 'Paused';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String toJson() => name;

  static SubscriptionStatus fromJson(String? value) =>
      SubscriptionStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => SubscriptionStatus.active,
      );
}

final class SubscriptionEntity {
  final String id;
  final String serviceName;
  final double amount;
  final String currency;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final AppCategory category;
  final SubscriptionStatus status;
  final List<String> tags;
  final String? notes;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionEntity({
    required this.id,
    required this.serviceName,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
    required this.status,
    required this.tags,
    this.notes,
    this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns true when the subscription is currently active.
  bool get isActive => status == SubscriptionStatus.active;

  /// Monthly-equivalent cost derived from the billing cycle.
  double get monthlyEquivalent => billingCycle.toMonthlyAmount(amount);

  /// Returns true when the next billing date is within 7 days and the
  /// subscription is active.
  bool get isDueSoon {
    if (!isActive) return false;
    final days = nextBillingDate.difference(DateTime.now()).inDays;
    return days >= 0 && days <= 7;
  }

  SubscriptionEntity copyWith({
    String? id,
    String? serviceName,
    double? amount,
    String? currency,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    AppCategory? category,
    SubscriptionStatus? status,
    List<String>? tags,
    String? notes,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      category: category ?? this.category,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
