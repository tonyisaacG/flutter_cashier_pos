import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/entities/purchase_item.dart';
import '../../domain/entities/payment.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final String purchaseId;

  const PurchaseDetailScreen({
    super.key,
    required this.purchaseId,
  });

  @override
  State<PurchaseDetailScreen> createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  Purchase? _purchase;
  List<PurchaseItem> _items = [];
  List<Payment> _payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPurchaseDetails();
  }

  Future<void> _loadPurchaseDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load purchase details from repository
      // In a real implementation, this would call the repository
      // For now, we'll show placeholder data
      _purchase = null; // Would be loaded from repository
      _items = [];
      _payments = [];
    } catch (e) {
      debugPrint('Error loading purchase details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/purchase-detail',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل فاتورة الشراء'),
          actions: [
            IconButton(
              onPressed: _editPurchase,
              icon: const Icon(Icons.edit),
              tooltip: 'تعديل الفاتورة',
            ),
            IconButton(
              onPressed: _printPurchase,
              icon: const Icon(Icons.print),
              tooltip: 'طباعة الفاتورة',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _purchase == null
                ? _buildEmptyState()
                : _buildPurchaseDetails(),
        floatingActionButton: FloatingActionButton(
          onPressed: _addPayment,
          backgroundColor: const Color(0xFF4CAF50),
          child: const Icon(Icons.add, color: Colors.white),
          tooltip: 'إضافة دفعة',
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لم يتم العثور على الفاتورة',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseDetails() {
    if (_purchase == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Purchase header card
          _buildPurchaseHeader(),
          const SizedBox(height: 16),

          // Items section
          _buildItemsSection(),
          const SizedBox(height: 16),

          // Payments section
          _buildPaymentsSection(),
          const SizedBox(height: 16),

          // Summary section
          _buildSummarySection(),
        ],
      ),
    );
  }

  Widget _buildPurchaseHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فاتورة رقم: ${_purchase!.invoiceNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'المورد: ${_purchase!.supplierName ?? 'غير محدد'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'الهاتف: ${_purchase!.supplierPhone ?? 'غير محدد'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_purchase!.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _purchase!.status.displayName,
                    style: TextStyle(
                      color: _getStatusColor(_purchase!.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ الفاتورة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy/MM/dd').format(_purchase!.invoiceDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نوع الفاتورة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        _purchase!.type.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_purchase!.notes != null && _purchase!.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'الملاحظات: ${_purchase!.notes}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المنتجات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _items.isEmpty
                ? const Center(
                    child: Text('لا توجد منتجات في هذه الفاتورة'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _buildItemRow(item);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(PurchaseItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'الكود: ${item.productCode}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${item.quantity} ${item.unit ?? 'قطعة'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${item.costPrice.toStringAsFixed(2)} ريال',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${item.totalAmount.toStringAsFixed(2)} ريال',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المدفوعات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _payments.isEmpty
                ? const Center(
                    child: Text('لا توجد مدفوعات مسجلة'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _payments.length,
                    itemBuilder: (context, index) {
                      final payment = _payments[index];
                      return _buildPaymentRow(payment);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(Payment payment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.method.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('yyyy/MM/dd').format(payment.paymentDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${payment.amount.toStringAsFixed(2)} ريال',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    if (_purchase == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'ملخص الفاتورة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow('المجموع الفرعي', '${_purchase!.subtotal.toStringAsFixed(2)} ريال'),
            _buildSummaryRow('الخصم', '${_purchase!.discount.toStringAsFixed(2)} ريال'),
            _buildSummaryRow('الضريبة', '${_purchase!.tax.toStringAsFixed(2)} ريال'),
            const Divider(),
            _buildSummaryRow('الإجمالي', '${_purchase!.total.toStringAsFixed(2)} ريال', isTotal: true),
            _buildSummaryRow('المدفوع', '${_purchase!.paidAmount.toStringAsFixed(2)} ريال'),
            _buildSummaryRow(
              'المتبقي',
              '${_purchase!.dueAmount.toStringAsFixed(2)} ريال',
              isTotal: _purchase!.dueAmount > 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? const Color(0xFF4CAF50) : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.draft:
        return Colors.grey;
      case PurchaseStatus.pending:
        return Colors.orange;
      case PurchaseStatus.approved:
        return Colors.blue;
      case PurchaseStatus.completed:
        return Colors.green;
      case PurchaseStatus.cancelled:
        return Colors.red;
    }
  }

  void _editPurchase() {
    // TODO: Navigate to edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تعديل الفاتورة قيد التطوير')),
    );
  }

  void _printPurchase() {
    // TODO: Implement PDF printing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('طباعة الفاتورة قيد التطوير')),
    );
  }

  void _addPayment() {
    // TODO: Navigate to add payment screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('إضافة دفعة قيد التطوير')),
    );
  }
}
