import 'dart:async';

import 'package:hive/hive.dart';

import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/storage/hive_service.dart';
import 'package:blindspot/features/invoices/data/models/invoice_model.dart';
import 'package:blindspot/features/invoices/domain/entities/invoice_entity.dart';
import 'package:blindspot/features/invoices/domain/repositories/invoice_repository.dart';

/// Hive-backed implementation of [InvoiceRepository].
class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({required HiveService hiveService})
      : _hive = hiveService;

  final HiveService _hive;
  final _controller = StreamController<List<InvoiceEntity>>.broadcast();

  Box<Map> get _box => _hive.box(AppStrings.hiveBoxInvoices);

  // ── Queries ──────────────────────────────────────────────────────────────

  @override
  Future<List<InvoiceEntity>> getAllInvoices() async {
    return _box.values
        .map((m) => InvoiceModel.fromMap(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  @override
  Future<InvoiceEntity?> getInvoiceById(String id) async {
    final map = _box.get(id);
    if (map == null) return null;
    return InvoiceModel.fromMap(Map<String, dynamic>.from(map));
  }

  @override
  List<InvoiceEntity> getUpcomingDeadlines({int withinDays = 30}) {
    final cutoff = DateTime.now().add(Duration(days: withinDays));
    return _box.values
        .map((m) => InvoiceModel.fromMap(Map<String, dynamic>.from(m)))
        .where((inv) =>
            inv.status != InvoiceStatus.paid &&
            inv.dueDate.isBefore(cutoff))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  @override
  List<InvoiceEntity> getOverdueInvoices() {
    return _box.values
        .map((m) => InvoiceModel.fromMap(Map<String, dynamic>.from(m)))
        .where((inv) => inv.isOverdue)
        .toList();
  }

  @override
  double getTotalAmountDue() {
    return _box.values
        .map((m) => InvoiceModel.fromMap(Map<String, dynamic>.from(m)))
        .where((inv) => inv.status != InvoiceStatus.paid)
        .fold(0.0, (sum, inv) => sum + inv.amount);
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  @override
  Future<void> saveInvoice(InvoiceEntity invoice) async {
    await _box.put(invoice.id, InvoiceModel.fromEntity(invoice).toMap());
    _controller.add(await getAllInvoices());
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await _box.delete(id);
    _controller.add(await getAllInvoices());
  }

  @override
  Future<void> markAsPaid(String id) async {
    final invoice = await getInvoiceById(id);
    if (invoice == null) return;
    final now = DateTime.now();
    final updated = invoice.copyWith(
      status: InvoiceStatus.paid,
      paidAt: now,
      updatedAt: now,
    );
    await saveInvoice(updated);
  }

  // ── Streams ───────────────────────────────────────────────────────────────

  @override
  Stream<List<InvoiceEntity>> watchInvoices() => _controller.stream;
}
