import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/usecases/get_all_purchases.dart';

class PurchaseListScreen extends StatefulWidget {
  const PurchaseListScreen({super.key});

  @override
  State<PurchaseListScreen> createState() => _PurchaseListScreenState();
}

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  late GetAllPurchases _getAllPurchases;
  List<Purchase> _purchases = [];
  bool _isLoading = true;
  String _searchQuery = '';
  PurchaseStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real implementation, this would come from dependency injection
      // For now, we'll create a placeholder
      _purchases = [];

      // TODO: Initialize use case with repository
      // final repository = PurchaseRepositoryImpl(PurchaseLocalDataSourceImpl(DatabaseHelper.instance));
      // _getAllPurchases = GetAllPurchases(repository);
      // _purchases = await _getAllPurchases(
      //   searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      //   status: _selectedStatus,
      // );
    } catch (e) {
      // Handle error
      debugPrint('Error loading purchases: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/purchases',
      child: Scaffold(
        body: Column(
          children: [
            // Search and filter section
            _buildSearchAndFilter(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _purchases.isEmpty
                      ? _buildEmptyState()
                      : _buildPurchaseList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToCreatePurchase,
          backgroundColor: const Color(0xFF4CAF50),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
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
      child: Column(
        children: [
          // Search field
          TextField(
            decoration: InputDecoration(
              hintText: 'البحث في فواتير الشراء...',
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
              _loadPurchases();
            },
          ),
          const SizedBox(height: 12),
          // Status filter
          Row(
            children: [
              const Text('الحالة: '),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<PurchaseStatus?>(
                  value: _selectedStatus,
                  hint: const Text('جميع الحالات'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<PurchaseStatus?>(
                      value: null,
                      child: Text('جميع الحالات'),
                    ),
                    ...PurchaseStatus.values.map((status) {
                      return DropdownMenuItem<PurchaseStatus>(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    _loadPurchases();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _purchases.length,
      itemBuilder: (context, index) {
        final purchase = _purchases[index];
        return _buildPurchaseCard(purchase);
      },
    );
  }

  Widget _buildPurchaseCard(Purchase purchase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToPurchaseDetail(purchase.id),
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
                          purchase.invoiceNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          purchase.supplierName ?? 'مورد غير محدد',
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
                        '${purchase.total.toStringAsFixed(2)} ريال',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(purchase.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          purchase.status.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(purchase.status),
                            fontWeight: FontWeight.w500,
                          ),
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
                    DateFormat('yyyy/MM/dd').format(purchase.invoiceDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'مدفوع: ${purchase.paidAmount.toStringAsFixed(2)} ريال',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'متبقي: ${purchase.dueAmount.toStringAsFixed(2)} ريال',
                    style: TextStyle(
                      fontSize: 12,
                      color: purchase.dueAmount > 0 ? Colors.red : Colors.green,
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
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد فواتير شراء',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على الزر أدناه لإنشاء فاتورة شراء جديدة',
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

  void _navigateToCreatePurchase() {
    Navigator.of(context).pushNamed('/purchases/create');
  }

  void _navigateToPurchaseDetail(String purchaseId) {
    Navigator.of(context).pushNamed('/purchases/detail', arguments: purchaseId);
  }
}
