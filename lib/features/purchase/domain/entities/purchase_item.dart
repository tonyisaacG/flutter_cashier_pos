import 'package:equatable/equatable.dart';

class PurchaseItem extends Equatable {
  final String id;
  final String invoiceId;
  final String productId;
  final String productName;
  final String productCode;
  final double costPrice;
  final int quantity;
  final double discount;
  final double tax;
  final String? unit;
  final String? barcode;
  final DateTime createdAt;

  const PurchaseItem({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.costPrice,
    required this.quantity,
    required this.discount,
    required this.tax,
    this.unit,
    this.barcode,
    required this.createdAt,
  });

  double get totalAmount {
    final subtotal = costPrice * quantity;
    final discountAmount = subtotal * (discount / 100);
    final taxAmount = (subtotal - discountAmount) * (tax / 100);
    return subtotal - discountAmount + taxAmount;
  }

  double get subtotal {
    return costPrice * quantity;
  }

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    productId,
    productName,
    productCode,
    costPrice,
    quantity,
    discount,
    tax,
    unit,
    barcode,
    createdAt,
  ];

  PurchaseItem copyWith({
    String? id,
    String? invoiceId,
    String? productId,
    String? productName,
    String? productCode,
    double? costPrice,
    int? quantity,
    double? discount,
    double? tax,
    String? unit,
    String? barcode,
    DateTime? createdAt,
  }) {
    return PurchaseItem(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productCode: productCode ?? this.productCode,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      unit: unit ?? this.unit,
      barcode: barcode ?? this.barcode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
