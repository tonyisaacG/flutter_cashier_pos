import 'package:cashier_pos/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  /// Creates a new product
  Future<int> create(Product product);
  
  /// Updates an existing product
  Future<int> update(Product product);
  
  /// Deletes a product by ID
  /// Returns the number of rows affected
  Future<int> delete(int id);
  
  /// Gets a product by ID
  Future<Product?> getById(int id);
  
  /// Gets all products with optional pagination
  Future<List<Product>> getAll({
    int? limit,
    int? offset,
    String? orderBy,
    bool orderDesc = false,
  });
  
  /// Finds a product by barcode
  Future<Product?> findByBarcode(String barcode);
  
  /// Finds a product by code (case-insensitive)
  Future<Product?> findByCode(String code);
  
  /// Searches products by name or barcode
  Future<List<Product>> search(String query);
  
  /// Gets low stock products
  Future<List<Product>> getLowStockProducts();
  
  /// Updates the stock quantity of a product
  Future<int> updateStock(int productId, int quantityChange);
  
  /// Gets products by category
  Future<List<Product>> getByCategory(int categoryId);
}
