import 'package:blindspot/features/subscriptions/domain/entities/subscription_entity.dart';

abstract interface class SubscriptionRepository {
  /// Returns all subscriptions sorted by next billing date ascending.
  Future<List<SubscriptionEntity>> getAllSubscriptions();

  /// Returns the subscription with [id], or null if not found.
  Future<SubscriptionEntity?> getSubscriptionById(String id);

  /// Persists [subscription] (insert or update).
  Future<void> saveSubscription(SubscriptionEntity subscription);

  /// Permanently removes the subscription with [id].
  Future<void> deleteSubscription(String id);

  /// Updates the status of the subscription identified by [id].
  Future<void> updateStatus(String id, SubscriptionStatus status);

  /// Returns all subscriptions whose status is [SubscriptionStatus.active].
  List<SubscriptionEntity> getActiveSubscriptions();

  /// Returns active subscriptions whose next billing date is within [withinDays].
  List<SubscriptionEntity> getUpcomingBilling({int withinDays = 7});

  /// Returns the total monthly spend across all active subscriptions.
  double getTotalMonthlySpend();

  /// Emits a new list whenever the underlying subscription collection changes.
  Stream<List<SubscriptionEntity>> watchSubscriptions();
}
