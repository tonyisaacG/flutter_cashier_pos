import 'package:cashier_pos/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class ProductParams<T> {
  final T data;
  
  ProductParams(this.data);
}
