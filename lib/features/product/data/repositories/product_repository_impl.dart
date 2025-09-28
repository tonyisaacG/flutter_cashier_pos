import 'package:sqflite/sqlite_api.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Database _db;
  final String _tableName = 'products';

  ProductRepositoryImpl(Database db) : _db = db;

  // Helper method to convert ProductModel to Product entity
  Product _toEntity(ProductModel model) => model.toEntity();

  // Helper method to convert Product to ProductModel
  ProductModel _toModel(Product product) =>
      ProductModel.fromMap(product.toJson());

  // Helper method to convert Map to ProductModel
  ProductModel _fromMap(Map<String, dynamic> map) => ProductModel.fromMap(map);

  // Helper method to convert ProductModel to Map
  Map<String, dynamic> _toMap(ProductModel model) => model.toMap();

  @override
  Future<Product?> getById(int id) async {
    final maps = await _db.query(_tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return _toEntity(_fromMap(maps.first));
    }
    return null;
  }

  @override
  Future<Product?> findByBarcode(String barcode) async {
    final maps = await _db.query(
      _tableName,
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (maps.isNotEmpty) {
      return _toEntity(_fromMap(maps.first));
    }
    return null;
  }

  @override
  Future<Product?> findByCode(String code) async {
    final maps = await _db.query(
      _tableName,
      where: 'LOWER(code) = ?',
      whereArgs: [code.toLowerCase()],
    );

    if (maps.isNotEmpty) {
      return _toEntity(_fromMap(maps.first));
    }
    return null;
  }

  @override
  Future<int> create(Product product) async {
    final model = _toModel(product);
    final map = _toMap(model);
    map.remove('id'); // Let the database auto-generate the ID

    return await _db.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(Product product) async {
    if (product.id == null) {
      throw Exception('Cannot update a product without an ID');
    }

    final model = _toModel(product);
    final map = _toMap(model);

    return await _db.update(
      _tableName,
      map,
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<List<Product>> getAll({
    int? limit,
    int? offset,
    String? orderBy = 'name',
    bool orderDesc = false,
  }) async {
    final order = orderBy != null
        ? '$orderBy ${orderDesc ? 'DESC' : 'ASC'}'
        : null;

    final maps = await _db.query(
      _tableName,
      limit: limit,
      offset: offset,
      orderBy: order,
    );

    return maps.map((map) => _toEntity(_fromMap(map))).toList();
  }

  @override
  Future<int> updateStock(int productId, int quantityChange) async {
    return await _db.rawUpdate(
      '''
      UPDATE $_tableName 
      SET current_stock = current_stock + ?,
          updated_at = ?
      WHERE id = ?
    ''',
      [quantityChange, DateTime.now().toIso8601String(), productId],
    );
  }

  @override
  Future<List<Product>> getLowStockProducts() async {
    const threshold = 5; // Default threshold
    final maps = await _db.query(
      _tableName,
      where: 'current_stock <= ? AND is_active = 1',
      whereArgs: [threshold],
      orderBy: 'current_stock ASC',
    );

    return maps.map((map) => _toEntity(_fromMap(map))).toList();
  }

  @override
  Future<List<Product>> getByCategory(int categoryId) async {
    final maps = await _db.query(
      _tableName,
      where: 'category_id = ? AND is_active = 1',
      whereArgs: [categoryId],
      orderBy: 'name ASC',
    );

    return maps.map((map) => _toEntity(_fromMap(map))).toList();
  }

  @override
  Future<List<Product>> search(String query) async {
    if (query.isEmpty) return const [];

    final maps = await _db.query(
      _tableName,
      where: '(name LIKE ? OR code LIKE ? OR barcode LIKE ?) AND is_active = 1',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name',
    );

    return maps.map((map) => _toEntity(_fromMap(map))).toList();
  }

  @override
  Future<int> delete(int id) async {
    return await _db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
