import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Either<Failure, int>> call(int productId) async {
    try {
      if (productId <= 0) {
        return Left(ValidationFailure('Invalid product ID'));
      }
      
      // Check if product exists
      final existingProduct = await repository.getById(productId);
      if (existingProduct == null) {
        return Left(NotFoundFailure('Product not found'));
      }
      
      // Check if product is in use (e.g., in transactions)
      // This is a placeholder - you'll need to implement the actual check
      // based on your business rules
      
      final rowsAffected = await repository.delete(productId);
      
      if (rowsAffected == 0) {
        return Left(NotFoundFailure('Product not found or could not be deleted'));
      }
      
      return Right(rowsAffected);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
