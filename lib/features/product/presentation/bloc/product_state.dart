import 'package:equatable/equatable.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;

  const ProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [products, hasReachedMax];

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ProductOperationSuccess extends ProductState {
  final String message;
  final Product? product;

  const ProductOperationSuccess({
    required this.message,
    this.product,
  });

  @override
  List<Object?> get props => [message, product];
}

class ProductLoadSuccess extends ProductState {
  final Product product;

  const ProductLoadSuccess(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductFailure extends ProductState {
  final String message;

  const ProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductSearchResults extends ProductState {
  final List<Product> results;

  const ProductSearchResults(this.results);

  @override
  List<Object?> get props => [results];
}

class ProductStockUpdated extends ProductState {
  final int productId;
  final int newStock;
  final String message;

  const ProductStockUpdated({
    required this.productId,
    required this.newStock,
    required this.message,
  });

  @override
  List<Object?> get props => [productId, newStock, message];
}
