import 'package:flutter/material.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;

  const CategoryList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'No categories found. Tap + to add a new category.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.category),
          ),
          title: Text(
            category.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  // Navigate to edit category screen
                  // Navigator.pushNamed(
                  //   context,
                  //   '/categories/edit',
                  //   arguments: category,
                  // );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(context, category);
                },
              ),
            ],
          ),
          onTap: () {
            // Navigate to category details or products in category
            // Navigator.pushNamed(
            //   context,
            //   '/categories/${category.id}',
            //   arguments: category,
            // );
          },
        );
      },
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete ${category.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Delete the category
      // context.read<CategoryBloc>().add(DeleteCategoryEvent(category.id!));
      
      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
