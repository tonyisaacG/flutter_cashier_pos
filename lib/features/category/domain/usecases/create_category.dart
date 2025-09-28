import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';
import 'package:cashier_pos/features/category/domain/repositories/category_repository.dart';

class CreateCategory {
  final CategoryRepository repository;

  const CreateCategory(this.repository);

  Future<Category> call(Category category) async {
    // Validate category name
    if (category.name.isEmpty) {
      throw const ValidationFailure('Category name cannot be empty');
    }

    // Check if category with same name already exists
    final exists = await repository.exists(category.name);
    if (exists) {
      throw const ValidationFailure('A category with this name already exists');
    }

    try {
      final categoryId = await repository.create(category);
      return category.copyWith(id: categoryId.toString());
    } catch (e) {
      throw DatabaseFailure('Failed to create category: $e');
    }
  }
}
