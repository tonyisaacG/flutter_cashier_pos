import 'package:cashier_pos/features/product/data/models/product_model.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';

// Extension to convert ProductModel to Product entity
extension ProductModelX on ProductModel {
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
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Extension to convert Product entity to ProductModel
extension ProductX on Product {
  ProductModel toModel() {
    return ProductModel(
      id: id,
      productCode: productCode,
      productName: productName,
      categoryId: categoryId,
      salePrice: salePrice,
      costPrice: costPrice,
      minQuantity: minQuantity,
      currentStock: currentStock,
      unit: unitString,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
