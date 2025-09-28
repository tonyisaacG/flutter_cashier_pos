import 'package:json_annotation/json_annotation.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_item.dart';
import 'package:cashier_pos/features/sales/domain/entities/payment.dart';
import 'package:cashier_pos/features/sales/data/models/sale_item_model.dart';
import 'package:cashier_pos/features/sales/data/models/payment_model.dart';

part 'sale_invoice_model.g.dart';

@JsonSerializable()
class SaleInvoiceModel extends SaleInvoice {
  SaleInvoiceModel({
    String? id,
    required String invoiceNumber,
    required DateTime invoiceDate,
    String? customerId,
    String? customerName,
    String? customerPhone,
    required List<SaleItemModel> items,
    List<PaymentModel>? payments,
    double? subtotal,
    double discount = 0.0,
    double tax = 0.0,
    double? total,
    double? paidAmount,
    double? dueAmount,
    InvoiceStatus status = InvoiceStatus.draft,
    InvoiceType type = InvoiceType.sale,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? returnRefId,
  }) : super(
         id: id,
         invoiceNumber: invoiceNumber,
         invoiceDate: invoiceDate,
         customerId: customerId,
         customerName: customerName,
         customerPhone: customerPhone,
         items: items,
         payments: payments,
         subtotal: subtotal,
         discount: discount,
         tax: tax,
         total: total,
         paidAmount: paidAmount,
         dueAmount: dueAmount,
         status: status,
         type: type,
         notes: notes,
         createdBy: createdBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
         returnRefId: returnRefId,
       );

  factory SaleInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$SaleInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleInvoiceModelToJson(this);

  factory SaleInvoiceModel.fromEntity(SaleInvoice entity) => SaleInvoiceModel(
    id: entity.id,
    invoiceNumber: entity.invoiceNumber,
    invoiceDate: entity.invoiceDate,
    customerId: entity.customerId,
    customerName: entity.customerName,
    customerPhone: entity.customerPhone,
    items: entity.items.map((item) => SaleItemModel.fromEntity(item)).toList(),
    payments: entity.payments
        .map((payment) => PaymentModel.fromEntity(payment))
        .toList(),
    subtotal: entity.subtotal,
    discount: entity.discount,
    tax: entity.tax,
    total: entity.total,
    paidAmount: entity.paidAmount,
    dueAmount: entity.dueAmount,
    status: entity.status,
    type: entity.type,
    notes: entity.notes,
    createdBy: entity.createdBy,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    returnRefId: entity.returnRefId,
  );

  @override
  SaleInvoiceModel copyWith({
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
    return SaleInvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: (items ?? this.items)
          .map(
            (item) =>
                item is SaleItemModel ? item : SaleItemModel.fromEntity(item),
          )
          .toList(),
      payments: (payments ?? this.payments)
          .map(
            (payment) => payment is PaymentModel
                ? payment
                : PaymentModel.fromEntity(payment),
          )
          .toList(),
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

  SaleInvoice toEntity() {
    return SaleInvoice(
      id: id,
      invoiceNumber: invoiceNumber,
      invoiceDate: invoiceDate,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      items: items.map((item) => (item as SaleItemModel).toEntity()).toList(),
      payments:
          payments
              ?.map((payment) => (payment as PaymentModel).toEntity())
              .toList() ??
          [],
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      paidAmount: paidAmount,
      dueAmount: dueAmount,
      status: status,
      type: type,
      notes: notes,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      returnRefId: returnRefId,
    );
  }
}
