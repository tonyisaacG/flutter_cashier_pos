import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';

class SaleList extends StatelessWidget {
  final List<SaleInvoice> invoices;
  final ScrollController scrollController;
  final bool hasReachedMax;

  const SaleList({
    Key? key,
    required this.invoices,
    required this.scrollController,
    required this.hasReachedMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );

    final dateFormat = DateFormat('MMM d, y hh:mm a');

    return ListView.builder(
      controller: scrollController,
      itemCount: hasReachedMax ? invoices.length : invoices.length + 1,
      itemBuilder: (context, index) {
        if (index >= invoices.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final invoice = invoices[index];
        final isReturn = invoice.type == 'return';
        final status = invoice.status.toString().split('.').last;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${invoice.invoiceNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(invoice.total),
                  style: TextStyle(
                    color: isReturn ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                Text(
                  invoice.customerName ?? 'Walk-in Customer',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateFormat.format(invoice.invoiceDate)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              // TODO: Navigate to invoice details
            },
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
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
