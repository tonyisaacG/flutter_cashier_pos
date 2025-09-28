import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection_container.dart';
import 'core/routes/app_router.dart';
import 'features/category/presentation/bloc/category_bloc.dart';
import 'features/sales/sales_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SalesModule(
      child: MultiBlocProvider(
        providers: [
          // Provide the CategoryBloc to the widget tree
          BlocProvider<CategoryBloc>(
            create: (context) => GetIt.I<CategoryBloc>(),
          ),
        ],
        child: MaterialApp(
          title: 'Cashier POS',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
        ),
      ),
    );
  }
}
