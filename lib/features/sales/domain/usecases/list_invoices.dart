import 'package:dartz/dartz.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/repositories/sale_repository.dart';
import 'package:cashier_pos/features/sales/domain/usecases/usecase.dart';

class ListInvoices implements UseCase<List<SaleInvoice>, Map<String, dynamic>> {
  final SaleRepository repository;

  ListInvoices(this.repository);

  @override
  Future<Either<Failure, List<SaleInvoice>>> call(
    Map<String, dynamic> params,
  ) async {
    try {
      return await repository.listInvoices(
        startDate: params['startDate'],
        endDate: params['endDate'],
        customerId: params['customerId'],
        status: params['status'],
        type: params['type'],
        page: params['page'] ?? 1,
        limit: params['limit'] ?? 20,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
