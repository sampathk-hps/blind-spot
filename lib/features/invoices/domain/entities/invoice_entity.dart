import 'package:blindspot/shared/models/app_category.dart';

enum InvoiceStatus {
  paid,
  unpaid,
  overdue;

  String get displayLabel {
    switch (this) {
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.unpaid:
        return 'Unpaid';
      case InvoiceStatus.overdue:
        return 'Overdue';
    }
  }

  String toJson() => name;

  static InvoiceStatus fromJson(String? value) => InvoiceStatus.values
      .firstWhere((s) => s.name == value, orElse: () => InvoiceStatus.unpaid);
}

final class InvoiceEntity {
  final String id;
  final String vendor;
  final double amount;
  final String currency;
  final DateTime dueDate;
  final InvoiceStatus status;
  final AppCategory category;
  final List<String> tags;
  final String? attachmentPath;
  final String? notes;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InvoiceEntity({
    required this.id,
    required this.vendor,
    required this.amount,
    required this.currency,
    required this.dueDate,
    required this.status,
    required this.category,
    required this.tags,
    this.attachmentPath,
    this.notes,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOverdue =>
      dueDate.isBefore(DateTime.now()) && status != InvoiceStatus.paid;

  bool get isPaid => status == InvoiceStatus.paid;

  bool get isDueSoon {
    final days = dueDate.difference(DateTime.now()).inDays;
    return days >= 0 && days <= 7 && !isPaid;
  }

  InvoiceEntity copyWith({
    String? id,
    String? vendor,
    double? amount,
    String? currency,
    DateTime? dueDate,
    InvoiceStatus? status,
    AppCategory? category,
    List<String>? tags,
    String? attachmentPath,
    String? notes,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InvoiceEntity(
      id: id ?? this.id,
      vendor: vendor ?? this.vendor,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      notes: notes ?? this.notes,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
