import 'package:dartz/dartz.dart';
import 'package:cashier_pos/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class Params<T> {
  final T data;
  
  Params(this.data);
}
