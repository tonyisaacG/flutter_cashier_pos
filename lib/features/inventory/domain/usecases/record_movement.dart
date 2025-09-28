import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../product/domain/usecases/base_use_case.dart';
import '../../data/models/inventory_movement_model.dart';

class RecordMovement implements UseCase<int, InventoryMovementModel> {
  final InventoryRepository repository;

  RecordMovement(this.repository);

  @override
  Future<Either<Failure, int>> call(InventoryMovementModel params) async {
    try {
      final movementId = await repository.recordMovement(params);
      return Right(movementId);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
