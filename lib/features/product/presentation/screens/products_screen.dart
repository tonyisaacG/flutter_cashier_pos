import 'package:flutter/material.dart';

import '../../../../core/widgets/app_layout.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load products from repository
      // In a real implementation, this would call the product repository
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/products',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المنتجات'),
          actions: [
            IconButton(
              onPressed: _scanProduct,
              icon: const Icon(Icons.qr_code_scanner),
              tooltip: 'مسح منتج',
            ),
            IconButton(
              onPressed: _addProduct,
              icon: const Icon(Icons.add),
              tooltip: 'إضافة منتج',
            ),
          ],
        ),
        body: Column(
          children: [
            // Search section
            _buildSearchSection(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildProductsList(),
            ),
          ],
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
          hintText: 'البحث في المنتجات...',
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
          _loadProducts();
        },
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // TODO: Replace with actual product count
      itemBuilder: (context, index) {
        return _buildProductCard(index);
      },
    );
  }

  Widget _buildProductCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToProductDetail(index),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2,
                  size: 30,
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
                    const SizedBox(height: 4),
                    Text(
                      'الكمية: ${index * 10} قطعة', // TODO: Replace with actual quantity
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Product price and actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(index + 1) * 50}.00 ريال', // TODO: Replace with actual price
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _editProduct(index),
                        icon: const Icon(Icons.edit, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _deleteProduct(index),
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scanProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('مسح المنتج قيد التطوير')),
    );
  }

  void _addProduct() {
    Navigator.of(context).pushNamed('/products/add');
  }

  void _editProduct(int index) {
    Navigator.of(context).pushNamed('/products/edit', arguments: index);
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text('هل أنت متأكد من حذف منتج ${index + 1}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المنتج')),
              );
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(int index) {
    Navigator.of(context).pushNamed('/products/detail', arguments: index);
  }
}
