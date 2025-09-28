import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';
import 'package:cashier_pos/features/category/domain/repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  const UpdateCategory(this.repository);

  Future<Category> call(Category category) async {
    if (category.id == null) {
      throw const ValidationFailure('Cannot update category without an ID');
    }

    // Validate category name
    if (category.name.isEmpty) {
      throw const ValidationFailure('Category name cannot be empty');
    }

    // Check if another category with the same name already exists
    final exists = await repository.exists(
      category.name,
      excludeId: category.id,
    );
    if (exists) {
      throw const ValidationFailure(
        'Another category with this name already exists',
      );
    }

    try {
      await repository.update(category);
      return category;
    } catch (e) {
      throw DatabaseFailure('Failed to update category: $e');
    }
  }
}
