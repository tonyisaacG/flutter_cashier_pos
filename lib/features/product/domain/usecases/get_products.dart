import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductsParams {
  final int? categoryId;
  final String? searchQuery;
  final bool? activeOnly;
  final int? limit;
  final int? offset;
  final String? orderBy;
  final bool orderDesc;

  GetProductsParams({
    this.categoryId,
    this.searchQuery,
    this.activeOnly = true,
    this.limit,
    this.offset,
    this.orderBy = 'product_name',
    this.orderDesc = false,
  });
}

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    try {
      // In a real implementation, you would pass these filters to the repository
      // For now, we'll just get all products and filter in memory
      final products = await repository.getAll(
        limit: params.limit,
        offset: params.offset,
        orderBy: params.orderBy,
        orderDesc: params.orderDesc,
      );

      // Convert models to entities
      var result = products.map((p) => p).toList();

      // Apply filters
      if (params.categoryId != null) {
        result = result
            .where((p) => p.categoryId == params.categoryId)
            .toList();
      }

      if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
        final query = params.searchQuery!.toLowerCase();
        result = result
            .where(
              (p) =>
                  p.productName.toLowerCase().contains(query) ||
                  p.productCode.toLowerCase().contains(query),
            )
            .toList();
      }

      if (params.activeOnly == true) {
        result = result.where((p) => p.isActive).toList();
      }

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
