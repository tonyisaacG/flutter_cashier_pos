import '../../domain/entities/purchase.dart';
import '../../domain/entities/purchase_item.dart';
import '../../domain/entities/purchase_return.dart';
import '../../domain/entities/purchase_return_item.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/entities/payment.dart';

abstract class PurchaseLocalDataSource {
  // Purchase operations
  Future<List<Purchase>> getAllPurchases({
    int? limit,
    int? offset,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    PurchaseStatus? status,
  });

  Future<Purchase?> getPurchaseById(String id);

  Future<String> createPurchase(Purchase purchase, List<PurchaseItem> items);

  Future<void> updatePurchase(Purchase purchase);

  Future<void> deletePurchase(String id);

  // Purchase item operations
  Future<List<PurchaseItem>> getPurchaseItems(String purchaseId);

  Future<String> addPurchaseItem(PurchaseItem item);

  Future<void> updatePurchaseItem(PurchaseItem item);

  Future<void> deletePurchaseItem(String id);

  // Payment operations
  Future<List<Payment>> getPurchasePayments(String purchaseId);

  Future<String> addPurchasePayment(Payment payment);

  Future<void> updatePurchasePayment(Payment payment);

  Future<void> deletePurchasePayment(String id);

  // Supplier operations
  Future<List<Supplier>> getAllSuppliers({
    int? limit,
    int? offset,
    String? searchQuery,
  });

  Future<Supplier?> getSupplierById(String id);

  Future<String> createSupplier(Supplier supplier);

  Future<void> updateSupplier(Supplier supplier);

  Future<void> deleteSupplier(String id);

  // Purchase return operations
  Future<List<PurchaseReturn>> getAllPurchaseReturns({
    int? limit,
    int? offset,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<PurchaseReturn?> getPurchaseReturnById(String id);

  Future<String> createPurchaseReturn(
    PurchaseReturn purchaseReturn,
    List<PurchaseReturnItem> items,
  );

  Future<void> updatePurchaseReturn(PurchaseReturn purchaseReturn);

  Future<void> deletePurchaseReturn(String id);

  // Purchase return item operations
  Future<List<PurchaseReturnItem>> getPurchaseReturnItems(String returnId);

  Future<String> addPurchaseReturnItem(PurchaseReturnItem item);

  Future<void> updatePurchaseReturnItem(PurchaseReturnItem item);

  Future<void> deletePurchaseReturnItem(String id);

  // Statistics
  Future<Map<String, dynamic>> getPurchaseStatistics({
    DateTime? startDate,
    DateTime? endDate,
  });
}
