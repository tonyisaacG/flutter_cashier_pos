import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateProductStockParams {
  final int productId;
  final int quantityChange;
  final String? reason;
  final String? reference;

  UpdateProductStockParams({
    required this.productId,
    required this.quantityChange,
    this.reason,
    this.reference,
  });
}

class UpdateProductStock {
  final ProductRepository repository;

  UpdateProductStock(this.repository);

  Future<Either<Failure, int>> call(UpdateProductStockParams params) async {
    try {
      if (params.productId <= 0) {
        return Left(ValidationFailure('Invalid product ID'));
      }

      // Check if product exists
      final existingProduct = await repository.getById(params.productId);
      if (existingProduct == null) {
        return Left(NotFoundFailure('Product not found'));
      }

      // Calculate new stock
      final newStock = existingProduct.currentStock + params.quantityChange;

      // Prevent negative stock if not allowed
      if (newStock < 0) {
        return Left(ValidationFailure('Insufficient stock'));
      }

      // Update stock
      final rowsAffected = await repository.updateStock(
        params.productId,
        params.quantityChange,
      );

      if (rowsAffected == 0) {
        return Left(
          NotFoundFailure('Product not found or could not update stock'),
        );
      }

      // In a real app, you might want to:
      // 1. Record the inventory movement
      // 2. Update any related data
      // 3. Log the transaction

      return Right(rowsAffected);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
