import '../entities/payment.dart';
import '../entities/purchase.dart';
import '../entities/purchase_item.dart';
import '../entities/purchase_return.dart';
import '../entities/purchase_return_item.dart';
import '../entities/supplier.dart';

abstract class PurchaseRepository {
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

  Future<Purchase> createPurchase(Purchase purchase, List<PurchaseItem> items);

  Future<Purchase> updatePurchase(Purchase purchase);

  Future<void> deletePurchase(String id);

  // Purchase item operations
  Future<List<PurchaseItem>> getPurchaseItems(String purchaseId);

  Future<PurchaseItem> addPurchaseItem(PurchaseItem item);

  Future<PurchaseItem> updatePurchaseItem(PurchaseItem item);

  Future<void> deletePurchaseItem(String id);

  // Payment operations
  Future<List<Payment>> getPurchasePayments(String purchaseId);

  Future<Payment> addPurchasePayment(Payment payment);

  Future<Payment> updatePurchasePayment(Payment payment);

  Future<void> deletePurchasePayment(String id);

  // Supplier operations
  Future<List<Supplier>> getAllSuppliers({
    int? limit,
    int? offset,
    String? searchQuery,
  });

  Future<Supplier?> getSupplierById(String id);

  Future<Supplier> createSupplier(Supplier supplier);

  Future<Supplier> updateSupplier(Supplier supplier);

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

  Future<PurchaseReturn> createPurchaseReturn(
    PurchaseReturn purchaseReturn,
    List<PurchaseReturnItem> items,
  );

  Future<PurchaseReturn> updatePurchaseReturn(PurchaseReturn purchaseReturn);

  Future<void> deletePurchaseReturn(String id);

  // Purchase return item operations
  Future<List<PurchaseReturnItem>> getPurchaseReturnItems(String returnId);

  Future<PurchaseReturnItem> addPurchaseReturnItem(PurchaseReturnItem item);

  Future<PurchaseReturnItem> updatePurchaseReturnItem(PurchaseReturnItem item);

  Future<void> deletePurchaseReturnItem(String id);

  // Statistics
  Future<Map<String, dynamic>> getPurchaseStatistics({
    DateTime? startDate,
    DateTime? endDate,
  });
}
