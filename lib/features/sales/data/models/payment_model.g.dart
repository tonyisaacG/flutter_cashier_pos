// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  id: json['id'] as String?,
  invoiceId: json['invoiceId'] as String,
  amount: (json['amount'] as num).toDouble(),
  method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
  transactionId: json['transactionId'] as String?,
  notes: json['notes'] as String?,
  paymentDate: DateTime.parse(json['paymentDate'] as String),
  receivedBy: json['receivedBy'] as String?,
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceId': instance.invoiceId,
      'amount': instance.amount,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'transactionId': instance.transactionId,
      'notes': instance.notes,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'receivedBy': instance.receivedBy,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
  PaymentMethod.bankTransfer: 'bankTransfer',
  PaymentMethod.wallet: 'wallet',
  PaymentMethod.other: 'other',
};
