import 'package:cashier_pos/features/sales/data/models/sale_invoice_model.dart';
import 'package:cashier_pos/features/sales/data/models/sale_item_model.dart';
import 'package:cashier_pos/features/sales/data/models/payment_model.dart';

/// Interface for remote data source operations related to sales
abstract class SaleRemoteDataSource {
  /// Creates a new sale invoice on the remote server
  /// Returns the ID of the created invoice
  Future<String> createSaleInvoice(SaleInvoiceModel invoice);

  /// Updates an existing sale invoice on the remote server
  Future<void> updateSaleInvoice(SaleInvoiceModel invoice);

  /// Retrieves a sale invoice by ID from the remote server
  Future<SaleInvoiceModel> getSaleInvoice(String id);

  /// Retrieves a list of sale invoices from the remote server with optional filters
  Future<List<SaleInvoiceModel>> getSaleInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
  });

  /// Deletes a sale invoice from the remote server
  Future<void> deleteSaleInvoice(String id);

  /// Adds a sale item to an existing invoice on the remote server
  Future<void> addSaleItem(String invoiceId, SaleItemModel item);

  /// Updates an existing sale item on the remote server
  Future<void> updateSaleItem(String invoiceId, SaleItemModel item);

  /// Removes a sale item from an invoice on the remote server
  Future<void> removeSaleItem(String invoiceId, String itemId);

  /// Adds a payment to an invoice on the remote server
  /// Returns the ID of the created payment
  Future<String> addPayment(String invoiceId, PaymentModel payment);

  /// Updates an existing payment on the remote server
  Future<void> updatePayment(String invoiceId, PaymentModel payment);

  /// Deletes a payment from an invoice on the remote server
  Future<void> deletePayment(String invoiceId, String paymentId);

  /// Retrieves all payments for a specific invoice from the remote server
  Future<List<PaymentModel>> getPayments(String invoiceId);

  /// Retrieves all sale items for a specific invoice from the remote server
  Future<List<SaleItemModel>> getSaleItems(String invoiceId);
}
