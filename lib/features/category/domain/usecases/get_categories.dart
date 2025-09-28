import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';
import 'package:cashier_pos/features/category/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  const GetCategories(this.repository);

  Future<List<Category>> call() async {
    try {
      return await repository.getAll();
    } catch (e) {
      throw DatabaseFailure('Failed to load categories: $e');
    }
  }
}
