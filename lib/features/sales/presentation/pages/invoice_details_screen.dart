import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_bloc.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/payment_history.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/invoice_items_list.dart';

import '../bloc/sale_event.dart';
import '../bloc/sale_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class InvoiceDetailsScreen extends StatelessWidget {
  final String invoiceId;

  const InvoiceDetailsScreen({Key? key, required this.invoiceId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // TODO: Generate PDF
              context.read<SaleBloc>().add(GenerateInvoicePdf(invoiceId));
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: Print invoice
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'return') {
                // TODO: Handle return
              } else if (value == 'cancel') {
                // TODO: Handle cancel
              } else if (value == 'delete') {
                // TODO: Handle delete
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'return',
                child: Text('Create Return'),
              ),
              const PopupMenuItem(
                value: 'cancel',
                child: Text('Cancel Invoice'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Invoice'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<SaleBloc, SaleState>(
        builder: (context, state) {
          if (state is SaleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InvoiceLoaded && state.invoice.id == invoiceId) {
            return _buildInvoiceDetails(context, state.invoice);
          } else if (state is SaleError) {
            return Center(child: Text(state.message));
          } else {
            // Load invoice if not already loaded
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<SaleBloc>().add(GetInvoice(invoiceId));
            });
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildInvoiceDetails(BuildContext context, SaleInvoice invoice) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );

    final dateFormat = DateFormat('MMM d, y hh:mm a');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice #${invoice.invoiceNumber}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    dateFormat.format(invoice.invoiceDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(invoice.status.name),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  invoice.status.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 32.0),

          // Customer Info
          Text('CUSTOMER', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8.0),
          Text(
            invoice.customerName ?? 'Walk-in Customer',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (invoice.customerPhone != null) ...[
            const SizedBox(height: 4.0),
            Text(
              invoice.customerPhone!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],

          const SizedBox(height: 24.0),

          // Items
          Text('ITEMS', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8.0),
          InvoiceItemsList(items: invoice.items),

          // Totals
          const SizedBox(height: 16.0),
          _buildTotalRow('Subtotal', invoice.subtotal, currencyFormat),
          _buildTotalRow('Discount', -invoice.discount, currencyFormat),
          _buildTotalRow('Tax', invoice.tax, currencyFormat),
          const Divider(height: 24.0),
          _buildTotalRow(
            'TOTAL',
            invoice.total,
            currencyFormat,
            isBold: true,
            isTotal: true,
          ),

          // Payment Status
          const SizedBox(height: 24.0),
          Text('PAYMENT STATUS', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: _buildPaymentStatusItem(
                  'Paid',
                  currencyFormat.format(invoice.paidAmount),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildPaymentStatusItem(
                  'Due',
                  currencyFormat.format(invoice.dueAmount),
                  invoice.dueAmount > 0 ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),

          // Payment History
          const SizedBox(height: 24.0),
          PaymentHistory(payments: invoice.payments),

          // Notes
          if (invoice.notes?.isNotEmpty ?? false) ...[
            const SizedBox(height: 24.0),
            Text('NOTES', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8.0),
            Text(invoice.notes!),
          ],

          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount,
    NumberFormat currencyFormat, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          Text(
            amount >= 0
                ? currencyFormat.format(amount)
                : '-${currencyFormat.format(amount.abs())}',
            style: isBold
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusItem(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
          const SizedBox(height: 4.0),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'partially_paid':
        return Colors.blue;
      case 'returned':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
