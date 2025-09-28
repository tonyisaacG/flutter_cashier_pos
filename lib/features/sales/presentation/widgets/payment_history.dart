import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashier_pos/features/sales/domain/entities/payment.dart';

class PaymentHistory extends StatelessWidget {
  final List<Payment> payments;

  const PaymentHistory({Key? key, required this.payments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );

    final dateFormat = DateFormat('MMM d, y hh:mm a');

    if (payments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PAYMENT HISTORY', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8.0),
        ...payments.map((payment) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              leading: _getPaymentMethodIcon(payment.method),
              title: Text(
                _getPaymentMethodLabel(payment.method),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateFormat.format(payment.paymentDate)),
                  if (payment.transactionId != null) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      'TXN: ${payment.transactionId}',
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ],
                  if (payment.notes?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 4.0),
                    Text(
                      payment.notes!,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
              trailing: Text(
                currencyFormat.format(payment.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _getPaymentMethodIcon(PaymentMethod method) {
    IconData icon;
    Color color;

    switch (method) {
      case PaymentMethod.cash:
        icon = Icons.money;
        color = Colors.green;
        break;
      case PaymentMethod.card:
        icon = Icons.credit_card;
        color = Colors.blue;
        break;
      case PaymentMethod.bankTransfer:
        icon = Icons.account_balance;
        color = Colors.purple;
        break;
      case PaymentMethod.wallet:
        icon = Icons.account_balance_wallet;
        color = Colors.orange;
        break;
      default:
        icon = Icons.payment;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24.0),
    );
  }

  String _getPaymentMethodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.wallet:
        return 'Wallet';
      default:
        return 'Other';
    }
  }
}
