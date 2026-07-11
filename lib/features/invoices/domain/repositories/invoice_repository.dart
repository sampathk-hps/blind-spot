import 'package:blindspot/features/invoices/domain/entities/invoice_entity.dart';

abstract interface class InvoiceRepository {
  /// Returns all invoices sorted by due date ascending.
  Future<List<InvoiceEntity>> getAllInvoices();

  /// Returns a single invoice by [id], or null if not found.
  Future<InvoiceEntity?> getInvoiceById(String id);

  /// Persists [invoice] (insert or update).
  Future<void> saveInvoice(InvoiceEntity invoice);

  /// Permanently removes the invoice with the given [id].
  Future<void> deleteInvoice(String id);

  /// Marks the invoice identified by [id] as paid with the current timestamp.
  Future<void> markAsPaid(String id);

  /// Returns unpaid invoices whose due date falls within [withinDays] from now.
  List<InvoiceEntity> getUpcomingDeadlines({int withinDays = 30});

  /// Returns all invoices that are currently overdue.
  List<InvoiceEntity> getOverdueInvoices();

  /// Returns the sum of amounts for all unpaid invoices.
  double getTotalAmountDue();

  /// Emits a new list whenever the underlying invoice collection changes.
  Stream<List<InvoiceEntity>> watchInvoices();
}
