// injection_container.dart
// Simple dependency injection without code generation

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sqflite/sqflite.dart';

// Core
import 'package:cashier_pos/core/network/network_info.dart';
import '../database/database_helper.dart';

// Category module
import 'package:cashier_pos/features/category/domain/repositories/category_repository.dart';
import 'package:cashier_pos/features/category/data/repositories/category_repository_impl.dart';
import 'package:cashier_pos/features/category/domain/usecases/create_category.dart';
import 'package:cashier_pos/features/category/domain/usecases/update_category.dart';
import 'package:cashier_pos/features/category/domain/usecases/delete_category.dart';
import 'package:cashier_pos/features/category/domain/usecases/get_categories.dart';
import 'package:cashier_pos/features/category/domain/usecases/get_category.dart';
import 'package:cashier_pos/features/category/presentation/bloc/category_bloc.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_bloc.dart';

// Sales module
import 'package:cashier_pos/features/sales/sales_module.dart';
import 'package:cashier_pos/features/sales/data/datasources/sale_local_data_source.dart';
import 'package:cashier_pos/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:cashier_pos/features/sales/domain/repositories/sale_repository.dart';
import 'package:cashier_pos/features/sales/domain/usecases/create_sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/usecases/create_return_invoice.dart';
import 'package:cashier_pos/features/sales/domain/usecases/add_payment.dart';
import 'package:cashier_pos/features/sales/domain/usecases/list_invoices.dart';

// GetIt instance
final getIt = GetIt.instance;

/// Configure all dependencies manually (no code generation needed)
Future<void> configureDependencies() async {
  // Core dependencies
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Database instance
  final database = await getIt<DatabaseHelper>().database;
  getIt.registerLazySingleton<Database>(() => database);

  // Network dependencies
  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker(),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<InternetConnectionChecker>()),
  );

  // Shared preferences (async registration)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Category module dependencies
  _registerCategoryDependencies();

  // Sales module dependencies
  _registerSalesDependencies();
}

/// Register category module dependencies
void _registerCategoryDependencies() {
  // Repository
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<Database>()),
  );

  // Use cases
  getIt.registerLazySingleton<CreateCategory>(
    () => CreateCategory(getIt<CategoryRepository>()),
  );

  getIt.registerLazySingleton<UpdateCategory>(
    () => UpdateCategory(getIt<CategoryRepository>()),
  );

  getIt.registerLazySingleton<DeleteCategory>(
    () => DeleteCategory(getIt<CategoryRepository>()),
  );

  getIt.registerLazySingleton<GetCategories>(
    () => GetCategories(getIt<CategoryRepository>()),
  );

  getIt.registerLazySingleton<GetCategory>(
    () => GetCategory(getIt<CategoryRepository>()),
  );

  // BLoC
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      createCategory: getIt<CreateCategory>(),
      updateCategory: getIt<UpdateCategory>(),
      deleteCategory: getIt<DeleteCategory>(),
      getCategories: getIt<GetCategories>(),
      getCategory: getIt<GetCategory>(),
    ),
  );
}

/// Register sales module dependencies
void _registerSalesDependencies() {
  // Register sales dependencies manually since we're not using code generation
  getIt.registerLazySingleton<SaleLocalDataSource>(
    () => SaleLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<SaleRepository>(
    () => SaleRepositoryImpl(
      localDataSource: getIt<SaleLocalDataSource>(),
      currentUserId: 'current_user', // Replace with actual user ID logic
    ),
  );

  // Register use cases
  getIt.registerLazySingleton<CreateSaleInvoice>(
    () => CreateSaleInvoice(getIt<SaleRepository>()),
  );

  getIt.registerLazySingleton<CreateReturnInvoice>(
    () => CreateReturnInvoice(getIt<SaleRepository>()),
  );

  getIt.registerLazySingleton<AddPayment>(
    () => AddPayment(getIt<SaleRepository>()),
  );

  getIt.registerLazySingleton<ListInvoices>(
    () => ListInvoices(getIt<SaleRepository>()),
  );

  // BLoC
  getIt.registerFactory<SaleBloc>(
    () => SaleBloc(
      createSaleInvoice: getIt<CreateSaleInvoice>(),
      createReturnInvoice: getIt<CreateReturnInvoice>(),
      addPayment: getIt<AddPayment>(),
      listInvoices: getIt<ListInvoices>(),
    ),
  );
}
