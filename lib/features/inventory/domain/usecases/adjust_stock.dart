import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../product/domain/usecases/base_use_case.dart';

class AdjustStockParams {
  final int productId;
  final int newQuantity;
  final String reason;
  final String? reference;

  AdjustStockParams({
    required this.productId,
    required this.newQuantity,
    required this.reason,
    this.reference,
  });
}

class AdjustStock implements UseCase<int, AdjustStockParams> {
  final InventoryRepository repository;

  AdjustStock(this.repository);

  @override
  Future<Either<Failure, int>> call(AdjustStockParams params) async {
    try {
      final movementId = await repository.adjustStock(
        productId: params.productId,
        newQuantity: params.newQuantity,
        reason: params.reason,
        reference: params.reference,
      );
      return Right(movementId);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
