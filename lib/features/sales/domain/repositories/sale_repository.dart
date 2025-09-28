import 'package:dartz/dartz.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';

import '../entities/payment.dart';
import 'package:dartz/dartz.dart';

// ==============================
// Abstract Repository
// ==============================
abstract class SaleRepository {
  // Create a new sale invoice
  Future<Either<Failure, SaleInvoice>> createInvoice(SaleInvoice invoice);

  // Create a return invoice
  Future<Either<Failure, SaleInvoice>> createReturnInvoice(
    SaleInvoice returnInvoice,
    String originalInvoiceId,
  );

  // Get invoice by ID
  Future<Either<Failure, SaleInvoice>> getInvoice(String id);

  // List all invoices with optional filters
  Future<Either<Failure, List<SaleInvoice>>> listInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? customerId,
    InvoiceStatus? status,
    InvoiceType? type,
    int page = 1,
    int limit = 20,
  });

  // Add payment to an invoice
  Future<Either<Failure, SaleInvoice>> addPayment(
    String invoiceId,
    Payment payment,
  );

  // Update invoice status
  Future<Either<Failure, SaleInvoice>> updateStatus(
    String invoiceId,
    InvoiceStatus status,
  );

  // Delete an invoice (soft delete)
  Future<Either<Failure, void>> deleteInvoice(String id);

  // Delete a payment
  Future<Either<Failure, void>> deletePayment(String paymentId);

  // Update an invoice
  Future<Either<Failure, void>> updateInvoice(SaleInvoice invoice);

  // Get all invoices (with filters)
  Future<Either<Failure, List<SaleInvoice>>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
  });

  // Search products for sale
  Future<Either<Failure, List<Map<String, dynamic>>>> searchProducts(
    String query,
  );

  // Get product by barcode
  Future<Either<Failure, Map<String, dynamic>>> getProductByBarcode(
    String barcode,
  );

  // Generate invoice number (async)
  Future<Either<Failure, String>> generateInvoiceNumber();

  // Export invoices to Excel
  Future<Either<Failure, String>> exportToExcel({
    required DateTime startDate,
    required DateTime endDate,
    String? customerId,
    InvoiceStatus? status,
    InvoiceType? type,
  });

  // Generate PDF for an invoice
  Future<Either<Failure, String>> generatePdf(String invoiceId);
}
