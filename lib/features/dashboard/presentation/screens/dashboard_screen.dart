import 'package:flutter/material.dart';

import '../../../../core/widgets/app_layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load dashboard data from repositories
      // In a real implementation, this would call multiple repositories
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/dashboard',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          actions: [
            IconButton(
              onPressed: _refreshDashboard,
              icon: const Icon(Icons.refresh),
              tooltip: 'تحديث البيانات',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    _buildWelcomeSection(),
                    const SizedBox(height: 24),

                    // Quick stats
                    _buildQuickStats(),
                    const SizedBox(height: 24),

                    // Recent activities
                    _buildRecentActivities(),
                    const SizedBox(height: 24),

                    // Quick actions
                    _buildQuickActions(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.dashboard,
                  size: 32,
                  color: const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً بك في لوحة التحكم',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'نظرة عامة على أداء النقدية اليوم',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإحصائيات السريعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'المبيعات اليوم',
                '2,500.00 ريال',
                Icons.point_of_sale,
                const Color(0xFF4CAF50),
                '+12%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'المبيعات الشهر',
                '45,000.00 ريال',
                Icons.trending_up,
                const Color(0xFF2196F3),
                '+8%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'المشتريات الشهر',
                '32,000.00 ريال',
                Icons.local_shipping,
                const Color(0xFFFF9800),
                '+15%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'صافي الربح',
                '13,000.00 ريال',
                Icons.account_balance_wallet,
                const Color(0xFF9C27B0),
                '+5%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String change) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                change,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأنشطة الأخيرة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _buildActivityItem(
                'فاتورة مبيعات جديدة',
                'رقم 001234 - 250.00 ريال',
                Icons.point_of_sale,
                const Color(0xFF4CAF50),
                'منذ 5 دقائق',
              ),
              const Divider(),
              _buildActivityItem(
                'فاتورة شراء جديدة',
                'من شركة أدوات البناء - 1,200.00 ريال',
                Icons.local_shipping,
                const Color(0xFF2196F3),
                'منذ 15 دقيقة',
              ),
              const Divider(),
              _buildActivityItem(
                'دفعة جديدة',
                'فاتورة مبيعات 001230 - 500.00 ريال',
                Icons.payment,
                const Color(0xFFFF9800),
                'منذ 30 دقيقة',
              ),
              const Divider(),
              _buildActivityItem(
                'منتج نفد من المخزون',
                'أسمنت أبيض - تنبيه مخزون',
                Icons.warning,
                const Color(0xFFF44336),
                'منذ ساعة',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String description, IconData icon, Color color, String time) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات السريعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                'فاتورة مبيعات',
                Icons.point_of_sale,
                const Color(0xFF4CAF50),
                () => Navigator.of(context).pushNamed('/sales/create'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionButton(
                'فاتورة شراء',
                Icons.local_shipping,
                const Color(0xFF2196F3),
                () => Navigator.of(context).pushNamed('/purchases/create'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                'إضافة منتج',
                Icons.inventory_2,
                const Color(0xFFFF9800),
                () => Navigator.of(context).pushNamed('/products/add'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionButton(
                'عرض التقارير',
                Icons.bar_chart,
                const Color(0xFF9C27B0),
                () => Navigator.of(context).pushNamed('/reports'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _refreshDashboard() {
    _loadDashboardData();
  }
}
