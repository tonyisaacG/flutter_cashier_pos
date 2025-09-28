import 'package:flutter/material.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/tile_button.dart';
import '../../../../core/widgets/section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageHeader(
            title: 'نقطة بيع الكاشير',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Section(
                    title: 'العمليات',
                    child: Column(
                      children: [
                        TileButton(
                          title: 'المبيعات',
                          subtitle: 'إنشاء عملية بيع جديدة',
                          icon: Icons.shopping_cart,
                          color: const Color(0xFF059669),
                          route: '/sales',
                        ),
                        const SizedBox(height: 12),
                        TileButton(
                          title: 'المشتريات',
                          subtitle: 'تسجيل مشتريات المخزون',
                          icon: Icons.local_shipping,
                          color: const Color(0xFF2563eb),
                          route: '/purchases',
                        ),
                        const SizedBox(height: 12),
                        TileButton(
                          title: 'المصروفات',
                          subtitle: 'تتبع مصروفات العمل',
                          icon: Icons.money_off,
                          color: const Color(0xFFea580c),
                          route: '/expenses',
                        ),
                      ],
                    ),
                  ),
                  Section(
                    title: 'الإدارة',
                    child: Column(
                      children: [
                        TileButton(
                          title: 'المنتجات',
                          subtitle: 'إدارة المنتجات والأسعار',
                          icon: Icons.inventory,
                          color: const Color(0xFF0ea5e9),
                          route: '/products',
                        ),
                        const SizedBox(height: 12),
                        TileButton(
                          title: 'المخزون',
                          subtitle: 'عرض المخزون الحالي',
                          icon: Icons.format_list_bulleted,
                          color: const Color(0xFF9333ea),
                          route: '/inventory',
                        ),
                      ],
                    ),
                  ),
                  Section(
                    title: 'التقارير واللوحة',
                    child: Column(
                      children: [
                        TileButton(
                          title: 'التقارير',
                          subtitle: 'عرض تقارير المبيعات والأرباح',
                          icon: Icons.bar_chart,
                          color: const Color(0xFF1d4ed8),
                          route: '/reports',
                        ),
                        const SizedBox(height: 12),
                        TileButton(
                          title: 'لوحة التحكم',
                          subtitle: 'نظرة عامة على النقدية',
                          icon: Icons.dashboard,
                          color: const Color(0xFF10b981),
                          route: '/dashboard',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
