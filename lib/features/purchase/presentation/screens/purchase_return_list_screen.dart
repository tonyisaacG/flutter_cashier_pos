import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../domain/entities/purchase_return.dart';

class PurchaseReturnListScreen extends StatefulWidget {
  const PurchaseReturnListScreen({super.key});

  @override
  State<PurchaseReturnListScreen> createState() => _PurchaseReturnListScreenState();
}

class _PurchaseReturnListScreenState extends State<PurchaseReturnListScreen> {
  List<PurchaseReturn> _returns = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPurchaseReturns();
  }

  Future<void> _loadPurchaseReturns() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load purchase returns from repository
      // In a real implementation, this would call the repository
      _returns = [];
    } catch (e) {
      debugPrint('Error loading purchase returns: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/purchase-return-list',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة فواتير المرتجعات'),
        ),
        body: Column(
          children: [
            // Search section
            _buildSearchSection(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _returns.isEmpty
                      ? _buildEmptyState()
                      : _buildReturnsList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createReturnInvoice,
          backgroundColor: const Color(0xFF4CAF50),
          child: const Icon(Icons.add, color: Colors.white),
          tooltip: 'إنشاء فاتورة مرتجع',
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'البحث في فواتير المرتجعات...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _loadPurchaseReturns();
        },
      ),
    );
  }

  Widget _buildReturnsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _returns.length,
      itemBuilder: (context, index) {
        final returnInvoice = _returns[index];
        return _buildReturnCard(returnInvoice);
      },
    );
  }

  Widget _buildReturnCard(PurchaseReturn returnInvoice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToReturnDetail(returnInvoice.id),
        borderRadius: BorderRadius.circular(8),
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
                          returnInvoice.returnNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          returnInvoice.supplierName ?? 'مورد غير محدد',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${returnInvoice.totalAmount.toStringAsFixed(2)} ريال',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        returnInvoice.reason ?? 'بدون سبب',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('yyyy/MM/dd').format(returnInvoice.returnDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'رقم الفاتورة الأصلية: ${returnInvoice.purchaseInvoiceId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
            Icons.assignment_return_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد فواتير مرتجعات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على الزر أدناه لإنشاء فاتورة مرتجع جديدة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _createReturnInvoice() {
    Navigator.of(context).pushNamed('/purchase-returns/create');
  }

  void _navigateToReturnDetail(String returnId) {
    Navigator.of(context).pushNamed('/purchase-returns/detail', arguments: returnId);
  }
}
