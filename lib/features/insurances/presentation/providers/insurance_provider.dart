import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:blindspot/features/insurances/domain/entities/insurance_entity.dart';
import 'package:blindspot/features/insurances/domain/repositories/insurance_repository.dart';
import 'package:blindspot/features/insurances/data/repositories/insurance_repository_impl.dart';

final insuranceRepositoryProvider = Provider<InsuranceRepository>((ref) {
  return InsuranceRepositoryImpl(hiveService: ref.read(hiveServiceProvider));
});

final insurancesProvider = FutureProvider<List<InsuranceEntity>>((ref) {
  return ref.watch(insuranceRepositoryProvider).getAllInsurances();
});

final insuranceNotifierProvider =
    StateNotifierProvider<InsuranceNotifier, AsyncValue<void>>(
        (ref) => InsuranceNotifier(ref));

class InsuranceNotifier extends StateNotifier<AsyncValue<void>> {
  InsuranceNotifier(this._ref) : super(const AsyncValue.data(null));
  final Ref _ref;

  InsuranceRepository get _repo => _ref.read(insuranceRepositoryProvider);

  Future<void> addInsurance(InsuranceEntity insurance) async {
    state = const AsyncValue.loading();
    try {
      await _repo.saveInsurance(insurance);
      _ref.invalidate(insurancesProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> updateInsurance(InsuranceEntity insurance) => addInsurance(insurance);

  Future<void> deleteInsurance(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteInsurance(id);
      _ref.invalidate(insurancesProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }
}
