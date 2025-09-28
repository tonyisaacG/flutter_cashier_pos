import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class CashierApp extends StatelessWidget {
  const CashierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Cashier POS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
          builder: (context, child) {
            return child!;
          },
        );
      },
    );
  }
}
