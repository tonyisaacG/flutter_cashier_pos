import 'package:flutter/material.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_item.dart';

class SaleItemCard extends StatefulWidget {
  final SaleItem item;
  final Function(SaleItem) onUpdated;
  final VoidCallback onRemoved;

  const SaleItemCard({
    Key? key,
    required this.item,
    required this.onUpdated,
    required this.onRemoved,
  }) : super(key: key);

  @override
  _SaleItemCardState createState() => _SaleItemCardState();
}

class _SaleItemCardState extends State<SaleItemCard> {
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _taxController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
    _priceController = TextEditingController(text: widget.item.price.toStringAsFixed(2));
    _discountController = TextEditingController(text: widget.item.discount.toStringAsFixed(2));
    _taxController = TextEditingController(text: widget.item.tax.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _updateItem() {
    final updatedItem = widget.item.copyWith(
      quantity: int.tryParse(_quantityController.text) ?? widget.item.quantity,
      price: double.tryParse(_priceController.text) ?? widget.item.price,
      discount: double.tryParse(_discountController.text) ?? widget.item.discount,
      tax: double.tryParse(_taxController.text) ?? widget.item.tax,
    );
    widget.onUpdated(updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.item.price * widget.item.quantity - widget.item.discount + widget.item.tax;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: widget.onRemoved,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Qty',
                    controller: _quantityController,
                    onChanged: (_) => _updateItem(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildTextField(
                    label: 'Price',
                    controller: _priceController,
                    onChanged: (_) => _updateItem(),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Discount',
                    controller: _discountController,
                    onChanged: (_) => _updateItem(),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildTextField(
                    label: 'Tax',
                    controller: _taxController,
                    onChanged: (_) => _updateItem(),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const Divider(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Total:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
