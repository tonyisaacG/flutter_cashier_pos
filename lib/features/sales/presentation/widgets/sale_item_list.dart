import 'package:flutter/material.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_item.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/sale_item_card.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/add_item_dialog.dart';

class SaleItemList extends StatelessWidget {
  final List<SaleItem> items;
  final Function(SaleItem) onItemAdded;
  final Function(int, SaleItem) onItemUpdated;
  final Function(int) onItemRemoved;

  const SaleItemList({
    Key? key,
    required this.items,
    required this.onItemAdded,
    required this.onItemUpdated,
    required this.onItemRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await showDialog<SaleItem>(
                    context: context,
                    builder: (context) => const AddItemDialog(),
                  );
                  
                  if (result != null) {
                    onItemAdded(result);
                  }
                },
                icon: const Icon(Icons.add, size: 18.0),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text('No items added yet. Tap "Add Item" to get started.'),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return SaleItemCard(
                      item: item,
                      onUpdated: (updatedItem) {
                        onItemUpdated(index, updatedItem);
                      },
                      onRemoved: () {
                        onItemRemoved(index);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
