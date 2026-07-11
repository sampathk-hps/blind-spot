import 'dart:async';

import 'package:hive/hive.dart';

import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/storage/hive_service.dart';
import 'package:blindspot/features/subscriptions/data/models/subscription_model.dart';
import 'package:blindspot/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:blindspot/features/subscriptions/domain/repositories/subscription_repository.dart';

/// Hive-backed implementation of [SubscriptionRepository].
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl({required HiveService hiveService})
      : _hive = hiveService;

  final HiveService _hive;
  final _controller = StreamController<List<SubscriptionEntity>>.broadcast();

  Box<Map> get _box => _hive.box(AppStrings.hiveBoxSubscriptions);

  // ── Queries ──────────────────────────────────────────────────────────────

  @override
  Future<List<SubscriptionEntity>> getAllSubscriptions() async {
    return _box.values
        .map((m) => SubscriptionModel.fromMap(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
  }

  @override
  Future<SubscriptionEntity?> getSubscriptionById(String id) async {
    final map = _box.get(id);
    if (map == null) return null;
    return SubscriptionModel.fromMap(Map<String, dynamic>.from(map));
  }

  @override
  List<SubscriptionEntity> getActiveSubscriptions() {
    return _box.values
        .map((m) => SubscriptionModel.fromMap(Map<String, dynamic>.from(m)))
        .where((sub) => sub.status == SubscriptionStatus.active)
        .toList();
  }

  @override
  List<SubscriptionEntity> getUpcomingBilling({int withinDays = 7}) {
    final cutoff = DateTime.now().add(Duration(days: withinDays));
    return _box.values
        .map((m) => SubscriptionModel.fromMap(Map<String, dynamic>.from(m)))
        .where((sub) =>
            sub.status == SubscriptionStatus.active &&
            sub.nextBillingDate.isBefore(cutoff))
        .toList()
      ..sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
  }

  @override
  double getTotalMonthlySpend() {
    return _box.values
        .map((m) => SubscriptionModel.fromMap(Map<String, dynamic>.from(m)))
        .where((sub) => sub.status == SubscriptionStatus.active)
        .fold(0.0, (sum, sub) => sum + sub.monthlyEquivalent);
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  @override
  Future<void> saveSubscription(SubscriptionEntity subscription) async {
    await _box.put(
        subscription.id, SubscriptionModel.fromEntity(subscription).toMap());
    _controller.add(await getAllSubscriptions());
  }

  @override
  Future<void> deleteSubscription(String id) async {
    await _box.delete(id);
    _controller.add(await getAllSubscriptions());
  }

  @override
  Future<void> updateStatus(String id, SubscriptionStatus status) async {
    final subscription = await getSubscriptionById(id);
    if (subscription == null) return;
    final updated = subscription.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    await saveSubscription(updated);
  }

  // ── Streams ───────────────────────────────────────────────────────────────

  @override
  Stream<List<SubscriptionEntity>> watchSubscriptions() => _controller.stream;
}
