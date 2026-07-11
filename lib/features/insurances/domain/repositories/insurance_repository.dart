import 'package:blindspot/features/insurances/domain/entities/insurance_entity.dart';

abstract interface class InsuranceRepository {
  /// Returns all insurance policies sorted by renewal date ascending.
  Future<List<InsuranceEntity>> getAllInsurances();

  /// Returns the insurance policy with [id], or null if not found.
  Future<InsuranceEntity?> getInsuranceById(String id);

  /// Persists [insurance] (insert or update).
  Future<void> saveInsurance(InsuranceEntity insurance);

  /// Permanently removes the policy with the given [id].
  Future<void> deleteInsurance(String id);

  /// Returns non-expired policies whose renewal date falls within [withinDays].
  List<InsuranceEntity> getExpiringPolicies({int withinDays = 30});

  /// Returns all policies whose computed status is [InsuranceStatus.active].
  List<InsuranceEntity> getActiveInsurances();

  /// Emits a new list whenever the underlying insurance collection changes.
  Stream<List<InsuranceEntity>> watchInsurances();
}
