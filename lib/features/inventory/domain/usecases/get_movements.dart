import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../product/domain/usecases/base_use_case.dart';
import '../../data/models/inventory_movement_model.dart';

class GetMovementsParams {
  final int? productId;
  final MovementType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  GetMovementsParams({
    this.productId,
    this.type,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });
}

class GetMovements
    implements UseCase<List<InventoryMovementModel>, GetMovementsParams> {
  final InventoryRepository repository;

  GetMovements(this.repository);

  @override
  Future<Either<Failure, List<InventoryMovementModel>>> call(
    GetMovementsParams params,
  ) async {
    try {
      final movements = await repository.getMovements(
        productId: params.productId,
        type: params.type,
        startDate: params.startDate,
        endDate: params.endDate,
        limit: params.limit,
        offset: params.offset,
      );
      return Right(movements);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
