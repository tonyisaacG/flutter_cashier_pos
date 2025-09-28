import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:cashier_pos/core/error/exceptions.dart';
import 'package:cashier_pos/features/sales/data/models/sale_invoice_model.dart';
import 'package:cashier_pos/features/sales/data/models/sale_item_model.dart';
import 'package:cashier_pos/features/sales/data/models/payment_model.dart';
import 'package:cashier_pos/core/database/database_helper.dart';

abstract class SaleLocalDataSource {
  Future<String> createSaleInvoice(SaleInvoiceModel invoice);
  Future<void> updateSaleInvoice(SaleInvoiceModel invoice);
  Future<SaleInvoiceModel> getSaleInvoice(String id);
  Future<List<SaleInvoiceModel>> getSaleInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
  });
  Future<void> deleteSaleInvoice(String id);

  Future<void> addSaleItem(SaleItemModel item);
  Future<void> updateSaleItem(SaleItemModel item);
  Future<void> removeSaleItem(String id);
  Future<List<SaleItemModel>> getSaleItems(String invoiceId);

  Future<String> addPayment(PaymentModel payment);
  Future<void> updatePayment(PaymentModel payment);
  Future<void> deletePayment(String id);
  Future<List<PaymentModel>> getPayments(String invoiceId);

  Future<String> generateInvoiceNumber();
}

class SaleLocalDataSourceImpl implements SaleLocalDataSource {
  // Table names
  static const String tableInvoices = 'sale_invoices';
  static const String tableItems = 'sale_items';
  static const String tablePayments = 'payments';
  static const String tableProducts = 'products';

  @override
  Future<String> createSaleInvoice(SaleInvoiceModel invoice) async {
    final db = await DatabaseHelper.instance.database;

    return await db.transaction((txn) async {
      try {
        // Insert invoice
        await txn.insert(
          tableInvoices,
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Insert all items
        for (final item in invoice.items) {
          await txn.insert(
            tableItems,
            item.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        return invoice.id!;
      } catch (e) {
        throw const CacheException('Failed to create the sale invoice');
      }
    });
  }

  @override
  Future<void> updateSaleInvoice(SaleInvoiceModel invoice) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      try {
        // Update invoice
        await txn.update(
          tableInvoices,
          invoice.toJson(),
          where: 'id = ?',
          whereArgs: [invoice.id],
        );

        // Delete existing items and payments
        await txn.delete(
          tableItems,
          where: 'invoice_id = ?',
          whereArgs: [invoice.id],
        );
        await txn.delete(
          tablePayments,
          where: 'invoice_id = ?',
          whereArgs: [invoice.id],
        );

        // Re-insert items
        for (final item in invoice.items) {
          await txn.insert(
            tableItems,
            item.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Re-insert payments
        for (final payment in invoice.payments) {
          await txn.insert(
            tablePayments,
            payment.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } catch (e) {
        throw const CacheException('Failed to update the sale invoice');
      }
    });
  }

  @override
  Future<SaleInvoiceModel> getSaleInvoice(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;

      // Get invoice
      final invoiceMaps = await db.query(
        tableInvoices,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (invoiceMaps.isEmpty) {
        throw const CacheException('Sale invoice not found');
      }

      // Get items
      final itemMaps = await db.query(
        tableItems,
        where: 'invoice_id = ?',
        whereArgs: [id],
      );

      // Get payments
      final paymentMaps = await db.query(
        tablePayments,
        where: 'invoice_id = ?',
        whereArgs: [id],
        orderBy: 'payment_date DESC, created_at DESC',
      );

      // Build models
      final invoice = SaleInvoiceModel.fromJson(
        Map<String, dynamic>.from(invoiceMaps.first),
      );
      final items = itemMaps
          .map((e) => SaleItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      final payments = paymentMaps
          .map((e) => PaymentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return invoice.copyWith(items: items, payments: payments);
    } catch (e) {
      throw const CacheException('Failed to fetch the sale invoice');
    }
  }

  @override
  Future<List<SaleInvoiceModel>> getSaleInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
  }) async {
    try {
      final db = await DatabaseHelper.instance.database;

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

      if (status != null) {
        where.add('status = ?');
        whereArgs.add(status);
      }

      if (type != null) {
        where.add('type = ?');
        whereArgs.add(type);
      }

      final whereClause = where.isNotEmpty
          ? 'WHERE ${where.join(' AND ')}'
          : '';

      final result = await db.rawQuery('''
        SELECT * FROM $tableInvoices 
        $whereClause 
        ORDER BY invoice_date DESC, created_at DESC
      ''', whereArgs);

      final invoices = <SaleInvoiceModel>[];

      for (final invoiceMap in result) {
        final invoiceId = invoiceMap['id'] as String;

        // Get items for invoice
        final itemMaps = await db.query(
          tableItems,
          where: 'invoice_id = ?',
          whereArgs: [invoiceId],
          orderBy: 'created_at ASC',
        );

        // Get payments for invoice
        final paymentMaps = await db.query(
          tablePayments,
          where: 'invoice_id = ?',
          whereArgs: [invoiceId],
          orderBy: 'payment_date DESC, created_at DESC',
        );

        // Convert to models
        final invoice = SaleInvoiceModel.fromJson(
          Map<String, dynamic>.from(invoiceMap),
        );
        final items = itemMaps
            .map((e) => SaleItemModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        final payments = paymentMaps
            .map((e) => PaymentModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        invoices.add(invoice.copyWith(items: items, payments: payments));
      }

      return invoices;
    } catch (e) {
      throw const CacheException('Failed to fetch sale invoices');
    }
  }

  @override
  Future<void> deleteSaleInvoice(String id) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      try {
        // Delete related items and payments first
        await txn.delete(tableItems, where: 'invoice_id = ?', whereArgs: [id]);
        await txn.delete(
          tablePayments,
          where: 'invoice_id = ?',
          whereArgs: [id],
        );

        // Delete the invoice
        final count = await txn.delete(
          tableInvoices,
          where: 'id = ?',
          whereArgs: [id],
        );

        if (count == 0) {
          throw const CacheException('Sale invoice not found');
        }
      } catch (e) {
        throw const CacheException('Failed to delete the sale invoice');
      }
    });
  }

  @override
  Future<void> addSaleItem(SaleItemModel item) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(
        tableItems,
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw const CacheException('Failed to add a sale item');
    }
  }

  @override
  Future<void> updateSaleItem(SaleItemModel item) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.update(
        tableItems,
        item.toJson(),
        where: 'id = ?',
        whereArgs: [item.id],
      );

      if (count == 0) {
        throw const CacheException('Sale item not found');
      }
    } catch (e) {
      throw const CacheException('Failed to update the sale item');
    }
  }

  @override
  Future<void> removeSaleItem(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.delete(
        tableItems,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw const CacheException('Sale item not found');
      }
    } catch (e) {
      throw const CacheException('Failed to remove the sale item');
    }
  }

  @override
  Future<List<SaleItemModel>> getSaleItems(String invoiceId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        tableItems,
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
        orderBy: 'created_at ASC',
      );

      return result
          .map((e) => SaleItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw const CacheException('Failed to fetch sale items');
    }
  }

  @override
  Future<String> addPayment(PaymentModel payment) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(
        tablePayments,
        payment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return payment.id!;
    } catch (e) {
      throw const CacheException('Failed to add a payment');
    }
  }

  @override
  Future<void> updatePayment(PaymentModel payment) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.update(
        tablePayments,
        payment.toJson(),
        where: 'id = ?',
        whereArgs: [payment.id],
      );

      if (count == 0) {
        throw const CacheException('Payment not found');
      }
    } catch (e) {
      throw const CacheException('Failed to update the payment');
    }
  }

  @override
  Future<void> deletePayment(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final count = await db.delete(
        tablePayments,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw const CacheException('Payment not found');
      }
    } catch (e) {
      throw const CacheException('Failed to delete the payment');
    }
  }

  @override
  Future<List<PaymentModel>> getPayments(String invoiceId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        tablePayments,
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
        orderBy: 'payment_date DESC, created_at DESC',
      );

      return result
          .map((e) => PaymentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw const CacheException('Failed to fetch payments');
    }
  }

  @override
  Future<String> generateInvoiceNumber() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final now = DateTime.now();
      final prefix = 'INV-${now.year}${now.month.toString().padLeft(2, '0')}';

      // Count invoices for this month
      final count =
          Sqflite.firstIntValue(
            await db.rawQuery('''
        SELECT COUNT(*) FROM $tableInvoices 
        WHERE invoice_number LIKE '$prefix%'
      '''),
          ) ??
          0;

      return '$prefix-${(count + 1).toString().padLeft(4, '0')}';
    } catch (e) {
      throw const CacheException('Failed to generate invoice number');
    }
  }
}
