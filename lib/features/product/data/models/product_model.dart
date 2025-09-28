import 'package:cashier_pos/features/category/data/models/category_model.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';

class ProductModel {
  final int? id;
  final String productCode;
  final String productName;
  final int categoryId;
  final double salePrice;
  final double costPrice;
  final int minQuantity;
  final int currentStock;
  final String unit;
  final bool isActive;
  final String? barcode;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryModel? category;

  ProductModel({
    this.id,
    required this.productCode,
    required this.productName,
    required this.categoryId,
    required this.salePrice,
    required this.costPrice,
    required this.minQuantity,
    required this.currentStock,
    this.unit = 'piece',
    this.isActive = true,
    this.barcode,
    this.imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.category,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      productCode: map['product_code'] as String,
      productName: map['product_name'] as String,
      categoryId: map['category_id'] as int,
      salePrice: (map['sale_price'] as num).toDouble(),
      costPrice: (map['cost_price'] as num).toDouble(),
      minQuantity: map['min_quantity'] as int,
      currentStock: map['current_stock'] as int,
      unit: map['unit'] as String? ?? 'piece',
      isActive: map['is_active'] == 1,
      barcode: map['barcode'] as String?,
      imagePath: map['image_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      category: map['category'] != null 
          ? CategoryModel.fromMap(Map<String, dynamic>.from(map['category'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'product_code': productCode,
      'product_name': productName,
      'category_id': categoryId,
      'sale_price': salePrice,
      'cost_price': costPrice,
      'min_quantity': minQuantity,
      'current_stock': currentStock,
      'unit': unit,
      'is_active': isActive ? 1 : 0,
      if (barcode != null) 'barcode': barcode,
      if (imagePath != null) 'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProductModel copyWith({
    int? id,
    String? productCode,
    String? productName,
    int? categoryId,
    double? salePrice,
    double? costPrice,
    int? minQuantity,
    int? currentStock,
    String? unit,
    bool? isActive,
    String? barcode,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    CategoryModel? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      categoryId: categoryId ?? this.categoryId,
      salePrice: salePrice ?? this.salePrice,
      costPrice: costPrice ?? this.costPrice,
      minQuantity: minQuantity ?? this.minQuantity,
      currentStock: currentStock ?? this.currentStock,
      unit: unit ?? this.unit,
      isActive: isActive ?? this.isActive,
      barcode: barcode ?? this.barcode,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  bool get isLowStock => currentStock <= minQuantity;

  // Convert to entity
  Product toEntity() {
    return Product(
      id: id,
      productCode: productCode,
      productName: productName,
      categoryId: categoryId,
      salePrice: salePrice,
      costPrice: costPrice,
      minQuantity: minQuantity,
      currentStock: currentStock,
      unit: Product.unitFromString(unit),
      isActive: isActive,
      barcode: barcode,
      imagePath: imagePath,
      category: category?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
