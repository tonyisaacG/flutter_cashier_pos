import 'package:cashier_pos/features/category/data/models/category_model.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';

extension CategoryModelX on CategoryModel {
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      parentId: parentId,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CategoryX on Category {
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      description: description,
      parentId: parentId,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
