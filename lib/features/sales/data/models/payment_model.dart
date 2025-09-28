import 'package:json_annotation/json_annotation.dart';
import 'package:cashier_pos/features/sales/domain/entities/payment.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel extends Payment {
  PaymentModel({
    String? id,
    required String invoiceId,
    required double amount,
    required PaymentMethod method,
    String? transactionId,
    String? notes,
    required DateTime paymentDate,
    String? receivedBy,
  }) : super(
         id: id,
         invoiceId: invoiceId,
         amount: amount,
         method: method,
         transactionId: transactionId,
         notes: notes,
         paymentDate: paymentDate,
         receivedBy: receivedBy,
       );

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  factory PaymentModel.fromEntity(Payment entity) => PaymentModel(
        id: entity.id,
        invoiceId: entity.invoiceId,
        amount: entity.amount,
        method: entity.method,
        transactionId: entity.transactionId,
        notes: entity.notes,
        paymentDate: entity.paymentDate,
        receivedBy: entity.receivedBy,
      );

  Payment toEntity() => Payment(
    id: id,
    invoiceId: invoiceId,
    amount: amount,
    method: method,
    transactionId: transactionId,
    notes: notes,
    paymentDate: paymentDate,
    receivedBy: receivedBy,
  );
}
