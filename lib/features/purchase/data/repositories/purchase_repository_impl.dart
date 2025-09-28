import 'package:uuid/uuid.dart';

import '../../domain/entities/purchase.dart';
import '../../domain/entities/purchase_item.dart';
import '../../domain/entities/purchase_return.dart';
import '../../domain/entities/purchase_return_item.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_local_data_source.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseLocalDataSource _localDataSource;
  final Uuid _uuid = const Uuid();

  PurchaseRepositoryImpl(this._localDataSource);

  @override
  Future<List<Purchase>> getAllPurchases({
    int? limit,
    int? offset,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    PurchaseStatus? status,
  }) async {
    return await _localDataSource.getAllPurchases(
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }

  @override
  Future<Purchase?> getPurchaseById(String id) async {
    return await _localDataSource.getPurchaseById(id);
  }

  @override
  Future<Purchase> createPurchase(Purchase purchase, List<PurchaseItem> items) async {
    // Generate ID if not provided
    final purchaseWithId = purchase.id.isEmpty
        ? purchase.copyWith(id: _uuid.v4())
        : purchase;

    // Generate IDs for items if not provided
    final itemsWithIds = items.map((item) {
      return item.id.isEmpty ? item.copyWith(id: _uuid.v4()) : item;
    }).toList();

    await _localDataSource.createPurchase(purchaseWithId, itemsWithIds);

    // Update product quantities
    await _updateProductQuantities(itemsWithIds, true);

    return purchaseWithId;
  }

  @override
  Future<Purchase> updatePurchase(Purchase purchase) async {
    await _localDataSource.updatePurchase(purchase);
    return purchase;
  }

  @override
  Future<void> deletePurchase(String id) async {
    await _localDataSource.deletePurchase(id);
  }

  @override
  Future<List<PurchaseItem>> getPurchaseItems(String purchaseId) async {
    return await _localDataSource.getPurchaseItems(purchaseId);
  }

  @override
  Future<PurchaseItem> addPurchaseItem(PurchaseItem item) async {
    final itemWithId = item.id.isEmpty ? item.copyWith(id: _uuid.v4()) : item;
    await _localDataSource.addPurchaseItem(itemWithId);

    // Update product quantity
    await _updateProductQuantity(itemWithId, true);

    return itemWithId;
  }

  @override
  Future<PurchaseItem> updatePurchaseItem(PurchaseItem item) async {
    await _localDataSource.updatePurchaseItem(item);
    return item;
  }

  @override
  Future<void> deletePurchaseItem(String id) async {
    await _localDataSource.deletePurchaseItem(id);
  }

  @override
  Future<List<Payment>> getPurchasePayments(String purchaseId) async {
    return await _localDataSource.getPurchasePayments(purchaseId);
  }

  @override
  Future<Payment> addPurchasePayment(Payment payment) async {
    final paymentWithId = payment.id.isEmpty ? payment.copyWith(id: _uuid.v4()) : payment;
    await _localDataSource.addPurchasePayment(paymentWithId);

    // Update purchase paid amount
    await _updatePurchasePaidAmount(paymentWithId.invoiceId);

    return paymentWithId;
  }

  @override
  Future<Payment> updatePurchasePayment(Payment payment) async {
    await _localDataSource.updatePurchasePayment(payment);

    // Update purchase paid amount
    await _updatePurchasePaidAmount(payment.invoiceId);

    return payment;
  }

  @override
  Future<void> deletePurchasePayment(String id) async {
    await _localDataSource.deletePurchasePayment(id);
  }

  @override
  Future<List<Supplier>> getAllSuppliers({
    int? limit,
    int? offset,
    String? searchQuery,
  }) async {
    return await _localDataSource.getAllSuppliers(
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<Supplier?> getSupplierById(String id) async {
    return await _localDataSource.getSupplierById(id);
  }

  @override
  Future<Supplier> createSupplier(Supplier supplier) async {
    final supplierWithId = supplier.id.isEmpty
        ? supplier.copyWith(id: _uuid.v4())
        : supplier;
    await _localDataSource.createSupplier(supplierWithId);
    return supplierWithId;
  }

  @override
  Future<Supplier> updateSupplier(Supplier supplier) async {
    await _localDataSource.updateSupplier(supplier);
    return supplier;
  }

  @override
  Future<void> deleteSupplier(String id) async {
    await _localDataSource.deleteSupplier(id);
  }

  @override
  Future<List<PurchaseReturn>> getAllPurchaseReturns({
    int? limit,
    int? offset,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _localDataSource.getAllPurchaseReturns(
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<PurchaseReturn?> getPurchaseReturnById(String id) async {
    return await _localDataSource.getPurchaseReturnById(id);
  }

  @override
  Future<PurchaseReturn> createPurchaseReturn(
    PurchaseReturn purchaseReturn,
    List<PurchaseReturnItem> items,
  ) async {
    final returnWithId = purchaseReturn.id.isEmpty
        ? purchaseReturn.copyWith(id: _uuid.v4())
        : purchaseReturn;

    final itemsWithIds = items.map((item) {
      return item.id.isEmpty ? item.copyWith(id: _uuid.v4()) : item;
    }).toList();

    await _localDataSource.createPurchaseReturn(returnWithId, itemsWithIds);

    // Update product quantities (decrement for returns)
    await _updateProductQuantitiesForReturn(itemsWithIds);

    return returnWithId;
  }

  @override
  Future<PurchaseReturn> updatePurchaseReturn(PurchaseReturn purchaseReturn) async {
    await _localDataSource.updatePurchaseReturn(purchaseReturn);
    return purchaseReturn;
  }

  @override
  Future<void> deletePurchaseReturn(String id) async {
    await _localDataSource.deletePurchaseReturn(id);
  }

  @override
  Future<List<PurchaseReturnItem>> getPurchaseReturnItems(String returnId) async {
    return await _localDataSource.getPurchaseReturnItems(returnId);
  }

  @override
  Future<PurchaseReturnItem> addPurchaseReturnItem(PurchaseReturnItem item) async {
    final itemWithId = item.id.isEmpty ? item.copyWith(id: _uuid.v4()) : item;
    await _localDataSource.addPurchaseReturnItem(itemWithId);

    // Update product quantity (decrement for returns)
    await _updateProductQuantityForReturn(itemWithId);

    return itemWithId;
  }

  @override
  Future<PurchaseReturnItem> updatePurchaseReturnItem(PurchaseReturnItem item) async {
    await _localDataSource.updatePurchaseReturnItem(item);
    return item;
  }

  @override
  Future<void> deletePurchaseReturnItem(String id) async {
    await _localDataSource.deletePurchaseReturnItem(id);
  }

  @override
  Future<Map<String, dynamic>> getPurchaseStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _localDataSource.getPurchaseStatistics(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Helper methods for inventory management
  Future<void> _updateProductQuantities(List<PurchaseItem> items, bool isPurchase) async {
    // This would need access to product repository to update quantities
    // For now, we'll add inventory movements
    for (final item in items) {
      await _addInventoryMovement(
        item.productId,
        isPurchase ? item.quantity : -item.quantity,
        isPurchase ? 'purchase' : 'purchase_return',
        item.invoiceId,
      );
    }
  }

  Future<void> _updateProductQuantity(PurchaseItem item, bool isPurchase) async {
    await _addInventoryMovement(
      item.productId,
      isPurchase ? item.quantity : -item.quantity,
      isPurchase ? 'purchase' : 'purchase_return',
      item.invoiceId,
    );
  }

  Future<void> _updateProductQuantitiesForReturn(List<PurchaseReturnItem> items) async {
    for (final item in items) {
      await _addInventoryMovement(
        item.productId,
        -item.quantity, // Negative for returns
        'purchase_return',
        item.returnId,
      );
    }
  }

  Future<void> _updateProductQuantityForReturn(PurchaseReturnItem item) async {
    await _addInventoryMovement(
      item.productId,
      -item.quantity, // Negative for returns
      'purchase_return',
      item.returnId,
    );
  }

  Future<void> _updatePurchasePaidAmount(String purchaseId) async {
    // Get all payments for this purchase
    final payments = await _localDataSource.getPurchasePayments(purchaseId);
    final totalPaid = payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);

    // Get the purchase and update paid amount
    final purchase = await _localDataSource.getPurchaseById(purchaseId);
    if (purchase != null) {
      final updatedPurchase = purchase.copyWith(
        paidAmount: totalPaid,
        dueAmount: purchase.total - totalPaid,
      );
      await _localDataSource.updatePurchase(updatedPurchase);
    }
  }

  Future<void> _addInventoryMovement(
    String productId,
    int quantity,
    String movementType,
    String referenceId,
  ) async {
    // This would need access to inventory repository
    // For now, we'll just add a placeholder comment
    // In a real implementation, this would call the inventory repository
    // to add a movement record
  }
}
