import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/category/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  const DeleteCategory(this.repository);

  Future<void> call(String categoryId) async {
    try {
      // Check if category exists
      final category = await repository.getById(categoryId);
      if (category == null) {
        throw const NotFoundFailure('Category not found');
      }

      // Check if category is the default 'General' category
      if (category.name.toLowerCase() == 'general') {
        throw const ValidationFailure('Cannot delete the default General category');
      }

      // Check if category has associated products
      final categoriesWithCount = await repository.getCategoriesWithProductCount();
      final categoryData = categoriesWithCount.firstWhere(
        (c) => c['id'].toString() == categoryId,
        orElse: () => {'product_count': 0},
      );

      final productCount = categoryData['product_count'] as int;
      if (productCount > 0) {
        throw const ValidationFailure('Cannot delete a category with associated products');
      }

      // Delete the category
      final rowsAffected = await repository.delete(categoryId);
      if (rowsAffected == 0) {
        throw const DatabaseFailure('Failed to delete category');
      }
    } catch (e) {
      if (e is! Failure) {
        throw DatabaseFailure('Failed to delete category: $e');
      }
      rethrow;
    }
  }
}
