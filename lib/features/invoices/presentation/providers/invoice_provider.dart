import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:blindspot/features/invoices/domain/entities/invoice_entity.dart';
import 'package:blindspot/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:blindspot/features/invoices/data/repositories/invoice_repository_impl.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(hiveService: ref.read(hiveServiceProvider));
});

final invoicesProvider = FutureProvider<List<InvoiceEntity>>((ref) {
  return ref.watch(invoiceRepositoryProvider).getAllInvoices();
});

final invoiceNotifierProvider =
    StateNotifierProvider<InvoiceNotifier, AsyncValue<void>>(
        (ref) => InvoiceNotifier(ref));

class InvoiceNotifier extends StateNotifier<AsyncValue<void>> {
  InvoiceNotifier(this._ref) : super(const AsyncValue.data(null));
  final Ref _ref;

  InvoiceRepository get _repo => _ref.read(invoiceRepositoryProvider);

  Future<void> addInvoice(InvoiceEntity invoice) async {
    state = const AsyncValue.loading();
    try {
      await _repo.saveInvoice(invoice);
      _ref.invalidate(invoicesProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> updateInvoice(InvoiceEntity invoice) => addInvoice(invoice);

  Future<void> deleteInvoice(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteInvoice(id);
      _ref.invalidate(invoicesProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> markAsPaid(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.markAsPaid(id);
      _ref.invalidate(invoicesProvider);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }
}
