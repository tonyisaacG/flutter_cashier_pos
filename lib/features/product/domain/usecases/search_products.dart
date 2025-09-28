import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';
import 'package:cashier_pos/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(String query) async {
    try {
      if (query.isEmpty) {
        return Right([]);
      }

      final results = await repository.search(query);
      return Right(results.map((p) => p).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
