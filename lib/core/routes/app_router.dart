import 'package:flutter/material.dart';
import 'package:cashier_pos/features/category/presentation/screens/categories_screen.dart';
import 'package:cashier_pos/features/category/presentation/screens/category_form_screen.dart';
import 'package:cashier_pos/features/home/presentation/screens/home_screen.dart';
import 'package:cashier_pos/features/purchase/presentation/screens/purchase_list_screen.dart';
import 'package:cashier_pos/features/purchase/presentation/screens/purchase_create_screen.dart';
import 'package:cashier_pos/features/purchase/presentation/screens/purchase_detail_screen.dart';
import 'package:cashier_pos/features/purchase/presentation/screens/purchase_return_list_screen.dart';
import 'package:cashier_pos/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:cashier_pos/features/sales/presentation/pages/sales_screen.dart';
import 'package:cashier_pos/features/sales/presentation/pages/create_sale_screen.dart';
import 'package:cashier_pos/features/sales/sales_module.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';
import '../../core/widgets/app_layout.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/',
            child: HomeScreen(),
          ),
        );
      case '/categories':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/categories',
            child: CategoriesScreen(),
          ),
        );
      case '/categories/add':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/categories/add',
            child: CategoryFormScreen(),
          ),
        );
      case '/categories/edit':
        final category = settings.arguments as Category;
        return MaterialPageRoute(
          builder: (_) => AppLayout(
            currentRoute: '/categories/edit',
            child: CategoryFormScreen(category: category),
          ),
        );
      case '/purchases':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/purchases',
            child: PurchaseListScreen(),
          ),
        );
      case '/purchases/create':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/purchases/create',
            child: PurchaseCreateScreen(),
          ),
        );
      case '/purchase-detail':
        final purchaseId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AppLayout(
            currentRoute: '/purchase-detail',
            child: PurchaseDetailScreen(purchaseId: purchaseId),
          ),
        );
      case '/purchase-return-list':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/purchase-return-list',
            child: PurchaseReturnListScreen(),
          ),
        );
      case '/sales':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/sales',
            child: SalesModule(
              child: SalesScreen(),
            ),
          ),
        );
      case '/sales/create':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/sales/create',
            child: SalesModule(
              child: CreateSaleScreen(),
            ),
          ),
        );
      case '/sales/return':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/sales/return',
            child: SalesModule(
              child: Scaffold(
                body: Center(child: Text('إنشاء مرتجع مبيعات - قيد التطوير')),
              ),
            ),
          ),
        );
      case '/sales/list':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/sales/list',
            child: SalesModule(
              child: SalesScreen(),
            ),
          ),
        );
      case '/inventory':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/inventory',
            child: InventoryScreen(),
          ),
        );
      case '/purchase-return-list':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/purchase-return-list',
            child: PurchaseReturnListScreen(),
          ),
        );
      case '/purchase-detail':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/purchase-detail',
            child: Scaffold(
              body: Center(child: Text('تفاصيل فاتورة الشراء - قيد التطوير')),
            ),
          ),
        );
      case '/sale-list':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/sale-list',
            child: SalesModule(
              child: SalesScreen(),
            ),
          ),
        );
      case '/sale-return-list':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/sale-return-list',
            child: SalesModule(
              child: Scaffold(
                body: Center(child: Text('قائمة مرتجعات المبيعات - قيد التطوير')),
              ),
            ),
          ),
        );
      case '/sale-detail':
        return MaterialPageRoute(
          builder: (_) => const AppLayout(
            currentRoute: '/sale-detail',
            child: SalesModule(
              child: Scaffold(
                body: Center(child: Text('تفاصيل فاتورة المبيعات - قيد التطوير')),
              ),
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => AppLayout(
            currentRoute: '/unknown',
            child: const Scaffold(
              body: Center(child: Text('No route defined for unknown')),
            ),
          ),
        );
    }
  }
}
