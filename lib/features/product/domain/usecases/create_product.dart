import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<Either<Failure, int>> call(Product product) async {
    try {
      // Validate required fields
      if (product.productCode.isEmpty) {
        return Left(ValidationFailure('Product code is required'));
      }

      if (product.productName.isEmpty) {
        return Left(ValidationFailure('Product name is required'));
      }

      if (product.salePrice <= 0) {
        return Left(ValidationFailure('Sale price must be greater than 0'));
      }

      if (product.costPrice < 0) {
        return Left(ValidationFailure('Cost price cannot be negative'));
      }

      if (product.minQuantity < 0) {
        return Left(ValidationFailure('Minimum quantity cannot be negative'));
      }

      if (product.currentStock < 0) {
        return Left(ValidationFailure('Current stock cannot be negative'));
      }

      // Check if product code already exists
      final existingProduct = await repository.findByCode(product.productCode);
      if (existingProduct != null) {
        return Left(ValidationFailure('Product with this code already exists'));
      }

      // Convert to model and save
      final productModel = product;
      final id = await repository.create(productModel);

      return Right(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
