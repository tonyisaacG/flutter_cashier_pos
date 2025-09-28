import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'presentation/bloc/sale_bloc.dart';

class SalesModule extends StatelessWidget {
  final Widget child;

  const SalesModule({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaleBloc>(
          create: (context) => GetIt.I<SaleBloc>(),
        ),
      ],
      child: child,
    );
  }
}
