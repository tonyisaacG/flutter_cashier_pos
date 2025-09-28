import 'package:json_annotation/json_annotation.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_item.dart';

part 'sale_item_model.g.dart';

@JsonSerializable()
class SaleItemModel extends SaleItem {
  SaleItemModel({
    String? id,
    required String productId,
    required String productName,
    required String productCode,
    required double price,
    required int quantity,
    double discount = 0.0,
    double tax = 0.0,
    String? unit,
    String? barcode,
  }) : super(
          id: id,
          productId: productId,
          productName: productName,
          productCode: productCode,
          price: price,
          quantity: quantity,
          discount: discount,
          tax: tax,
          unit: unit,
          barcode: barcode,
        );

  factory SaleItemModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemModelFromJson(json);

  factory SaleItemModel.fromEntity(SaleItem entity) => SaleItemModel(
        id: entity.id,
        productId: entity.productId,
        productName: entity.productName,
        productCode: entity.productCode,
        price: entity.price,
        quantity: entity.quantity,
        discount: entity.discount,
        tax: entity.tax,
        unit: entity.unit,
        barcode: entity.barcode,
      );

  SaleItem toEntity() => SaleItem(
    id: id,
    productId: productId,
    productName: productName,
    productCode: productCode,
    price: price,
    quantity: quantity,
    discount: discount,
    tax: tax,
    unit: unit,
    barcode: barcode,
  );
}
