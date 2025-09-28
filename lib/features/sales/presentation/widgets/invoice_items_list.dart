import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_item.dart';

class InvoiceItemsList extends StatelessWidget {
  final List<SaleItem> items;

  const InvoiceItemsList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        final total = (item.price * item.quantity) - item.discount + item.tax;
        
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
          title: Text(
            item.productName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item.quantity} x ${currencyFormat.format(item.price)}'),
              if (item.discount > 0) ...[
                const SizedBox(height: 2.0),
                Text(
                  'Discount: -${currencyFormat.format(item.discount)}',
                  style: const TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ],
              if (item.tax > 0) ...[
                const SizedBox(height: 2.0),
                Text(
                  'Tax: ${currencyFormat.format(item.tax)}',
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ],
          ),
          trailing: Text(
            currencyFormat.format(total),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
