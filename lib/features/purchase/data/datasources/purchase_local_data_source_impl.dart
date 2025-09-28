import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_helper.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/entities/purchase_item.dart';
import '../../domain/entities/purchase_return.dart';
import '../../domain/entities/purchase_return_item.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/entities/payment.dart';
import 'purchase_local_data_source.dart';

class PurchaseLocalDataSourceImpl implements PurchaseLocalDataSource {
  final DatabaseHelper _databaseHelper;
  final Uuid _uuid = const Uuid();

  PurchaseLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<List<Purchase>> getAllPurchases({
    int? limit,
    int? offset,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    PurchaseStatus? status,
  }) async {
    final db = await _databaseHelper.database;

    String whereClause = '';
    List<String> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += 'WHERE (invoice_number LIKE ? OR supplier_name LIKE ?)';
      whereArgs.add('%$searchQuery%');
      whereArgs.add('%$searchQuery%');
    }

    if (startDate != null) {
      if (whereClause.isEmpty) whereClause += 'WHERE ';
      else whereClause += ' AND ';
      whereClause += 'invoice_date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isEmpty) whereClause += 'WHERE ';
      else whereClause += ' AND ';
      whereClause += 'invoice_date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    if (status != null) {
      if (whereClause.isEmpty) whereClause += 'WHERE ';
      else whereClause += ' AND ';
      whereClause += 'status = ?';
      whereArgs.add(status.name);
    }

    String orderBy = 'ORDER BY created_at DESC';
    String limitClause = '';
    if (limit != null) {
      limitClause = 'LIMIT $limit';
      if (offset != null) {
        limitClause += ' OFFSET $offset';
      }
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM purchase_invoices $whereClause $orderBy $limitClause',
      whereArgs,
    );

    return maps.map((map) => _mapToPurchase(map)).toList();
  }

  @override
  Future<Purchase?> getPurchaseById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'purchase_invoices',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToPurchase(maps.first);
  }

  @override
  Future<String> createPurchase(Purchase purchase, List<PurchaseItem> items) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    // Insert purchase invoice
    batch.insert('purchase_invoices', _purchaseToMap(purchase));

    // Insert purchase items
    for (final item in items) {
      batch.insert('purchase_items', _purchaseItemToMap(item));
    }

    await batch.commit();
    return purchase.id;
  }

  @override
  Future<void> updatePurchase(Purchase purchase) async {
    final db = await _databaseHelper.database;
    await db.update(
      'purchase_invoices',
      _purchaseToMap(purchase),
      where: 'id = ?',
      whereArgs: [purchase.id],
    );
  }

  @override
  Future<void> deletePurchase(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'purchase_invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<PurchaseItem>> getPurchaseItems(String purchaseId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'purchase_items',
      where: 'invoice_id = ?',
      whereArgs: [purchaseId],
    );

    return maps.map((map) => _mapToPurchaseItem(map)).toList();
  }

  @override
  Future<String> addPurchaseItem(PurchaseItem item) async {
    final db = await _databaseHelper.database;
    await db.insert('purchase_items', _purchaseItemToMap(item));
    return item.id;
  }

  @override
  Future<void> updatePurchaseItem(PurchaseItem item) async {
    final db = await _databaseHelper.database;
    await db.update(
      'purchase_items',
      _purchaseItemToMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> deletePurchaseItem(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'purchase_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Payment>> getPurchasePayments(String purchaseId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: 'invoice_id = ?',
      whereArgs: [purchaseId],
    );

    return maps.map((map) => _mapToPayment(map)).toList();
  }

  @override
  Future<String> addPurchasePayment(Payment payment) async {
    final db = await _databaseHelper.database;
    await db.insert('payments', _paymentToMap(payment));
    return payment.id;
  }

  @override
  Future<void> updatePurchasePayment(Payment payment) async {
    final db = await _databaseHelper.database;
    await db.update(
      'payments',
      _paymentToMap(payment),
      where: 'id = ?',
      whereArgs: [payment.id],
    );
  }

  @override
  Future<void> deletePurchasePayment(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'payments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Supplier>> getAllSuppliers({
    int? limit,
    int? offset,
    String? searchQuery,
  }) async {
    final db = await _databaseHelper.database;

    String whereClause = '';
    List<String> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += 'WHERE (name LIKE ? OR phone LIKE ?)';
      whereArgs.add('%$searchQuery%');
      whereArgs.add('%$searchQuery%');
    }

    String orderBy = 'ORDER BY name ASC';
    String limitClause = '';
    if (limit != null) {
      limitClause = 'LIMIT $limit';
      if (offset != null) {
        limitClause += ' OFFSET $offset';
      }
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM suppliers $whereClause $orderBy $limitClause',
      whereArgs,
    );

    return maps.map((map) => _mapToSupplier(map)).toList();
  }

  @override
  Future<Supplier?> getSupplierById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToSupplier(maps.first);
  }

  @override
  Future<String> createSupplier(Supplier supplier) async {
    final db = await _databaseHelper.database;
    await db.insert('suppliers', _supplierToMap(supplier));
    return supplier.id;
  }

  @override
  Future<void> updateSupplier(Supplier supplier) async {
    final db = await _databaseHelper.database;
    await db.update(
      'suppliers',
      _supplierToMap(supplier),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  @override
  Future<void> deleteSupplier(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<PurchaseReturn>> getAllPurchaseReturns({
    int? limit,
    int? offset,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _databaseHelper.database;

    String whereClause = '';
    List<String> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += 'WHERE (return_number LIKE ? OR supplier_name LIKE ?)';
      whereArgs.add('%$searchQuery%');
      whereArgs.add('%$searchQuery%');
    }

    if (startDate != null) {
      if (whereClause.isEmpty) whereClause += 'WHERE ';
      else whereClause += ' AND ';
      whereClause += 'return_date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isEmpty) whereClause += 'WHERE ';
      else whereClause += ' AND ';
      whereClause += 'return_date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    String orderBy = 'ORDER BY created_at DESC';
    String limitClause = '';
    if (limit != null) {
      limitClause = 'LIMIT $limit';
      if (offset != null) {
        limitClause += ' OFFSET $offset';
      }
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM purchase_returns $whereClause $orderBy $limitClause',
      whereArgs,
    );

    return maps.map((map) => _mapToPurchaseReturn(map)).toList();
  }

  @override
  Future<PurchaseReturn?> getPurchaseReturnById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'purchase_returns',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToPurchaseReturn(maps.first);
  }

  @override
  Future<String> createPurchaseReturn(
    PurchaseReturn purchaseReturn,
    List<PurchaseReturnItem> items,
  ) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    // Insert purchase return
    batch.insert('purchase_returns', _purchaseReturnToMap(purchaseReturn));

    // Insert purchase return items
    for (final item in items) {
      batch.insert('purchase_return_items', _purchaseReturnItemToMap(item));
    }

    await batch.commit();
    return purchaseReturn.id;
  }

  @override
  Future<void> updatePurchaseReturn(PurchaseReturn purchaseReturn) async {
    final db = await _databaseHelper.database;
    await db.update(
      'purchase_returns',
      _purchaseReturnToMap(purchaseReturn),
      where: 'id = ?',
      whereArgs: [purchaseReturn.id],
    );
  }

  @override
  Future<void> deletePurchaseReturn(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'purchase_returns',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<PurchaseReturnItem>> getPurchaseReturnItems(String returnId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'purchase_return_items',
      where: 'return_id = ?',
      whereArgs: [returnId],
    );

    return maps.map((map) => _mapToPurchaseReturnItem(map)).toList();
  }

  @override
  Future<String> addPurchaseReturnItem(PurchaseReturnItem item) async {
    final db = await _databaseHelper.database;
    await db.insert('purchase_return_items', _purchaseReturnItemToMap(item));
    return item.id;
  }

  @override
  Future<void> updatePurchaseReturnItem(PurchaseReturnItem item) async {
    final db = await _databaseHelper.database;
    await db.update(
      'purchase_return_items',
      _purchaseReturnItemToMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> deletePurchaseReturnItem(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'purchase_return_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Map<String, dynamic>> getPurchaseStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _databaseHelper.database;

    String whereClause = '';
    List<String> whereArgs = [];

    if (startDate != null) {
      whereClause += 'WHERE invoice_date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isEmpty) whereClause += 'WHERE ';
      else whereClause += ' AND ';
      whereClause += 'invoice_date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    // Total purchases
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count, SUM(total) as total FROM purchase_invoices $whereClause',
      whereArgs,
    );

    // Total paid amount
    final paidResult = await db.rawQuery(
      'SELECT SUM(paid_amount) as paid FROM purchase_invoices $whereClause',
      whereArgs,
    );

    // Total due amount
    final dueResult = await db.rawQuery(
      'SELECT SUM(due_amount) as due FROM purchase_invoices $whereClause',
      whereArgs,
    );

    return {
      'total_purchases': totalResult.first['count'] ?? 0,
      'total_amount': totalResult.first['total'] ?? 0.0,
      'total_paid': paidResult.first['paid'] ?? 0.0,
      'total_due': dueResult.first['due'] ?? 0.0,
    };
  }

  // Helper methods for mapping
  Purchase _mapToPurchase(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      invoiceNumber: map['invoice_number'],
      invoiceDate: DateTime.parse(map['invoice_date']),
      supplierId: map['supplier_id'],
      supplierName: map['supplier_name'],
      supplierPhone: map['supplier_phone'],
      subtotal: map['subtotal'],
      discount: map['discount'],
      tax: map['tax'],
      total: map['total'],
      paidAmount: map['paid_amount'],
      dueAmount: map['due_amount'],
      status: PurchaseStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PurchaseStatus.draft,
      ),
      type: PurchaseType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PurchaseType.cash,
      ),
      notes: map['notes'],
      createdBy: map['created_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      returnRefId: map['return_ref_id'],
    );
  }

  PurchaseItem _mapToPurchaseItem(Map<String, dynamic> map) {
    return PurchaseItem(
      id: map['id'],
      invoiceId: map['invoice_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      productCode: map['product_code'],
      costPrice: map['cost_price'],
      quantity: map['quantity'],
      discount: map['discount'],
      tax: map['tax'],
      unit: map['unit'],
      barcode: map['barcode'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Payment _mapToPayment(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      invoiceId: map['invoice_id'],
      amount: map['amount'],
      method: PaymentMethod.values.firstWhere(
        (e) => e.name == map['method'],
        orElse: () => PaymentMethod.cash,
      ),
      transactionId: map['transaction_id'],
      notes: map['notes'],
      paymentDate: DateTime.parse(map['payment_date']),
      receivedBy: map['received_by'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Supplier _mapToSupplier(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      taxNumber: map['tax_number'],
      isActive: map['is_active'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  PurchaseReturn _mapToPurchaseReturn(Map<String, dynamic> map) {
    return PurchaseReturn(
      id: map['id'],
      returnNumber: map['return_number'],
      returnDate: DateTime.parse(map['return_date']),
      purchaseInvoiceId: map['purchase_invoice_id'],
      supplierId: map['supplier_id'],
      supplierName: map['supplier_name'],
      totalAmount: map['total_amount'],
      reason: map['reason'],
      notes: map['notes'],
      createdBy: map['created_by'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  PurchaseReturnItem _mapToPurchaseReturnItem(Map<String, dynamic> map) {
    return PurchaseReturnItem(
      id: map['id'],
      returnId: map['return_id'],
      purchaseItemId: map['purchase_item_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      totalAmount: map['total_amount'],
      reason: map['reason'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> _purchaseToMap(Purchase purchase) {
    return {
      'id': purchase.id,
      'invoice_number': purchase.invoiceNumber,
      'invoice_date': purchase.invoiceDate.toIso8601String(),
      'supplier_id': purchase.supplierId,
      'supplier_name': purchase.supplierName,
      'supplier_phone': purchase.supplierPhone,
      'subtotal': purchase.subtotal,
      'discount': purchase.discount,
      'tax': purchase.tax,
      'total': purchase.total,
      'paid_amount': purchase.paidAmount,
      'due_amount': purchase.dueAmount,
      'status': purchase.status.name,
      'type': purchase.type.name,
      'notes': purchase.notes,
      'created_by': purchase.createdBy,
      'created_at': purchase.createdAt.toIso8601String(),
      'updated_at': purchase.updatedAt?.toIso8601String(),
      'return_ref_id': purchase.returnRefId,
    };
  }

  Map<String, dynamic> _purchaseItemToMap(PurchaseItem item) {
    return {
      'id': item.id,
      'invoice_id': item.invoiceId,
      'product_id': item.productId,
      'product_name': item.productName,
      'product_code': item.productCode,
      'cost_price': item.costPrice,
      'quantity': item.quantity,
      'discount': item.discount,
      'tax': item.tax,
      'unit': item.unit,
      'barcode': item.barcode,
      'created_at': item.createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _paymentToMap(Payment payment) {
    return {
      'id': payment.id,
      'invoice_id': payment.invoiceId,
      'amount': payment.amount,
      'method': payment.method.name,
      'transaction_id': payment.transactionId,
      'notes': payment.notes,
      'payment_date': payment.paymentDate.toIso8601String(),
      'received_by': payment.receivedBy,
      'created_at': payment.createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _supplierToMap(Supplier supplier) {
    return {
      'id': supplier.id,
      'name': supplier.name,
      'phone': supplier.phone,
      'email': supplier.email,
      'address': supplier.address,
      'tax_number': supplier.taxNumber,
      'is_active': supplier.isActive ? 1 : 0,
      'created_at': supplier.createdAt.toIso8601String(),
      'updated_at': supplier.updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> _purchaseReturnToMap(PurchaseReturn purchaseReturn) {
    return {
      'id': purchaseReturn.id,
      'return_number': purchaseReturn.returnNumber,
      'return_date': purchaseReturn.returnDate.toIso8601String(),
      'purchase_invoice_id': purchaseReturn.purchaseInvoiceId,
      'supplier_id': purchaseReturn.supplierId,
      'supplier_name': purchaseReturn.supplierName,
      'total_amount': purchaseReturn.totalAmount,
      'reason': purchaseReturn.reason,
      'notes': purchaseReturn.notes,
      'created_by': purchaseReturn.createdBy,
      'created_at': purchaseReturn.createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _purchaseReturnItemToMap(PurchaseReturnItem item) {
    return {
      'id': item.id,
      'return_id': item.returnId,
      'purchase_item_id': item.purchaseItemId,
      'product_id': item.productId,
      'product_name': item.productName,
      'quantity': item.quantity,
      'unit_price': item.unitPrice,
      'total_amount': item.totalAmount,
      'reason': item.reason,
      'created_at': item.createdAt.toIso8601String(),
    };
  }
}
