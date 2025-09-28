import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Either<Failure, int>> call(Product product) async {
    try {
      if (product.id == null) {
        return Left(ValidationFailure('Product ID is required for update'));
      }

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

      // Check if product exists
      final existingProduct = await repository.getById(product.id!);
      if (existingProduct == null) {
        return Left(NotFoundFailure('Product not found'));
      }

      // Check if product code is being changed to an existing one
      if (existingProduct.productCode != product.productCode) {
        final codeExists = await repository.findByCode(product.productCode);
        if (codeExists != null) {
          return Left(
            ValidationFailure('Product with this code already exists'),
          );
        }
      }

      // Convert to model and update
      final productModel = product;
      final rowsAffected = await repository.update(productModel);

      if (rowsAffected == 0) {
        return Left(NotFoundFailure('Product not found or not updated'));
      }

      return Right(rowsAffected);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
