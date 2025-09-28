import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale_item.g.dart';

@JsonSerializable()
class SaleItem extends Equatable {
  final String? id;
  final String productId;
  final String productName;
  final String productCode;
  final double price;
  final int quantity;
  final double discount;
  final double tax;
  final String? unit;
  final String? barcode;

  const SaleItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.price,
    required this.quantity,
    this.discount = 0.0,
    this.tax = 0.0,
    this.unit = 'pcs',
    this.barcode,
  });

  double get subtotal => price * quantity;
  double get total => subtotal - discount + tax;

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    productCode,
    price,
    quantity,
    discount,
    tax,
    unit,
    barcode,
  ];

  SaleItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productCode,
    double? price,
    int? quantity,
    double? discount,
    double? tax,
    String? unit,
    String? barcode,
  }) {
    return SaleItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productCode: productCode ?? this.productCode,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      unit: unit ?? this.unit,
      barcode: barcode ?? this.barcode,
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);

  Map<String, dynamic> toJson() => _$SaleItemToJson(this);
}
