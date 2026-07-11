import 'dart:async';

import 'package:hive/hive.dart';

import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/storage/hive_service.dart';
import 'package:blindspot/features/insurances/data/models/insurance_model.dart';
import 'package:blindspot/features/insurances/domain/entities/insurance_entity.dart';
import 'package:blindspot/features/insurances/domain/repositories/insurance_repository.dart';

/// Hive-backed implementation of [InsuranceRepository].
class InsuranceRepositoryImpl implements InsuranceRepository {
  InsuranceRepositoryImpl({required HiveService hiveService})
      : _hive = hiveService;

  final HiveService _hive;
  final _controller = StreamController<List<InsuranceEntity>>.broadcast();

  Box<Map> get _box => _hive.box(AppStrings.hiveBoxInsurances);

  // ── Queries ──────────────────────────────────────────────────────────────

  @override
  Future<List<InsuranceEntity>> getAllInsurances() async {
    return _box.values
        .map((m) => InsuranceModel.fromMap(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => a.renewalDate.compareTo(b.renewalDate));
  }

  @override
  Future<InsuranceEntity?> getInsuranceById(String id) async {
    final map = _box.get(id);
    if (map == null) return null;
    return InsuranceModel.fromMap(Map<String, dynamic>.from(map));
  }

  @override
  List<InsuranceEntity> getExpiringPolicies({int withinDays = 30}) {
    final now = DateTime.now();
    final cutoff = now.add(Duration(days: withinDays));
    return _box.values
        .map((m) => InsuranceModel.fromMap(Map<String, dynamic>.from(m)))
        .where((ins) =>
            !ins.isExpired &&
            ins.renewalDate.isBefore(cutoff))
        .toList()
      ..sort((a, b) => a.renewalDate.compareTo(b.renewalDate));
  }

  @override
  List<InsuranceEntity> getActiveInsurances() {
    return _box.values
        .map((m) => InsuranceModel.fromMap(Map<String, dynamic>.from(m)))
        .where((ins) => ins.computedStatus == InsuranceStatus.active)
        .toList();
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  @override
  Future<void> saveInsurance(InsuranceEntity insurance) async {
    await _box.put(
        insurance.id, InsuranceModel.fromEntity(insurance).toMap());
    _controller.add(await getAllInsurances());
  }

  @override
  Future<void> deleteInsurance(String id) async {
    await _box.delete(id);
    _controller.add(await getAllInsurances());
  }

  // ── Streams ───────────────────────────────────────────────────────────────

  @override
  Stream<List<InsuranceEntity>> watchInsurances() => _controller.stream;
}
