import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:cashier_pos/core/error/exceptions.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/entities/payment.dart';
import 'package:cashier_pos/features/sales/domain/repositories/sale_repository.dart';
import 'package:cashier_pos/features/sales/data/datasources/sale_local_data_source.dart';
import 'package:cashier_pos/features/sales/data/models/sale_invoice_model.dart';

import '../models/payment_model.dart';

// ==============================
// Implementation
// ==============================
class SaleRepositoryImpl implements SaleRepository {
  final SaleLocalDataSource localDataSource;
  final String currentUserId;

  SaleRepositoryImpl({
    required this.localDataSource,
    required this.currentUserId,
  });

  Future<Either<Failure, T>> _handleLocalCall<T>({
    required Future<T> Function() localCall,
  }) async {
    try {
      final result = await localCall();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleInvoice>> createInvoice(
    SaleInvoice invoice,
  ) async {
    final invoiceModel = SaleInvoiceModel.fromEntity(invoice);

    return _handleLocalCall<SaleInvoice>(
      localCall: () async {
        final invoiceNumber = await localDataSource.generateInvoiceNumber();
        final invoiceWithNumber = invoiceModel.copyWith(
          invoiceNumber: invoiceNumber,
          createdBy: currentUserId,
          createdAt: DateTime.now(),
        );
        final createdInvoice = await localDataSource.createSaleInvoice(
          invoiceWithNumber,
        );
        return await localDataSource.getInvoice(createdInvoice.id!);
      },
    );
  }

  @override
  Future<Either<Failure, SaleInvoice>> createReturnInvoice(
    SaleInvoice returnInvoice,
    String originalInvoiceId,
  ) async {
    final returnInvoiceModel = SaleInvoiceModel.fromEntity(returnInvoice);

    return _handleLocalCall<SaleInvoice>(
      localCall: () async {
        final invoiceNumber = await localDataSource.generateInvoiceNumber();
        final invoiceWithNumber = returnInvoiceModel.copyWith(
          invoiceNumber: 'RMA-$invoiceNumber',
          createdBy: currentUserId,
          createdAt: DateTime.now(),
          returnRefId: originalInvoiceId,
        );
        final createdInvoice = await localDataSource.createSaleInvoice(
          invoiceWithNumber,
        );

        // Try updating original invoice status
        try {
          final originalInvoice = await localDataSource.getInvoice(
            originalInvoiceId,
          );
          if (originalInvoice.status != InvoiceStatus.returned &&
              originalInvoice.status != InvoiceStatus.partiallyPaid) {
            final newStatus =
                originalInvoice.items.length == returnInvoice.items.length
                ? InvoiceStatus.returned
                : InvoiceStatus.partiallyPaid;
            await localDataSource.updateSaleInvoice(
              originalInvoice.copyWith(status: newStatus),
            );
          }
        } catch (e) {
          print('Failed to update original invoice status: $e');
        }

        return await localDataSource.getInvoice(createdInvoice.id!);
      },
    );
  }

  @override
  Future<Either<Failure, SaleInvoice>> getInvoice(String id) {
    return _handleLocalCall<SaleInvoice>(
      localCall: () => localDataSource.getInvoice(id),
    );
  }

  @override
  Future<Either<Failure, List<SaleInvoice>>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
  }) {
    return _handleLocalCall<List<SaleInvoice>>(
      localCall: () => localDataSource.getInvoices(
        startDate: startDate,
        endDate: endDate,
        status: status,
        type: type,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> updateInvoice(SaleInvoice invoice) {
    final invoiceModel = SaleInvoiceModel.fromEntity(invoice);

    return _handleLocalCall<void>(
      localCall: () => localDataSource.updateSaleInvoice(
        invoiceModel.copyWith(updatedAt: DateTime.now()),
      ),
    );
  }

  @override
  Future<Either<Failure, SaleInvoice>> updateStatus(
    String invoiceId,
    InvoiceStatus status,
  ) async {
    try {
      final updatedInvoice = await localDataSource.updateStatus(
        invoiceId,
        status.name,
      );
      return Right(updatedInvoice);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment(String paymentId) async {
    Payment? payment;
    try {
      payment = await localDataSource.getPayment(paymentId);
    } catch (e) {
      print('Failed to find payment locally: $e');
    }

    return _handleLocalCall<void>(
      localCall: () async {
        await localDataSource.deletePayment(paymentId);

        if (payment != null) {
          try {
            final invoice = await localDataSource.getInvoice(payment.invoiceId);
            final newPaidAmount = ((invoice.paidAmount as num) - payment.amount)
                .clamp(0, double.infinity)
                .toDouble();
            final newStatus = newPaidAmount <= 0
                ? InvoiceStatus.draft
                : (newPaidAmount < invoice.total
                      ? InvoiceStatus.partiallyPaid
                      : InvoiceStatus.completed);

            await localDataSource.updateSaleInvoice(
              invoice.copyWith(
                paidAmount: newPaidAmount,
                status: newStatus,
                updatedAt: DateTime.now(),
              ),
            );
          } catch (e) {
            print('Failed to update invoice after payment deletion: $e');
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getProductByBarcode(
    String barcode,
  ) async {
    try {
      final product = await localDataSource.getProductByBarcode(barcode);
      return Right(product);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleInvoice>> addPayment(
    String invoiceId,
    Payment payment,
  ) {
    final paymentModel = PaymentModel.fromEntity(payment);

    return _handleLocalCall<SaleInvoice>(
      localCall: () => localDataSource.addPayment(invoiceId, paymentModel),
    );
  }

  @override
  Future<Either<Failure, void>> deleteInvoice(String id) {
    return _handleLocalCall<void>(
      localCall: () => localDataSource.deleteInvoice(id),
    );
  }

  @override
  Future<Either<Failure, List<SaleInvoice>>> listInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? customerId,
    InvoiceStatus? status,
    InvoiceType? type,
    int page = 1,
    int limit = 20,
  }) {
    return _handleLocalCall<List<SaleInvoice>>(
      localCall: () => localDataSource
          .getInvoices(
            startDate: startDate,
            endDate: endDate,
            customerId: customerId,
            status: status?.name,
            type: type?.name,
            page: page,
            limit: limit,
          )
          .then((models) => models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchProducts(
    String query,
  ) async {
    try {
      final products = await localDataSource.searchProducts(query);
      return Right(products);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateInvoiceNumber() {
    return _handleLocalCall<String>(
      localCall: () => localDataSource.generateInvoiceNumber(),
    );
  }

  @override
  Future<Either<Failure, String>> exportToExcel({
    required DateTime startDate,
    required DateTime endDate,
    String? customerId,
    InvoiceStatus? status,
    InvoiceType? type,
  }) async {
    return Left(UnknownFailure('Feature not implemented yet'));
  }

  @override
  Future<Either<Failure, String>> generatePdf(String invoiceId) async {
    return Left(UnknownFailure('Feature not implemented yet'));
  }
}
