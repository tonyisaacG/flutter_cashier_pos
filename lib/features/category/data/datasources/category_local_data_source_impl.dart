import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:cashier_pos/core/database/database_helper.dart';
import 'package:cashier_pos/features/category/data/datasources/category_local_data_source.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  CategoryLocalDataSourceImpl({required this.databaseHelper});

  static const String tableName = 'categories';

  @override
  Future<List<Category>> getAllCategories() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'] as String,
        name: maps[i]['name'] as String,
        description: maps[i]['description'] as String?,
        parentId: maps[i]['parent_id'] as String?,
        imageUrl: maps[i]['image_url'] as String?,
        isActive: maps[i]['is_active'] == 1,
        createdAt: DateTime.parse(maps[i]['created_at'] as String),
        updatedAt: maps[i]['updated_at'] != null
            ? DateTime.parse(maps[i]['updated_at'] as String)
            : null,
      );
    });
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Category(
      id: maps[0]['id'] as String,
      name: maps[0]['name'] as String,
      description: maps[0]['description'] as String?,
      parentId: maps[0]['parent_id'] as String?,
      imageUrl: maps[0]['image_url'] as String?,
      isActive: maps[0]['is_active'] == 1,
      createdAt: DateTime.parse(maps[0]['created_at'] as String),
      updatedAt: maps[0]['updated_at'] != null
          ? DateTime.parse(maps[0]['updated_at'] as String)
          : null,
    );
  }

  @override
  Future<String> createCategory(Category category) async {
    final db = await databaseHelper.database;
    final now = DateTime.now().toIso8601String();

    final categoryMap = {
      'id': category.id,
      'name': category.name,
      'description': category.description,
      'parent_id': category.parentId,
      'image_url': category.imageUrl,
      'is_active': category.isActive ? 1 : 0,
      'created_at': now,
      'updated_at': now,
    };

    await db.insert(tableName, categoryMap);
    return category.id ?? '';
  }

  @override
  Future<void> updateCategory(Category category) async {
    final db = await databaseHelper.database;
    final now = DateTime.now().toIso8601String();

    final categoryMap = {
      'name': category.name,
      'description': category.description,
      'parent_id': category.parentId,
      'image_url': category.imageUrl,
      'is_active': category.isActive ? 1 : 0,
      'updated_at': now,
    };

    await db.update(
      tableName,
      categoryMap,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
    final db = await databaseHelper.database;
    await db.update(
      tableName,
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
