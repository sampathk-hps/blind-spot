import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:blindspot/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:blindspot/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:blindspot/features/subscriptions/data/repositories/subscription_repository_impl.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(hiveService: ref.read(hiveServiceProvider));
});

final subscriptionsProvider = FutureProvider<List<SubscriptionEntity>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).getAllSubscriptions();
});

final subscriptionNotifierProvider =
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<void>>(
        (ref) => SubscriptionNotifier(ref));

class SubscriptionNotifier extends StateNotifier<AsyncValue<void>> {
  SubscriptionNotifier(this._ref) : super(const AsyncValue.data(null));
  final Ref _ref;

  SubscriptionRepository get _repo => _ref.read(subscriptionRepositoryProvider);

  Future<void> addSubscription(SubscriptionEntity subscription) async {
    state = const AsyncValue.loading();
    try {
      await _repo.saveSubscription(subscription);
      _ref.invalidate(subscriptionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> updateSubscription(SubscriptionEntity subscription) => addSubscription(subscription);

  Future<void> deleteSubscription(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteSubscription(id);
      _ref.invalidate(subscriptionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> updateStatus(String id, SubscriptionStatus status) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateStatus(id, status);
      _ref.invalidate(subscriptionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }
}
