import 'package:equatable/equatable.dart';

class PurchaseReturn extends Equatable {
  final String id;
  final String returnNumber;
  final DateTime returnDate;
  final String purchaseInvoiceId;
  final String? supplierId;
  final String? supplierName;
  final double totalAmount;
  final String? reason;
  final String? notes;
  final String? createdBy;
  final DateTime createdAt;

  const PurchaseReturn({
    required this.id,
    required this.returnNumber,
    required this.returnDate,
    required this.purchaseInvoiceId,
    this.supplierId,
    this.supplierName,
    required this.totalAmount,
    this.reason,
    this.notes,
    this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    returnNumber,
    returnDate,
    purchaseInvoiceId,
    supplierId,
    supplierName,
    totalAmount,
    reason,
    notes,
    createdBy,
    createdAt,
  ];

  PurchaseReturn copyWith({
    String? id,
    String? returnNumber,
    DateTime? returnDate,
    String? purchaseInvoiceId,
    String? supplierId,
    String? supplierName,
    double? totalAmount,
    String? reason,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return PurchaseReturn(
      id: id ?? this.id,
      returnNumber: returnNumber ?? this.returnNumber,
      returnDate: returnDate ?? this.returnDate,
      purchaseInvoiceId: purchaseInvoiceId ?? this.purchaseInvoiceId,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      totalAmount: totalAmount ?? this.totalAmount,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
