import 'package:equatable/equatable.dart';

class PurchaseReturnItem extends Equatable {
  final String id;
  final String returnId;
  final String purchaseItemId;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final String? reason;
  final DateTime createdAt;

  const PurchaseReturnItem({
    required this.id,
    required this.returnId,
    required this.purchaseItemId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    this.reason,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    returnId,
    purchaseItemId,
    productId,
    productName,
    quantity,
    unitPrice,
    totalAmount,
    reason,
    createdAt,
  ];

  PurchaseReturnItem copyWith({
    String? id,
    String? returnId,
    String? purchaseItemId,
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalAmount,
    String? reason,
    DateTime? createdAt,
  }) {
    return PurchaseReturnItem(
      id: id ?? this.id,
      returnId: returnId ?? this.returnId,
      purchaseItemId: purchaseItemId ?? this.purchaseItemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
