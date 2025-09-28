import 'package:cashier_pos/features/product/data/models/product_model.dart';

enum MovementType {
  purchase('Purchase'),
  sale('Sale'),
  return_('Return'),
  adjustment('Adjustment'),
  damaged('Damaged'),
  found('Found'),
  stockCount('Stock Count');

  final String displayName;
  const MovementType(this.displayName);
}

class InventoryMovementModel {
  final int? id;
  final int productId;
  final int quantity;
  final MovementType type;
  final String reference;
  final String? notes;
  final DateTime movementDate;
  final DateTime createdAt;
  final ProductModel? product;

  InventoryMovementModel({
    this.id,
    required this.productId,
    required this.quantity,
    required this.type,
    required this.reference,
    this.notes,
    DateTime? movementDate,
    DateTime? createdAt,
    this.product,
  })  : movementDate = movementDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  factory InventoryMovementModel.fromMap(Map<String, dynamic> map) {
    return InventoryMovementModel(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      quantity: map['quantity'] as int,
      type: MovementType.values.firstWhere(
        (e) => e.toString() == 'MovementType.${map['type']}',
        orElse: () => MovementType.adjustment,
      ),
      reference: map['reference'] as String,
      notes: map['notes'] as String?,
      movementDate: DateTime.parse(map['movement_date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      product: map['product'] != null
          ? ProductModel.fromMap(Map<String, dynamic>.from(map['product'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'product_id': productId,
      'quantity': quantity,
      'type': type.toString().split('.').last,
      'reference': reference,
      if (notes != null) 'notes': notes,
      'movement_date': movementDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  InventoryMovementModel copyWith({
    int? id,
    int? productId,
    int? quantity,
    MovementType? type,
    String? reference,
    String? notes,
    DateTime? movementDate,
    DateTime? createdAt,
    ProductModel? product,
  }) {
    return InventoryMovementModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      movementDate: movementDate ?? this.movementDate,
      createdAt: createdAt ?? this.createdAt,
      product: product ?? this.product,
    );
  }
}
