import 'package:sqflite/sqlite_api.dart';

abstract class BaseRepository<T> {
  final Database db;
  
  BaseRepository(this.db);
  
  /// Converts a Map to the model
  T fromMap(Map<String, dynamic> map);
  
  /// Converts the model to a Map
  Map<String, dynamic> toMap(T model);
  
  /// Table name in the database
  String get tableName;
  
  /// Primary key column name
  String get primaryKey => 'id';
  
  /// Creates a new record
  Future<int> create(T model) async {
    final map = toMap(model);
    map.remove(primaryKey); // Remove ID to let SQLite auto-generate it
    
    final id = await db.insert(
      tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return id;
  }
  
  /// Updates an existing record
  Future<int> update(T model) async {
    final map = toMap(model);
    final id = map[primaryKey];
    
    if (id == null) {
      throw Exception('Cannot update a model without an ID');
    }
    
    final count = await db.update(
      tableName,
      map,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
    
    return count;
  }
  
  /// Deletes a record by ID
  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
  }
  
  /// Finds a record by ID
  Future<T?> findById(int id) async {
    final maps = await db.query(
      tableName,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return fromMap(maps.first);
  }
  
  /// Gets all records with optional pagination
  Future<List<T>> findAll({
    int? limit,
    int? offset,
    String? orderBy,
    bool orderDesc = false,
  }) async {
    final order = orderBy != null
        ? '$orderBy ${orderDesc ? 'DESC' : 'ASC'}'
        : null;
        
    final maps = await db.query(
      tableName,
      limit: limit,
      offset: offset,
      orderBy: order,
    );
    
    return maps.map((map) => fromMap(map)).toList();
  }
  
  /// Executes a custom query and returns the results
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    return await db.rawQuery(sql, arguments);
  }
  
  /// Executes a custom update/insert/delete query
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    return await db.rawUpdate(sql, arguments);
  }
}
