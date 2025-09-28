// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleInvoiceModel _$SaleInvoiceModelFromJson(Map<String, dynamic> json) =>
    SaleInvoiceModel(
      id: json['id'] as String?,
      invoiceNumber: json['invoiceNumber'] as String,
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>?)
          ?.map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble(),
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      dueAmount: (json['dueAmount'] as num?)?.toDouble(),
      status:
          $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status']) ??
          InvoiceStatus.draft,
      type:
          $enumDecodeNullable(_$InvoiceTypeEnumMap, json['type']) ??
          InvoiceType.sale,
      notes: json['notes'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      returnRefId: json['returnRefId'] as String?,
    );

Map<String, dynamic> _$SaleInvoiceModelToJson(SaleInvoiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'invoiceDate': instance.invoiceDate.toIso8601String(),
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'items': instance.items,
      'payments': instance.payments,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'tax': instance.tax,
      'total': instance.total,
      'paidAmount': instance.paidAmount,
      'dueAmount': instance.dueAmount,
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'type': _$InvoiceTypeEnumMap[instance.type]!,
      'notes': instance.notes,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'returnRefId': instance.returnRefId,
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.completed: 'completed',
  InvoiceStatus.returned: 'returned',
  InvoiceStatus.cancelled: 'cancelled',
  InvoiceStatus.partiallyPaid: 'partiallyPaid',
};

const _$InvoiceTypeEnumMap = {
  InvoiceType.sale: 'sale',
  InvoiceType.returnSale: 'returnSale',
};
