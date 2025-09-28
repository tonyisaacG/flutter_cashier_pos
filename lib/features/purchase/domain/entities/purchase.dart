import 'package:equatable/equatable.dart';

class Purchase extends Equatable {
  final String id;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String? supplierId;
  final String? supplierName;
  final String? supplierPhone;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double paidAmount;
  final double dueAmount;
  final PurchaseStatus status;
  final PurchaseType type;
  final String? notes;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? returnRefId;

  const Purchase({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    this.supplierId,
    this.supplierName,
    this.supplierPhone,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paidAmount,
    required this.dueAmount,
    required this.status,
    required this.type,
    this.notes,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.returnRefId,
  });

  @override
  List<Object?> get props => [
    id,
    invoiceNumber,
    invoiceDate,
    supplierId,
    supplierName,
    supplierPhone,
    subtotal,
    discount,
    tax,
    total,
    paidAmount,
    dueAmount,
    status,
    type,
    notes,
    createdBy,
    createdAt,
    updatedAt,
    returnRefId,
  ];

  Purchase copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? invoiceDate,
    String? supplierId,
    String? supplierName,
    String? supplierPhone,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    double? paidAmount,
    double? dueAmount,
    PurchaseStatus? status,
    PurchaseType? type,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? returnRefId,
  }) {
    return Purchase(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      supplierPhone: supplierPhone ?? this.supplierPhone,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      status: status ?? this.status,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      returnRefId: returnRefId ?? this.returnRefId,
    );
  }
}

enum PurchaseStatus {
  draft('مسودة'),
  pending('معلقة'),
  approved('معتمدة'),
  completed('مكتملة'),
  cancelled('ملغية');

  const PurchaseStatus(this.displayName);
  final String displayName;
}

enum PurchaseType {
  cash('نقدي'),
  credit('ائتماني'),
  mixed('مختلط');

  const PurchaseType(this.displayName);
  final String displayName;
}
