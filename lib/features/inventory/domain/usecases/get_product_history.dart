import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../product/domain/usecases/base_use_case.dart';
import '../../data/models/inventory_movement_model.dart';

class GetProductHistoryParams {
  final int productId;
  final DateTime? startDate;
  final DateTime? endDate;
  final MovementType? type;

  GetProductHistoryParams({
    required this.productId,
    this.startDate,
    this.endDate,
    this.type,
  });
}

class GetProductHistory
    implements UseCase<List<InventoryMovementModel>, GetProductHistoryParams> {
  final InventoryRepository repository;

  GetProductHistory(this.repository);

  @override
  Future<Either<Failure, List<InventoryMovementModel>>> call(
    GetProductHistoryParams params,
  ) async {
    try {
      final movements = await repository.getProductHistory(
        params.productId,
        startDate: params.startDate,
        endDate: params.endDate,
        type: params.type,
      );
      return Right(movements);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
