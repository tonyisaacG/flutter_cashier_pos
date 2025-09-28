import 'package:cashier_pos/features/category/domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
  Future<String> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}
