import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashier_pos/core/widgets/error_widget.dart';
import 'package:cashier_pos/core/widgets/loading_widget.dart';
import 'package:cashier_pos/features/category/presentation/bloc/category_bloc.dart';
import 'package:cashier_pos/features/category/presentation/widgets/category_list.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Load categories when the screen initializes
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add category screen
              // Navigator.pushNamed(context, '/categories/add');
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const LoadingWidget();
          } else if (state is CategoriesLoaded) {
            return CategoryList(categories: state.categories);
          } else if (state is CategoryError) {
            return AppErrorWidget(message: state.message);
          } else {
            return const Center(child: Text('No categories found'));
          }
        },
      ),
    );
  }
}
