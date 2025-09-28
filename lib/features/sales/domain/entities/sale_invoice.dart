import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'sale_item.dart';
import 'payment.dart';

@JsonEnum()
enum InvoiceStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('completed')
  completed,
  @JsonValue('returned')
  returned,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('partiallyPaid')
  partiallyPaid,
}

@JsonEnum()
enum InvoiceType {
  @JsonValue('sale')
  sale,
  @JsonValue('returnSale')
  returnSale,
}

@JsonSerializable()
class SaleInvoice extends Equatable {
  final String? id;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final List<SaleItem> items;
  final List<Payment> payments;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double paidAmount;
  final double dueAmount;
  final InvoiceStatus status;
  final InvoiceType type;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? returnRefId; // For return invoices

  SaleInvoice({
    this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    this.customerId,
    this.customerName,
    this.customerPhone,
    required this.items,
    List<Payment>? payments,
    double? subtotal,
    this.discount = 0.0,
    this.tax = 0.0,
    double? total,
    double? paidAmount,
    double? dueAmount,
    this.status = InvoiceStatus.draft,
    this.type = InvoiceType.sale,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.returnRefId,
  }) : payments = payments ?? [],
       subtotal = subtotal ?? items.fold(0, (sum, item) => sum + item.subtotal),
       total =
           total ??
           (subtotal ??
               items.fold(0, (sum, item) => sum ?? 0 + item.subtotal)) ??
           0 - discount ??
           0 + tax ??
           0,
       paidAmount = paidAmount ?? 0.0,
       dueAmount =
           dueAmount ??
           (total ??
               (subtotal ??
                   items.fold(0, (sum, item) => sum ?? 0 + item.subtotal)) ??
               0 - discount ??
               0 + tax ??
               0 - (paidAmount ?? 0.0));

  bool get isFullyPaid => dueAmount <= 0 && status != InvoiceStatus.cancelled;
  bool get isReturn => type == InvoiceType.returnSale;
  bool get hasReturns => returnRefId != null;

  @override
  List<Object?> get props => [
    id,
    invoiceNumber,
    invoiceDate,
    customerId,
    customerName,
    customerPhone,
    items,
    payments,
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

  SaleInvoice copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? invoiceDate,
    String? customerId,
    String? customerName,
    String? customerPhone,
    List<SaleItem>? items,
    List<Payment>? payments,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    double? paidAmount,
    double? dueAmount,
    InvoiceStatus? status,
    InvoiceType? type,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? returnRefId,
  }) {
    return SaleInvoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      payments: payments ?? this.payments,
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
