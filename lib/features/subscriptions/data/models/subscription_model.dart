import 'package:blindspot/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:blindspot/shared/models/app_category.dart';
import 'package:blindspot/shared/models/billing_cycle.dart';

/// Data-layer representation of a [SubscriptionEntity] with Hive serialisation.
final class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.serviceName,
    required super.amount,
    required super.currency,
    required super.billingCycle,
    required super.nextBillingDate,
    required super.category,
    required super.status,
    required super.tags,
    super.notes,
    super.logoUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Promotes a pure domain entity to a [SubscriptionModel].
  factory SubscriptionModel.fromEntity(SubscriptionEntity e) =>
      SubscriptionModel(
        id: e.id,
        serviceName: e.serviceName,
        amount: e.amount,
        currency: e.currency,
        billingCycle: e.billingCycle,
        nextBillingDate: e.nextBillingDate,
        category: e.category,
        status: e.status,
        tags: e.tags,
        notes: e.notes,
        logoUrl: e.logoUrl,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  /// Serialises this model to a plain [Map] suitable for Hive storage.
  Map<String, dynamic> toMap() => {
        'id': id,
        'serviceName': serviceName,
        'amount': amount,
        'currency': currency,
        'billingCycle': billingCycle.toJson(),
        'nextBillingDate': nextBillingDate.toIso8601String(),
        'category': category.toJson(),
        'status': status.toJson(),
        'tags': tags,
        'notes': notes,
        'logoUrl': logoUrl,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Deserialises a [SubscriptionModel] from a Hive map.
  factory SubscriptionModel.fromMap(Map<String, dynamic> map) =>
      SubscriptionModel(
        id: map['id'] as String,
        serviceName: map['serviceName'] as String,
        amount: (map['amount'] as num).toDouble(),
        currency: map['currency'] as String? ?? 'USD',
        billingCycle: BillingCycle.fromJson(map['billingCycle'] as String?),
        nextBillingDate: DateTime.parse(map['nextBillingDate'] as String),
        category: AppCategory.fromJson(map['category'] as String?),
        status: SubscriptionStatus.fromJson(map['status'] as String?),
        tags: List<String>.from(map['tags'] as List? ?? []),
        notes: map['notes'] as String?,
        logoUrl: map['logoUrl'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
