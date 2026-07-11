import 'package:blindspot/features/invoices/domain/entities/invoice_entity.dart';
import 'package:blindspot/shared/models/app_category.dart';

/// Data-layer representation of an [InvoiceEntity] with Hive serialisation.
final class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.vendor,
    required super.amount,
    required super.currency,
    required super.dueDate,
    required super.status,
    required super.category,
    required super.tags,
    super.attachmentPath,
    super.notes,
    super.paidAt,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Promotes a pure domain entity to an [InvoiceModel].
  factory InvoiceModel.fromEntity(InvoiceEntity e) => InvoiceModel(
        id: e.id,
        vendor: e.vendor,
        amount: e.amount,
        currency: e.currency,
        dueDate: e.dueDate,
        status: e.status,
        category: e.category,
        tags: e.tags,
        attachmentPath: e.attachmentPath,
        notes: e.notes,
        paidAt: e.paidAt,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  /// Serialises this model to a plain [Map] suitable for Hive storage.
  Map<String, dynamic> toMap() => {
        'id': id,
        'vendor': vendor,
        'amount': amount,
        'currency': currency,
        'dueDate': dueDate.toIso8601String(),
        'status': status.toJson(),
        'category': category.toJson(),
        'tags': tags,
        'attachmentPath': attachmentPath,
        'notes': notes,
        'paidAt': paidAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Deserialises an [InvoiceModel] from a Hive map.
  factory InvoiceModel.fromMap(Map<String, dynamic> map) => InvoiceModel(
        id: map['id'] as String,
        vendor: map['vendor'] as String,
        amount: (map['amount'] as num).toDouble(),
        currency: map['currency'] as String? ?? 'USD',
        dueDate: DateTime.parse(map['dueDate'] as String),
        status: InvoiceStatus.fromJson(map['status'] as String?),
        category: AppCategory.fromJson(map['category'] as String?),
        tags: List<String>.from(map['tags'] as List? ?? []),
        attachmentPath: map['attachmentPath'] as String?,
        notes: map['notes'] as String?,
        paidAt: map['paidAt'] != null
            ? DateTime.parse(map['paidAt'] as String)
            : null,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
