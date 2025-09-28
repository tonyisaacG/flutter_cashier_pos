import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';
import 'package:cashier_pos/features/category/domain/repositories/category_repository.dart';

class GetCategory {
  final CategoryRepository repository;

  const GetCategory(this.repository);

  Future<Category> call(String id) async {
    try {
      final category = await repository.getById(id);
      if (category == null) {
        throw const NotFoundFailure('Category not found');
      }
      return category;
    } catch (e) {
      if (e is! Failure) {
        throw DatabaseFailure('Failed to load category: $e');
      }
      rethrow;
    }
  }
}
