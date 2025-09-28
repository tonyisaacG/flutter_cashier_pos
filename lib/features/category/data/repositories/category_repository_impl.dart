import 'package:sqflite/sqlite_api.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';
import 'package:cashier_pos/features/category/domain/repositories/category_repository.dart';
import '../models/category_model.dart';
import '../mappers/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Database db;
  
  CategoryRepositoryImpl(this.db);

  @override
  Future<String> create(Category category) async {
    try {
      final model = category.toModel();
      final id = await db.insert(
        'categories',
        model.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id.toString();
    } catch (e) {
      throw DatabaseFailure('Failed to create category: $e');
    }
  }

  @override
  Future<void> update(Category category) async {
    if (category.id == null) {
      throw ValidationFailure('Cannot update category without an ID');
    }

    try {
      final model = category.toModel();
      await db.update(
        'categories',
        model.toMap()..remove('id'),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } catch (e) {
      throw DatabaseFailure('Failed to update category: $e');
    }
  }

  @override
  Future<int> delete(String id) async {
    try {
      return await db.delete(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseFailure('Failed to delete category: $e');
    }
  }

  @override
  Future<Category?> getById(String id) async {
    try {
      final maps = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return CategoryModel.fromMap(maps.first).toEntity();
    } catch (e) {
      throw DatabaseFailure('Failed to get category: $e');
    }
  }

  @override
  Future<List<Category>> getAll() async {
    try {
      final maps = await db.query('categories');
      return maps
          .map((map) => CategoryModel.fromMap(map).toEntity())
          .toList();
    } catch (e) {
      throw DatabaseFailure('Failed to get categories: $e');
    }
  }

  @override
  Future<Category?> findByName(String name) async {
    try {
      final maps = await db.query(
        'categories',
        where: 'LOWER(name) = ?',
        whereArgs: [name.toLowerCase()],
      );
      
      if (maps.isEmpty) return null;
      return CategoryModel.fromMap(maps.first).toEntity();
    } catch (e) {
      throw DatabaseFailure('Failed to find category by name: $e');
    }
  }

  @override
  Future<bool> exists(String name, {String? excludeId}) async {
    try {
      final maps = await db.query(
        'categories',
        where: 'LOWER(name) = ? AND id != ?',
        whereArgs: [name.toLowerCase(), excludeId ?? ''],
      );

      return maps.isNotEmpty;
    } catch (e) {
      throw DatabaseFailure('Failed to check if category exists: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoriesWithProductCount() async {
    try {
      final sql = '''
        SELECT 
          c.*, 
          COUNT(p.id) as product_count
        FROM categories c
        LEFT JOIN products p ON p.category_id = c.id
        GROUP BY c.id
        ORDER BY c.name
      ''';
      
      return await db.rawQuery(sql);
    } catch (e) {
      throw DatabaseFailure('Failed to get categories with product count: $e');
    }
  }
}
