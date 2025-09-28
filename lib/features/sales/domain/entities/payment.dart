import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonEnum()
enum PaymentMethod {
  @JsonValue('cash')
  cash,
  @JsonValue('card')
  card,
  @JsonValue('bankTransfer')
  bankTransfer,
  @JsonValue('wallet')
  wallet,
  @JsonValue('other')
  other,
}

@JsonSerializable()
class Payment extends Equatable {
  final String? id;
  final String invoiceId;
  final double amount;
  final PaymentMethod method;
  final String? transactionId;
  final String? notes;
  final DateTime paymentDate;
  final String? receivedBy;

  const Payment({
    this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    this.transactionId,
    this.notes,
    required this.paymentDate,
    this.receivedBy,
  });

  /// ✅ JSON factory
  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  /// ✅ JSON serializer
  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    amount,
    method,
    transactionId,
    notes,
    paymentDate,
    receivedBy,
  ];

  Payment copyWith({
    String? id,
    String? invoiceId,
    double? amount,
    PaymentMethod? method,
    String? transactionId,
    String? notes,
    DateTime? paymentDate,
    String? receivedBy,
  }) {
    return Payment(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
      paymentDate: paymentDate ?? this.paymentDate,
      receivedBy: receivedBy ?? this.receivedBy,
    );
  }
}
