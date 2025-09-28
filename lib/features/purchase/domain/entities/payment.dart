import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String invoiceId;
  final double amount;
  final PaymentMethod method;
  final String? transactionId;
  final String? notes;
  final DateTime paymentDate;
  final String? receivedBy;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    this.transactionId,
    this.notes,
    required this.paymentDate,
    this.receivedBy,
    required this.createdAt,
  });

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
    createdAt,
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
    DateTime? createdAt,
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
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum PaymentMethod {
  cash('نقدي'),
  card('بطاقة'),
  bankTransfer('تحويل بنكي'),
  check('شيك'),
  credit('ائتمان');

  const PaymentMethod(this.displayName);
  final String displayName;
}
