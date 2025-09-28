import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_layout.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load reports from repositories
      // In a real implementation, this would call multiple repositories
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      debugPrint('Error loading reports: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/reports',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التقارير'),
          actions: [
            IconButton(
              onPressed: _exportReports,
              icon: const Icon(Icons.download),
              tooltip: 'تصدير التقارير',
            ),
            IconButton(
              onPressed: _refreshReports,
              icon: const Icon(Icons.refresh),
              tooltip: 'تحديث التقارير',
            ),
          ],
        ),
        body: Column(
          children: [
            // Date range selector
            _buildDateRangeSelector(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildReportsContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectStartDate(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(DateFormat('yyyy/MM/dd').format(_startDate)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text('إلى'),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => _selectEndDate(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(DateFormat('yyyy/MM/dd').format(_endDate)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _loadReports,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('عرض'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          _buildSummaryCards(),
          const SizedBox(height: 24),

          // Sales report
          _buildSalesReport(),
          const SizedBox(height: 24),

          // Purchase report
          _buildPurchaseReport(),
          const SizedBox(height: 24),

          // Inventory report
          _buildInventoryReport(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'إجمالي المبيعات',
            '15,500.00 ريال', // TODO: Replace with actual data
            Icons.point_of_sale,
            const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'إجمالي المشتريات',
            '12,300.00 ريال', // TODO: Replace with actual data
            Icons.local_shipping,
            const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesReport() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تقرير المبيعات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewDetailedSalesReport,
                  child: const Text('عرض التفاصيل'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReportRow('عدد الفواتير', '45 فاتورة'),
            _buildReportRow('إجمالي المبيعات', '15,500.00 ريال'),
            _buildReportRow('المدفوعات النقدية', '12,000.00 ريال'),
            _buildReportRow('المدفوعات الائتمانية', '3,500.00 ريال'),
            _buildReportRow('المبالغ المتبقية', '1,200.00 ريال'),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseReport() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تقرير المشتريات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewDetailedPurchaseReport,
                  child: const Text('عرض التفاصيل'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReportRow('عدد الفواتير', '23 فاتورة'),
            _buildReportRow('إجمالي المشتريات', '12,300.00 ريال'),
            _buildReportRow('المدفوعات النقدية', '8,500.00 ريال'),
            _buildReportRow('المدفوعات الائتمانية', '3,800.00 ريال'),
            _buildReportRow('المبالغ المتبقية', '2,100.00 ريال'),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryReport() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تقرير المخزون',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewDetailedInventoryReport,
                  child: const Text('عرض التفاصيل'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReportRow('إجمالي المنتجات', '150 منتج'),
            _buildReportRow('المنتجات المتوفرة', '135 منتج'),
            _buildReportRow('المنتجات منخفضة المخزون', '12 منتج'),
            _buildReportRow('المنتجات نافدة المخزون', '3 منتج'),
            _buildReportRow('قيمة المخزون', '45,000.00 ريال'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
      _loadReports();
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
      _loadReports();
    }
  }

  void _exportReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تصدير التقارير قيد التطوير')),
    );
  }

  void _refreshReports() {
    _loadReports();
  }

  void _viewDetailedSalesReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('عرض تفاصيل المبيعات قيد التطوير')),
    );
  }

  void _viewDetailedPurchaseReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('عرض تفاصيل المشتريات قيد التطوير')),
    );
  }

  void _viewDetailedInventoryReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('عرض تفاصيل المخزون قيد التطوير')),
    );
  }
}
