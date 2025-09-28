import 'package:cashier_pos/features/inventory/data/models/inventory_movement_model.dart';

abstract class InventoryRepository {
  /// Records an inventory movement and updates the product stock
  /// Returns the movement ID if successful, -1 otherwise
  Future<int> recordMovement(InventoryMovementModel movement);
  
  /// Gets movement history for a specific product
  Future<List<InventoryMovementModel>> getProductHistory(
    int productId, {
    DateTime? startDate,
    DateTime? endDate,
    MovementType? type,
  });
  
  /// Gets inventory summary (current stock value, low stock items, etc.)
  Future<Map<String, dynamic>> getInventorySummary();
  
  /// Adjusts the stock level for a product
  /// This creates an adjustment movement and updates the product stock
  Future<int> adjustStock({
    required int productId,
    required int newQuantity,
    required String reason,
    String? reference,
  });
  
  /// Gets all inventory movements with optional filtering
  Future<List<InventoryMovementModel>> getMovements({
    int? productId,
    MovementType? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });
}
