import 'package:equatable/equatable.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';

enum ProductUnit { piece, kg, gram, liter, ml, box, pack, other }

class Product extends Equatable {
  final int? id;
  final String productCode;
  final String productName;
  final int categoryId;
  final double salePrice;
  final double costPrice;
  final int minQuantity;
  final int currentStock;
  final ProductUnit unit;
  final bool isActive;
  final String? barcode;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;

  Product({
    this.id,
    required this.productCode,
    required this.productName,
    required this.categoryId,
    required this.salePrice,
    required this.costPrice,
    this.minQuantity = 0,
    this.currentStock = 0,
    this.unit = ProductUnit.piece,
    this.isActive = true,
    this.barcode,
    this.imagePath,
    this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
    id,
    productCode,
    productName,
    categoryId,
    salePrice,
    costPrice,
    minQuantity,
    currentStock,
    unit,
    isActive,
    barcode,
    imagePath,
    category,
    createdAt,
    updatedAt,
  ];

  Product copyWith({
    int? id,
    String? productCode,
    String? productName,
    int? categoryId,
    double? salePrice,
    double? costPrice,
    int? minQuantity,
    int? currentStock,
    ProductUnit? unit,
    bool? isActive,
    String? barcode,
    String? imagePath,
    Category? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
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
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to model
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'product_code': productCode,
      'product_name': productName,
      'category_id': categoryId,
      'sale_price': salePrice,
      'cost_price': costPrice,
      'min_quantity': minQuantity,
      'current_stock': currentStock,
      'unit': unitString,
      'is_active': isActive ? 1 : 0,
      if (barcode != null) 'barcode': barcode,
      if (imagePath != null) 'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get unit as string
  String get unitString {
    switch (unit) {
      case ProductUnit.piece:
        return 'piece';
      case ProductUnit.kg:
        return 'kg';
      case ProductUnit.gram:
        return 'gram';
      case ProductUnit.liter:
        return 'liter';
      case ProductUnit.ml:
        return 'ml';
      case ProductUnit.box:
        return 'box';
      case ProductUnit.pack:
        return 'pack';
      case ProductUnit.other:
        return 'other';
    }
  }

  // Helper method to get all available units
  static List<String> get units {
    return ProductUnit.values.map((e) {
      switch (e) {
        case ProductUnit.piece:
          return 'piece';
        case ProductUnit.kg:
          return 'kg';
        case ProductUnit.gram:
          return 'gram';
        case ProductUnit.liter:
          return 'liter';
        case ProductUnit.ml:
          return 'ml';
        case ProductUnit.box:
          return 'box';
        case ProductUnit.pack:
          return 'pack';
        case ProductUnit.other:
          return 'other';
      }
    }).toList();
  }

  // Convert from string to ProductUnit
  static ProductUnit unitFromString(String value) {
    switch (value) {
      case 'kg':
        return ProductUnit.kg;
      case 'gram':
        return ProductUnit.gram;
      case 'liter':
        return ProductUnit.liter;
      case 'ml':
        return ProductUnit.ml;
      case 'box':
        return ProductUnit.box;
      case 'pack':
        return ProductUnit.pack;
      case 'other':
        return ProductUnit.other;
      case 'piece':
      default:
        return ProductUnit.piece;
    }
  }
}
