import 'package:flutter/material.dart';

class PaymentSection extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double paidAmount;
  final double dueAmount;
  final ValueChanged<double> onDiscountChanged;
  final ValueChanged<double> onTaxChanged;
  final ValueChanged<double> onPaidAmountChanged;

  const PaymentSection({
    Key? key,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paidAmount,
    required this.dueAmount,
    required this.onDiscountChanged,
    required this.onTaxChanged,
    required this.onPaidAmountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', subtotal),
            const SizedBox(height: 8.0),
            _buildEditableRow(
              'Discount',
              discount,
              (value) => onDiscountChanged(value ?? 0),
            ),
            const SizedBox(height: 8.0),
            _buildEditableRow(
              'Tax',
              tax,
              (value) => onTaxChanged(value ?? 0),
            ),
            const Divider(height: 24.0),
            _buildSummaryRow('Total', total, isBold: true),
            const SizedBox(height: 16.0),
            _buildPaymentInput(),
            const SizedBox(height: 8.0),
            _buildSummaryRow('Change/Due', dueAmount.abs(),
                isBold: true, isNegative: dueAmount < 0),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value,
      {bool isBold = false, bool isNegative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isNegative ? Colors.red : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableRow(
      String label, double value, ValueChanged<double?> onChanged) {
    final controller = TextEditingController(text: value.toStringAsFixed(2));
    
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              prefixText: '\$',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              onChanged(double.tryParse(value) ?? 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInput() {
    final controller = TextEditingController(
      text: paidAmount > 0 ? paidAmount.toStringAsFixed(2) : '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            prefixText: '\$',
            hintText: '0.00',
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            onPaidAmountChanged(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: [
            _buildPaymentButton('Exact', total),
            _buildPaymentButton('20', 20.0),
            _buildPaymentButton('50', 50.0),
            _buildPaymentButton('100', 100.0),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentButton(String label, double amount) {
    return OutlinedButton(
      onPressed: () {
        onPaidAmountChanged(amount);
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Text(label),
    );
  }
}
