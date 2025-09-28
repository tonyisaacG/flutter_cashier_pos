import 'package:sqflite/sqlite_api.dart';
import 'package:cashier_pos/core/data/repositories/base_repository.dart';
import '../models/inventory_movement_model.dart';

class InventoryRepository extends BaseRepository<InventoryMovementModel> {
  InventoryRepository(Database db) : super(db);

  @override
  String get tableName => 'inventory_movements';

  @override
  InventoryMovementModel fromMap(Map<String, dynamic> map) {
    return InventoryMovementModel.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(InventoryMovementModel model) {
    return model.toMap();
  }

  /// Records an inventory movement and updates the product stock
  /// Returns the movement ID if successful, -1 otherwise
  Future<int> recordMovement(InventoryMovementModel movement) async {
    int? movementId;
    
    await db.transaction((txn) async {
      // Insert the movement
      final map = toMap(movement);
      map.remove('id'); // Remove ID to let SQLite auto-generate it
      
      movementId = await txn.insert(
        tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      // Update the product stock
      final quantityChange = movement.quantity * 
          (movement.type == MovementType.purchase || 
           movement.type == MovementType.found ||
           movement.type == MovementType.return_ ? 1 : -1);
      
      await txn.rawUpdate('''
        UPDATE products 
        SET current_stock = current_stock + ?,
            updated_at = ?
        WHERE id = ?
      ''', [
        quantityChange, 
        DateTime.now().toIso8601String(),
        movement.productId,
      ]);
    });
    
    return movementId ?? -1;
  }

  /// Gets movement history for a specific product
  Future<List<InventoryMovementModel>> getProductHistory(
    int productId, {
    DateTime? startDate,
    DateTime? endDate,
    MovementType? type,
  }) async {
    var where = 'product_id = ?';
    final whereArgs = <dynamic>[productId];
    
    if (startDate != null) {
      where += ' AND movement_date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }
    
    if (endDate != null) {
      where += ' AND movement_date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }
    
    if (type != null) {
      where += ' AND type = ?';
      whereArgs.add(type.toString().split('.').last);
    }
    
    final maps = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'movement_date DESC',
    );
    
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Gets inventory summary (current stock value, low stock items, etc.)
  Future<Map<String, dynamic>> getInventorySummary() async {
    final result = <String, dynamic>{};
    
    // Get total products count
    final productCount = (await db.rawQuery('''
      SELECT COUNT(*) as count FROM products WHERE is_active = 1
    ''')).first['count'] as int;
    
    // Get low stock items count
    final lowStockCount = (await db.rawQuery('''
      SELECT COUNT(*) as count 
      FROM products 
      WHERE current_stock <= min_quantity 
        AND is_active = 1
    ''')).first['count'] as int;
    
    // Get total inventory value
    final inventoryValue = (await db.rawQuery('''
      SELECT SUM(current_stock * cost_price) as value 
      FROM products 
      WHERE is_active = 1
    ''')).first['value'] as double? ?? 0.0;
    
    result['totalProducts'] = productCount;
    result['lowStockItems'] = lowStockCount;
    result['totalValue'] = inventoryValue;
    
    return result;
  }

  /// Adjusts the stock level for a product
  /// This creates an adjustment movement and updates the product stock
  Future<int> adjustStock({
    required int productId,
    required int newQuantity,
    required String reason,
    String? reference,
  }) async {
    // Get current stock
    final currentStock = (await db.query(
      'products',
      columns: ['current_stock'],
      where: 'id = ?',
      whereArgs: [productId],
    )).first['current_stock'] as int;
    
    final quantityDifference = newQuantity - currentStock;
    
    if (quantityDifference == 0) {
      return 0; // No change needed
    }
    
    final movement = InventoryMovementModel(
      productId: productId,
      quantity: quantityDifference.abs(),
      type: quantityDifference > 0 ? MovementType.found : MovementType.damaged,
      reference: reference ?? 'Manual Adjustment',
      notes: 'Stock adjustment: $reason',
    );
    
    return await recordMovement(movement);
  }
}
