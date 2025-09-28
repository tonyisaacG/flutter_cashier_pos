import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cashier_pos/features/product/domain/usecases/product_usecases.dart';
import 'package:cashier_pos/features/product/presentation/bloc/product_event.dart';
import 'package:cashier_pos/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final GetProduct getProduct;
  final GetProducts getProducts;
  final SearchProducts searchProducts;
  final UpdateProductStock updateProductStock;

  ProductBloc({
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.getProduct,
    required this.getProducts,
    required this.searchProducts,
    required this.updateProductStock,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<GetProductEvent>(_onGetProduct);
    on<SearchProductsEvent>(_onSearchProducts);
    on<UpdateProductStockEvent>(_onUpdateProductStock);
    on<ResetProductState>(_onResetState);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await getProducts(
      GetProductsParams(
        categoryId: event.categoryId,
        searchQuery: event.searchQuery,
        activeOnly: event.activeOnly,
        limit: event.limit,
        offset: event.offset,
        orderBy: event.orderBy,
        orderDesc: event.orderDesc,
      ),
    );

    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (products) => emit(
        ProductsLoaded(
          products: products,
          hasReachedMax: event.limit != null && products.length < event.limit!,
        ),
      ),
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await createProduct(event.product);

    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (productId) => emit(
        ProductOperationSuccess(
          message: 'Product created successfully',
          product: event.product.copyWith(id: productId),
        ),
      ),
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await updateProduct(event.product);

    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (rowsAffected) => emit(
        ProductOperationSuccess(
          message: 'Product updated successfully',
          product: event.product,
        ),
      ),
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await deleteProduct(event.productId);

    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (rowsAffected) => emit(
        ProductOperationSuccess(message: 'Product deleted successfully'),
      ),
    );
  }

  Future<void> _onGetProduct(
    GetProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await getProduct(event.productId);

    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (product) => emit(ProductLoadSuccess(product)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(ProductSearchResults(const []));
      return;
    }

    final result = await searchProducts(event.query);

    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (products) => emit(ProductSearchResults(products)),
    );
  }

  Future<void> _onUpdateProductStock(
    UpdateProductStockEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await updateProductStock(
      UpdateProductStockParams(
        productId: event.productId,
        quantityChange: event.quantityChange,
        reason: event.reason,
        reference: event.reference,
      ),
    );

    result.fold((failure) => emit(ProductFailure(failure.toString())), (
      rowsAffected,
    ) async {
      // Get the updated product
      final productResult = await getProduct(event.productId);

      productResult.fold(
        (failure) => emit(ProductFailure(failure.toString())),
        (product) => emit(
          ProductStockUpdated(
            productId: product.id!,
            newStock: product.currentStock,
            message: 'Stock updated successfully',
          ),
        ),
      );
    });
  }

  void _onResetState(ResetProductState event, Emitter<ProductState> emit) {
    emit(ProductInitial());
  }
}
