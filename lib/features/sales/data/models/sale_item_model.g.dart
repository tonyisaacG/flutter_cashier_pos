// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleItemModel _$SaleItemModelFromJson(Map<String, dynamic> json) =>
    SaleItemModel(
      id: json['id'] as String?,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productCode: json['productCode'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String?,
      barcode: json['barcode'] as String?,
    );

Map<String, dynamic> _$SaleItemModelToJson(SaleItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'productCode': instance.productCode,
      'price': instance.price,
      'quantity': instance.quantity,
      'discount': instance.discount,
      'tax': instance.tax,
      'unit': instance.unit,
      'barcode': instance.barcode,
    };
