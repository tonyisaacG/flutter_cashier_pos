import 'package:dartz/dartz.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/repositories/sale_repository.dart';
import 'package:cashier_pos/features/sales/domain/entities/payment.dart';
import 'package:cashier_pos/features/sales/domain/usecases/usecase.dart';

class AddPayment implements UseCase<SaleInvoice, Map<String, dynamic>> {
  final SaleRepository repository;

  AddPayment(this.repository);

  @override
  Future<Either<Failure, SaleInvoice>> call(Map<String, dynamic> params) async {
    try {
      final String invoiceId = params['invoiceId'];
      final Payment payment = params['payment'];
      
      if (invoiceId.isEmpty) {
        return Left(ValidationFailure('Invoice ID cannot be empty'));
      }
      
      if (payment.amount <= 0) {
        return Left(ValidationFailure('Payment amount must be greater than zero'));
      }
      
      return await repository.addPayment(invoiceId, payment);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
