import 'package:flutter/material.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_item.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({Key? key}) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _barcodeController = TextEditingController();
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _discountController = TextEditingController(text: '0.00');
  final _taxController = TextEditingController(text: '0.00');

  String? _selectedProductId;
  String? _selectedProductName;
  String? _selectedProductCode;

  @override
  void dispose() {
    _barcodeController.dispose();
    _searchController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _scanBarcode() async {
    // TODO: Implement barcode scanning
    // For now, we'll just simulate a barcode scan
    _barcodeController.text = '123456789012';
    _onBarcodeScanned('123456789012');
  }

  void _onBarcodeScanned(String barcode) {
    // TODO: Look up product by barcode
    // For now, we'll just simulate a product lookup
    setState(() {
      _selectedProductId = 'p123';
      _selectedProductName = 'Sample Product';
      _selectedProductCode = 'SP001';
      _priceController.text = '19.99';
    });
  }

  void _onProductSelected(Map<String, dynamic> product) {
    setState(() {
      _selectedProductId = product['id'];
      _selectedProductName = product['name'];
      _selectedProductCode = product['code'];
      _priceController.text = product['price'].toString();
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedProductId != null) {
      final item = SaleItem(
        productId: _selectedProductId!,
        productName: _selectedProductName!,
        productCode: _selectedProductCode!,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        discount: double.parse(_discountController.text),
        tax: double.parse(_taxController.text),
      );
      
      Navigator.of(context).pop(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barcode Scanner
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: 'Barcode',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.qr_code_scanner),
                      ),
                      onChanged: (value) {
                        if (value.length >= 8) {
                          _onBarcodeScanned(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _scanBarcode,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              
              // Product Search
              TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Product',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // TODO: Implement product search
                },
              ),
              
              // Selected Product
              if (_selectedProductName != null) ...[
                const SizedBox(height: 16.0),
                Card(
                  child: ListTile(
                    title: Text(_selectedProductName ?? ''),
                    subtitle: Text('Code: ${_selectedProductCode ?? ''}'),
                    trailing: Text('\$${_priceController.text}'),
                  ),
                ),
              ],
              
              const SizedBox(height: 16.0),
              
              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12.0),
              
              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12.0),
              
              // Discount
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(
                  labelText: 'Discount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final discount = double.tryParse(value);
                    if (discount == null || discount < 0) {
                      return 'Please enter a valid discount';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12.0),
              
              // Tax
              TextFormField(
                controller: _taxController,
                decoration: const InputDecoration(
                  labelText: 'Tax',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final tax = double.tryParse(value);
                    if (tax == null || tax < 0) {
                      return 'Please enter a valid tax amount';
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _selectedProductId != null ? _submit : null,
          child: const Text('ADD'),
        ),
      ],
    );
  }
}
