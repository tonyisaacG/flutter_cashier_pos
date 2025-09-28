import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../product/domain/usecases/base_use_case.dart';

class GetInventorySummary implements UseCase<Map<String, dynamic>, NoParams> {
  final InventoryRepository repository;

  GetInventorySummary(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    try {
      final summary = await repository.getInventorySummary();
      return Right(summary);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
