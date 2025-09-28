import 'package:cashier_pos/features/category/domain/entities/category.dart';

abstract class CategoryRepository {
  /// Creates a new category
  Future<String> create(Category category);

  /// Updates an existing category
  Future<void> update(Category category);

  /// Deletes a category by ID
  /// Returns the number of rows affected
  Future<int> delete(String id);

  /// Gets a category by ID
  Future<Category?> getById(String id);

  /// Gets all categories
  Future<List<Category>> getAll();

  /// Finds a category by name (case-insensitive)
  Future<Category?> findByName(String name);

  /// Checks if a category with the given name exists (case-insensitive)
  Future<bool> exists(String name, {String? excludeId});

  /// Gets categories with product count
  Future<List<Map<String, dynamic>>> getCategoriesWithProductCount();
}
