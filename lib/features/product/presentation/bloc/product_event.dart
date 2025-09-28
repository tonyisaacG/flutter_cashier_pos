import 'package:equatable/equatable.dart';
import 'package:cashier_pos/features/product/domain/entities/product.dart';

// Base event class
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Load all products
class LoadProducts extends ProductEvent {
  final int? categoryId;
  final String? searchQuery;
  final bool? activeOnly;
  final int? limit;
  final int? offset;
  final String? orderBy;
  final bool orderDesc;

  const LoadProducts({
    this.categoryId,
    this.searchQuery,
    this.activeOnly = true,
    this.limit,
    this.offset,
    this.orderBy = 'product_name',
    this.orderDesc = false,
  });

  @override
  List<Object?> get props => [
    categoryId,
    searchQuery,
    activeOnly,
    limit,
    offset,
    orderBy,
    orderDesc,
  ];
}

// Create a new product
class CreateProductEvent extends ProductEvent {
  final Product product;

  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

// Update an existing product
class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

// Delete a product
class DeleteProductEvent extends ProductEvent {
  final int productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Get a single product by ID
class GetProductEvent extends ProductEvent {
  final int productId;

  const GetProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Search products
class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// Update product stock
class UpdateProductStockEvent extends ProductEvent {
  final int productId;
  final int quantityChange;
  final String? reason;
  final String? reference;

  const UpdateProductStockEvent({
    required this.productId,
    required this.quantityChange,
    this.reason,
    this.reference,
  });

  @override
  List<Object?> get props => [productId, quantityChange, reason, reference];
}

// Reset the product state to initial
class ResetProductState extends ProductEvent {}
