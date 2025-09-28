import 'package:flutter/material.dart';

import '../../../../core/widgets/app_layout.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load inventory from repository
      // In a real implementation, this would call the inventory repository
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      debugPrint('Error loading inventory: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/inventory',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المخزون'),
          actions: [
            IconButton(
              onPressed: _adjustStock,
              icon: const Icon(Icons.tune),
              tooltip: 'تعديل المخزون',
            ),
            IconButton(
              onPressed: _exportInventory,
              icon: const Icon(Icons.download),
              tooltip: 'تصدير المخزون',
            ),
          ],
        ),
        body: Column(
          children: [
            // Search and filter section
            _buildSearchAndFilter(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildInventoryList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addInventoryMovement,
          backgroundColor: const Color(0xFF4CAF50),
          child: const Icon(Icons.add, color: Colors.white),
          tooltip: 'إضافة حركة مخزون',
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
              hintText: 'البحث في المخزون...',
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
              _loadInventory();
            },
          ),
          const SizedBox(height: 12),

          // Filter buttons
          Row(
            children: [
              _buildFilterButton('الكل', 'all'),
              const SizedBox(width: 8),
              _buildFilterButton('متوفر', 'available'),
              const SizedBox(width: 8),
              _buildFilterButton('منخفض', 'low'),
              const SizedBox(width: 8),
              _buildFilterButton('نفد', 'out'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedFilter = value;
          });
          _loadInventory();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildInventoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // TODO: Replace with actual inventory count
      itemBuilder: (context, index) {
        return _buildInventoryCard(index);
      },
    );
  }

  Widget _buildInventoryCard(int index) {
    final quantity = index * 15;
    final alertQuantity = index * 10;
    final isLowStock = quantity <= alertQuantity;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.inventory_2,
                size: 25,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 16),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'منتج ${index + 1}', // TODO: Replace with actual product name
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الكود: PROD${index + 1}', // TODO: Replace with actual product code
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'الكمية: $quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLowStock ? Colors.red : const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStockStatusColor(isLowStock).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStockStatusText(isLowStock),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStockStatusColor(isLowStock),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStockStatusColor(bool isLowStock) {
    if (isLowStock) {
      return Colors.red;
    }
    return const Color(0xFF4CAF50);
  }

  String _getStockStatusText(bool isLowStock) {
    if (isLowStock) {
      return 'منخفض';
    }
    return 'متوفر';
  }

  void _adjustStock() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تعديل المخزون قيد التطوير')),
    );
  }

  void _exportInventory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تصدير المخزون قيد التطوير')),
    );
  }

  void _addInventoryMovement() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('إضافة حركة مخزون قيد التطوير')),
    );
  }
}
