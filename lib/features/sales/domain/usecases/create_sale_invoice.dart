import 'package:dartz/dartz.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/repositories/sale_repository.dart';
import 'package:cashier_pos/features/sales/domain/usecases/usecase.dart';

class CreateSaleInvoice implements UseCase<SaleInvoice, SaleInvoice> {
  final SaleRepository repository;

  CreateSaleInvoice(this.repository);

  @override
  Future<Either<Failure, SaleInvoice>> call(SaleInvoice invoice) async {
    try {
      // Validate the invoice before creating
      if (invoice.items.isEmpty) {
        return Left(ValidationFailure('Invoice must have at least one item'));
      }

      if (invoice.type == InvoiceType.returnSale && invoice.returnRefId == null) {
        return Left(ValidationFailure('Return invoice must reference an original invoice'));
      }

      // Additional validation can be added here
      
      // Call repository to create the invoice
      return await repository.createInvoice(invoice);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
