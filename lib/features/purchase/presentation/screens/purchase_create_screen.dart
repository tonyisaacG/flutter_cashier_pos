import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/entities/purchase_item.dart';
import '../../domain/entities/supplier.dart';

class PurchaseCreateScreen extends StatefulWidget {
  const PurchaseCreateScreen({super.key});

  @override
  State<PurchaseCreateScreen> createState() => _PurchaseCreateScreenState();
}

class _PurchaseCreateScreenState extends State<PurchaseCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberController = TextEditingController();
  final _supplierNameController = TextEditingController();
  final _supplierPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  PurchaseType _selectedType = PurchaseType.cash;
  PurchaseStatus _selectedStatus = PurchaseStatus.draft;

  List<PurchaseItem> _items = [];
  bool _isLoading = false;

  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _generateInvoiceNumber();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    final invoiceNumber = 'PUR-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(8)}';
    _invoiceNumberController.text = invoiceNumber;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/purchases/create',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء فاتورة شراء جديدة'),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _savePurchase,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('حفظ'),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purchase header info
                _buildPurchaseHeader(),
                const SizedBox(height: 24),

                // Products section
                _buildProductsSection(),
                const SizedBox(height: 24),

                // Summary section
                _buildSummarySection(),
              ],
            ),
          ),
        ),
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
            const Text(
              'معلومات الفاتورة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _invoiceNumberController,
                    decoration: const InputDecoration(
                      labelText: 'رقم الفاتورة',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(DateFormat('yyyy/MM/dd').format(_selectedDate)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _supplierNameController,
              decoration: const InputDecoration(
                labelText: 'اسم المورد',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'اسم المورد مطلوب';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _supplierPhoneController,
              decoration: const InputDecoration(
                labelText: 'هاتف المورد',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<PurchaseType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'نوع الفاتورة',
                      border: OutlineInputBorder(),
                    ),
                    items: PurchaseType.values.map((type) {
                      return DropdownMenuItem<PurchaseType>(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<PurchaseStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'الحالة',
                      border: OutlineInputBorder(),
                    ),
                    items: PurchaseStatus.values.map((status) {
                      return DropdownMenuItem<PurchaseStatus>(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'ملاحظات',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
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
                  'المنتجات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _scanProduct,
                      icon: const Icon(Icons.qr_code_scanner),
                      tooltip: 'مسح الباركود',
                    ),
                    IconButton(
                      onPressed: _searchProduct,
                      icon: const Icon(Icons.search),
                      tooltip: 'البحث عن منتج',
                    ),
                    IconButton(
                      onPressed: _addProductManually,
                      icon: const Icon(Icons.add),
                      tooltip: 'إضافة منتج يدوياً',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _items.isEmpty
                ? _buildEmptyProducts()
                : _buildProductsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد منتجات مضافة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'استخدم الأزرار أعلاه لإضافة منتجات',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildProductItem(item, index);
      },
    );
  }

  Widget _buildProductItem(PurchaseItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'الكود: ${item.productCode}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${item.costPrice.toStringAsFixed(2)} ريال × ${item.quantity} = ${(item.costPrice * item.quantity).toStringAsFixed(2)} ريال',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _editProductItem(index),
                icon: const Icon(Icons.edit, size: 20),
              ),
              IconButton(
                onPressed: () => _removeProductItem(index),
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    double subtotal = 0;
    for (final item in _items) {
      subtotal += item.costPrice * item.quantity;
    }

    double discountAmount = subtotal * 0.0; // TODO: Get from form
    double taxAmount = (subtotal - discountAmount) * 0.15; // 15% tax
    double total = subtotal - discountAmount + taxAmount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'ملخص الفاتورة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('المجموع الفرعي', '${subtotal.toStringAsFixed(2)} ريال'),
            _buildSummaryRow('الخصم', '${discountAmount.toStringAsFixed(2)} ريال'),
            _buildSummaryRow('الضريبة (15%)', '${taxAmount.toStringAsFixed(2)} ريال'),
            const Divider(),
            _buildSummaryRow(
              'الإجمالي',
              '${total.toStringAsFixed(2)} ريال',
              isTotal: true,
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _scanProduct() {
    // TODO: Implement barcode scanning
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة مسح الباركود قيد التطوير')),
    );
  }

  void _searchProduct() {
    // TODO: Implement product search
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة البحث عن المنتجات قيد التطوير')),
    );
  }

  void _addProductManually() {
    // TODO: Implement manual product addition
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة إضافة المنتج يدوياً قيد التطوير')),
    );
  }

  void _editProductItem(int index) {
    // TODO: Implement product item editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تعديل المنتج رقم ${index + 1} قيد التطوير')),
    );
  }

  void _removeProductItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _savePurchase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب إضافة منتج واحد على الأقل')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Calculate totals
      double subtotal = 0;
      for (final item in _items) {
        subtotal += item.costPrice * item.quantity;
      }

      double discountAmount = subtotal * 0.0; // TODO: Get discount from form
      double taxAmount = (subtotal - discountAmount) * 0.15; // 15% tax
      double total = subtotal - discountAmount + taxAmount;

      // Create purchase
      final purchase = Purchase(
        id: _uuid.v4(),
        invoiceNumber: _invoiceNumberController.text,
        invoiceDate: _selectedDate,
        supplierName: _supplierNameController.text,
        supplierPhone: _supplierPhoneController.text,
        subtotal: subtotal,
        discount: 0.0, // TODO: Get from form
        tax: 15.0, // 15% tax
        total: total,
        paidAmount: _selectedType == PurchaseType.cash ? total : 0.0,
        dueAmount: _selectedType == PurchaseType.cash ? 0.0 : total,
        status: _selectedStatus,
        type: _selectedType,
        notes: _notesController.text,
        createdAt: DateTime.now(),
      );

      // TODO: Save to database using use case
      // final repository = PurchaseRepositoryImpl(PurchaseLocalDataSourceImpl(DatabaseHelper.instance));
      // final createPurchase = CreatePurchase(repository);
      // await createPurchase(purchase, _items);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الفاتورة بنجاح')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في حفظ الفاتورة: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _supplierNameController.dispose();
    _supplierPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
