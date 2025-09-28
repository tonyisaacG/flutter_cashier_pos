import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cashier_pos/core/error/exceptions.dart';
import 'package:cashier_pos/features/sales/data/models/sale_invoice_model.dart';
import 'package:cashier_pos/features/sales/data/models/sale_item_model.dart';
import 'package:cashier_pos/features/sales/data/models/payment_model.dart';

abstract class SaleLocalDataSource {
  Future<SaleInvoiceModel> createInvoice(SaleInvoiceModel invoice);
  Future<SaleInvoiceModel> createSaleInvoice(
    SaleInvoiceModel invoice,
  ); // Alias for createInvoice
  Future<SaleInvoiceModel> createReturnInvoice(
    SaleInvoiceModel returnInvoice,
    String originalInvoiceId,
  );
  Future<SaleInvoiceModel> getInvoice(String id);
  Future<List<SaleInvoiceModel>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? customerId,
    String? status,
    String? type,
    int page = 1,
    int limit = 20,
  });
  Future<SaleInvoiceModel> addPayment(String invoiceId, PaymentModel payment);
  Future<SaleInvoiceModel> updateStatus(String invoiceId, String status);
  Future<SaleInvoiceModel> updateSaleInvoice(SaleInvoiceModel invoice);
  Future<void> deleteInvoice(String id);
  Future<void> deletePayment(String paymentId);
  Future<PaymentModel?> getPayment(String paymentId);
  Future<List<Map<String, dynamic>>> searchProducts(String query);
  Future<Map<String, dynamic>> getProductByBarcode(String barcode);
  Future<String> generateInvoiceNumber();
}

class SaleLocalDataSourceImpl implements SaleLocalDataSource {
  static const String _databaseName = 'cashier_pos.db';
  static const int _databaseVersion = 1;

  static const String tableInvoices = 'invoices';
  static const String tableInvoiceItems = 'invoice_items';
  static const String tablePayments = 'payments';
  static const String tableProducts = 'products';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableInvoices (
        id TEXT PRIMARY KEY,
        invoice_number TEXT NOT NULL,
        invoice_date TEXT NOT NULL,
        customer_id TEXT,
        customer_name TEXT,
        customer_phone TEXT,
        subtotal REAL NOT NULL,
        discount REAL NOT NULL DEFAULT 0,
        tax REAL NOT NULL DEFAULT 0,
        total REAL NOT NULL,
        paid_amount REAL NOT NULL DEFAULT 0,
        due_amount REAL NOT NULL DEFAULT 0,
        status TEXT NOT NULL,
        type TEXT NOT NULL,
        notes TEXT,
        created_by TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        return_ref_id TEXT,
        FOREIGN KEY (return_ref_id) REFERENCES $tableInvoices(id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableInvoiceItems (
        id TEXT PRIMARY KEY,
        invoice_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_code TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        discount REAL NOT NULL DEFAULT 0,
        tax REAL NOT NULL DEFAULT 0,
        unit TEXT,
        barcode TEXT,
        FOREIGN KEY (invoice_id) REFERENCES $tableInvoices(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePayments (
        id TEXT PRIMARY KEY,
        invoice_id TEXT NOT NULL,
        amount REAL NOT NULL,
        method TEXT NOT NULL,
        transaction_id TEXT,
        notes TEXT,
        payment_date TEXT NOT NULL,
        received_by TEXT,
        FOREIGN KEY (invoice_id) REFERENCES $tableInvoices(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX idx_invoice_date ON $tableInvoices(invoice_date)
    ''');
    await db.execute('''
      CREATE INDEX idx_invoice_customer ON $tableInvoices(customer_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_invoice_status ON $tableInvoices(status)
    ''');
    await db.execute('''
      CREATE INDEX idx_invoice_type ON $tableInvoices(type)
    ''');
    await db.execute('''
      CREATE INDEX idx_invoice_items_invoice ON $tableInvoiceItems(invoice_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_invoice_items_product ON $tableInvoiceItems(product_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_payments_invoice ON $tablePayments(invoice_id)
    ''');
  }

  @override
  Future<SaleInvoiceModel> createInvoice(SaleInvoiceModel invoice) async {
    final db = await database;
    await db.transaction((txn) async {
      // Insert invoice
      await txn.insert(
        tableInvoices,
        invoice.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert invoice items
      for (final item in invoice.items) {
        await txn.insert(
          tableInvoiceItems,
          (item as SaleItemModel).toJson()..['invoice_id'] = invoice.id,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Insert payments if any
      for (final payment in invoice.payments) {
        await txn.insert(
          tablePayments,
          (payment as PaymentModel).toJson()..['invoice_id'] = invoice.id,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });

    return invoice;
  }

  @override
  Future<SaleInvoiceModel> createReturnInvoice(
    SaleInvoiceModel returnInvoice,
    String originalInvoiceId,
  ) async {
    // First create the return invoice
    final createdInvoice = await createInvoice(returnInvoice);

    // Update the original invoice to reference this return
    final db = await database;
    await db.update(
      tableInvoices,
      {'return_ref_id': createdInvoice.id},
      where: 'id = ?',
      whereArgs: [originalInvoiceId],
    );

    return createdInvoice;
  }

  @override
  Future<SaleInvoiceModel> getInvoice(String id) async {
    final db = await database;

    // Get invoice
    final invoiceMaps = await db.query(
      tableInvoices,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (invoiceMaps.isEmpty) {
      throw CacheException('Invoice not found');
    }

    // Get invoice items
    final itemMaps = await db.query(
      tableInvoiceItems,
      where: 'invoice_id = ?',
      whereArgs: [id],
    );

    // Get payments
    final paymentMaps = await db.query(
      tablePayments,
      where: 'invoice_id = ?',
      whereArgs: [id],
    );

    // Convert to models
    final invoice = SaleInvoiceModel.fromJson(invoiceMaps.first);
    final items = itemMaps.map((map) => SaleItemModel.fromJson(map)).toList();
    final payments = paymentMaps
        .map((map) => PaymentModel.fromJson(map))
        .toList();

    return invoice.copyWith(items: items, payments: payments)
        as SaleInvoiceModel;
  }

  @override
  Future<List<SaleInvoiceModel>> listInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? customerId,
    String? status,
    String? type,
    int page = 1,
    int limit = 20,
  }) async {
    final db = await database;

    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (startDate != null) {
      where.add('invoice_date >= ?');
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      where.add('invoice_date <= ?');
      whereArgs.add(endDate.toIso8601String());
    }

    if (customerId != null) {
      where.add('customer_id = ?');
      whereArgs.add(customerId);
    }

    if (status != null) {
      where.add('status = ?');
      whereArgs.add(status);
    }

    if (type != null) {
      where.add('type = ?');
      whereArgs.add(type);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';
    final orderBy = 'ORDER BY invoice_date DESC';
    final limitClause = 'LIMIT $limit OFFSET ${(page - 1) * limit}';

    final result = await db.rawQuery('''
      SELECT * FROM $tableInvoices 
      $whereClause 
      $orderBy 
      $limitClause
    ''', whereArgs);

    // For each invoice, fetch its items and payments
    final invoices = <SaleInvoiceModel>[];

    for (final map in result) {
      final invoiceId = map['id'] as String;
      final items = await db.query(
        tableInvoiceItems,
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
      );

      final payments = await db.query(
        tablePayments,
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
      );

      final invoice = SaleInvoiceModel.fromJson(map);
      invoices.add(
        invoice.copyWith(
              items: items.map((e) => SaleItemModel.fromJson(e)).toList(),
              payments: payments.map((e) => PaymentModel.fromJson(e)).toList(),
            )
            as SaleInvoiceModel,
      );
    }

    return invoices;
  }

  @override
  Future<SaleInvoiceModel> addPayment(
    String invoiceId,
    PaymentModel payment,
  ) async {
    final db = await database;

    await db.insert(
      tablePayments,
      payment.toJson()..['invoice_id'] = invoiceId,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update the invoice's paid amount and due amount
    final payments = await db.query(
      tablePayments,
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
      columns: ['SUM(amount) as total_paid'],
    );

    final totalPaid = (payments.first['total_paid'] as num?)?.toDouble() ?? 0.0;

    // Get the invoice total
    final invoiceMaps = await db.query(
      tableInvoices,
      where: 'id = ?',
      whereArgs: [invoiceId],
    );

    if (invoiceMaps.isEmpty) {
      throw CacheException('Invoice not found');
    }

    final invoice = SaleInvoiceModel.fromJson(invoiceMaps.first);
    final dueAmount = invoice.total - totalPaid;
    final newStatus = dueAmount <= 0 ? 'paid' : 'partially_paid';

    // Update the invoice
    await db.update(
      tableInvoices,
      {
        'paid_amount': totalPaid,
        'due_amount': dueAmount,
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [invoiceId],
    );

    return getInvoice(invoiceId);
  }

  @override
  Future<SaleInvoiceModel> updateStatus(String invoiceId, String status) async {
    final db = await database;

    await db.update(
      tableInvoices,
      {'status': status, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [invoiceId],
    );

    return getInvoice(invoiceId);
  }

  @override
  Future<void> deleteInvoice(String id) async {
    final db = await database;

    await db.delete(tableInvoices, where: 'id = ?', whereArgs: [id]);

    // Note: The foreign key constraints will automatically delete related items and payments
  }

  @override
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final db = await database;

    return await db.query(
      tableProducts,
      where: 'name LIKE ? OR code LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      limit: 20,
    );
  }

  @override
  Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    final db = await database;

    final results = await db.query(
      tableProducts,
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (results.isEmpty) {
      throw CacheException('Product not found');
    }

    return results.first;
  }

  @override
  Future<SaleInvoiceModel> createSaleInvoice(SaleInvoiceModel invoice) async {
    return createInvoice(invoice);
  }

  @override
  Future<List<SaleInvoiceModel>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? customerId,
    String? status,
    String? type,
    int page = 1,
    int limit = 20,
  }) async {
    return listInvoices(
      startDate: startDate,
      endDate: endDate,
      customerId: customerId,
      status: status,
      type: type,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<SaleInvoiceModel> updateSaleInvoice(SaleInvoiceModel invoice) async {
    final db = await database;
    await db.transaction((txn) async {
      // Update invoice
      await txn.update(
        tableInvoices,
        invoice.toJson(),
        where: 'id = ?',
        whereArgs: [invoice.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Update invoice items - delete existing and insert new
      await txn.delete(
        tableInvoiceItems,
        where: 'invoice_id = ?',
        whereArgs: [invoice.id],
      );

      for (final item in invoice.items) {
        await txn.insert(
          tableInvoiceItems,
          (item as SaleItemModel).toJson()..['invoice_id'] = invoice.id,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Update payments - delete existing and insert new
      await txn.delete(
        tablePayments,
        where: 'invoice_id = ?',
        whereArgs: [invoice.id],
      );

      for (final payment in invoice.payments) {
        await txn.insert(
          tablePayments,
          (payment as PaymentModel).toJson()..['invoice_id'] = invoice.id,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });

    return getInvoice(invoice.id!);
  }

  @override
  Future<void> deletePayment(String paymentId) async {
    final db = await database;
    await db.delete(tablePayments, where: 'id = ?', whereArgs: [paymentId]);
  }

  @override
  Future<PaymentModel?> getPayment(String paymentId) async {
    final db = await database;
    final results = await db.query(
      tablePayments,
      where: 'id = ?',
      whereArgs: [paymentId],
    );

    if (results.isEmpty) {
      return null;
    }

    return PaymentModel.fromJson(results.first);
  }

  @override
  Future<String> generateInvoiceNumber() async {
    final now = DateTime.now();
    final prefix = 'INV';
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final random = (DateTime.now().millisecondsSinceEpoch % 10000)
        .toString()
        .padLeft(4, '0');

    return '$prefix$year$month$day$random';
  }
}
