import 'package:dartz/dartz.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/repositories/sale_repository.dart';
import 'package:cashier_pos/features/sales/domain/usecases/usecase.dart';

class CreateReturnInvoice implements UseCase<SaleInvoice, Map<String, dynamic>> {
  final SaleRepository repository;

  CreateReturnInvoice(this.repository);

  @override
  Future<Either<Failure, SaleInvoice>> call(Map<String, dynamic> params) async {
    try {
      final SaleInvoice returnInvoice = params['returnInvoice'];
      final String originalInvoiceId = params['originalInvoiceId'];
      
      if (returnInvoice.items.isEmpty) {
        return Left(ValidationFailure('Return invoice must have at least one item'));
      }
      
      if (originalInvoiceId.isEmpty) {
        return Left(ValidationFailure('Original invoice ID is required for return'));
      }
      
      // Verify that the original invoice exists and is a sale (not a return)
      final originalInvoiceResult = await repository.getInvoice(originalInvoiceId);
      
      return originalInvoiceResult.fold(
        (failure) => Left(failure),
        (originalInvoice) async {
          if (originalInvoice.type == InvoiceType.returnSale) {
            return Left(ValidationFailure('Cannot return a return invoice'));
          }
          
          // Verify that the returned items exist in the original invoice
          for (final returnItem in returnInvoice.items) {
            final originalItem = originalInvoice.items.firstWhere(
              (item) => item.productId == returnItem.productId,
              orElse: () => throw Exception('Product not found in original invoice'),
            );
            
            if (returnItem.quantity > originalItem.quantity) {
              return Left(ValidationFailure(
                'Return quantity for ${returnItem.productName} exceeds original quantity',
              ));
            }
          }
          
          // Create the return invoice
          return await repository.createReturnInvoice(returnInvoice, originalInvoiceId);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
