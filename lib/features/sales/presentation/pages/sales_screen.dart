import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_bloc.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_event.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_state.dart';
import 'package:cashier_pos/features/sales/sales_module.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/sale_list.dart';
import 'package:cashier_pos/features/sales/presentation/widgets/sale_filters.dart';
import 'package:cashier_pos/features/sales/presentation/pages/create_sale_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _scrollController = ScrollController();
  final _filters = <String, dynamic>{
    'startDate': DateTime.now().subtract(const Duration(days: 30)),
    'endDate': DateTime.now(),
    'status': null,
    'type': null,
  };

  @override
  void initState() {
    super.initState();
    _loadInitialSales();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialSales() {
    context.read<SaleBloc>().add(
      LoadInvoices(
        startDate: _filters['startDate'] as DateTime?,
        endDate: _filters['endDate'] as DateTime?,
        status: _filters['status'] as String?,
        type: _filters['type'] as String?,
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<SaleBloc>().state;
      if (state is InvoicesLoaded && !state.hasReachedMax) {
        context.read<SaleBloc>().add(
          LoadInvoices(
            startDate: _filters['startDate'] as DateTime?,
            endDate: _filters['endDate'] as DateTime?,
            status: _filters['status'] as String?,
            type: _filters['type'] as String?,
            page: (state.invoices.length ~/ 20) + 1,
          ),
        );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onFiltersChanged(Map<String, dynamic> newFilters) {
    setState(() {
      _filters['startDate'] = newFilters['startDate'] as DateTime?;
      _filters['endDate'] = newFilters['endDate'] as DateTime?;
      _filters['status'] = newFilters['status'] as String?;
      _filters['type'] = newFilters['type'] as String?;
    });
    context.read<SaleBloc>().add(
      LoadInvoices(
        startDate: _filters['startDate'] as DateTime?,
        endDate: _filters['endDate'] as DateTime?,
        status: _filters['status'] as String?,
        type: _filters['type'] as String?,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // TODO: Implement export to Excel
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SaleFilters(
            initialFilters: _filters,
            onFiltersChanged: _onFiltersChanged,
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocConsumer<SaleBloc, SaleState>(
              listener: (context, state) {
                if (state is SaleError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is SaleLoading && state is! InvoicesLoaded) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is InvoicesLoaded) {
                  if (state.invoices.isEmpty) {
                    return const Center(child: Text('No sales found'));
                  }
                  return SaleList(
                    invoices: state.invoices,
                    scrollController: _scrollController,
                    hasReachedMax: state.hasReachedMax,
                  );
                } else if (state is SaleError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No data'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SalesModule(
                child: CreateSaleScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: const _CustomFabLocation(),
    );
  }
}

/// Custom FAB location that positions the button above the bottom navigation bar
class _CustomFabLocation extends FloatingActionButtonLocation {
  const _CustomFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Get the default end float offset
    final Offset defaultOffset = FloatingActionButtonLocation.endFloat.getOffset(scaffoldGeometry);

    // Move the FAB up by 90 pixels to avoid the bottom navigation bar (72px height + some padding)
    return Offset(defaultOffset.dx, defaultOffset.dy - 90);
  }
}
