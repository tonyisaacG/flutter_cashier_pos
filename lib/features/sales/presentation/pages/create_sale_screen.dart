import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_bloc.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/sale_item_list.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/payment_section.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_item.dart';

import '../bloc/sale_event.dart';
import '../bloc/sale_state.dart';

class CreateSaleScreen extends StatefulWidget {
  const CreateSaleScreen({Key? key}) : super(key: key);

  @override
  _CreateSaleScreenState createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<SaleItem> _items = [];
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _total = 0.0;
  double _paidAmount = 0.0;
  double _dueAmount = 0.0;
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateTotals() {
    setState(() {
      _subtotal = _items.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );
      _total = _subtotal - _discount + _tax;
      _dueAmount = _total - _paidAmount;
    });
  }

  void _onItemAdded(SaleItem item) {
    setState(() {
      final existingItemIndex = _items.indexWhere(
        (i) => i.productId == item.productId,
      );
      if (existingItemIndex >= 0) {
        // Update quantity if item already exists
        final existingItem = _items[existingItemIndex];
        _items[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
      } else {
        _items.add(item);
      }
      _updateTotals();
    });
  }

  void _onItemUpdated(int index, SaleItem item) {
    setState(() {
      _items[index] = item;
      _updateTotals();
    });
  }

  void _onItemRemoved(int index) {
    setState(() {
      _items.removeAt(index);
      _updateTotals();
    });
  }

  void _onDiscountChanged(double value) {
    setState(() {
      _discount = value;
      _updateTotals();
    });
  }

  void _onTaxChanged(double value) {
    setState(() {
      _tax = value;
      _updateTotals();
    });
  }

  void _onPaidAmountChanged(double value) {
    setState(() {
      _paidAmount = value;
      _dueAmount = _total - _paidAmount;
    });
  }

  Future<void> _submitForm() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final invoice = SaleInvoice(
        invoiceNumber: '', // Will be generated automatically by the repository
        invoiceDate: DateTime.now(),
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        items: _items,
        payments: [], // Empty list for new invoices
        subtotal: _subtotal,
        discount: _discount,
        tax: _tax,
        total: _total,
        paidAmount: _paidAmount,
        dueAmount: _dueAmount,
        status: _dueAmount <= 0 ? InvoiceStatus.completed : InvoiceStatus.draft,
        type: InvoiceType.sale,
        notes: _notesController.text,
        createdBy: 'current_user_id', // Replace with actual user ID
        createdAt: DateTime.now(),
      );

      context.read<SaleBloc>().add(CreateSale(invoice));

      // Listen for the response
      final response = await context.read<SaleBloc>().stream.firstWhere(
        (state) => state is SaleCreated || state is SaleError,
      );

      if (mounted) {
        if (response is SaleCreated) {
          Navigator.of(context).pop(true); // Return success
        } else if (response is SaleError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _submitForm),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Customer Information
            _buildCustomerSection(),

            // Items List
            Expanded(
              child: SaleItemList(
                items: _items,
                onItemAdded: _onItemAdded,
                onItemUpdated: _onItemUpdated,
                onItemRemoved: _onItemRemoved,
              ),
            ),

            // Totals and Payment
            PaymentSection(
              subtotal: _subtotal,
              discount: _discount,
              tax: _tax,
              total: _total,
              paidAmount: _paidAmount,
              dueAmount: _dueAmount,
              onDiscountChanged: _onDiscountChanged,
              onTaxChanged: _onTaxChanged,
              onPaidAmountChanged: _onPaidAmountChanged,
            ),

            // Notes
            _buildNotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _notesController,
        decoration: const InputDecoration(
          labelText: 'Notes (Optional)',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        maxLines: 2,
      ),
    );
  }
}
