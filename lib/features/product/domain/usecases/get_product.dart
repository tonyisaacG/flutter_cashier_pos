import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);

  Future<Either<Failure, Product>> call(int productId) async {
    try {
      if (productId <= 0) {
        return Left(ValidationFailure('Invalid product ID'));
      }

      final product = await repository.getById(productId);

      if (product == null) {
        return Left(NotFoundFailure('Product not found'));
      }

      return Right(product);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
