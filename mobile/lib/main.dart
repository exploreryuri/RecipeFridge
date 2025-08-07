import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/product_bloc.dart';
import 'repositories/product_repository.dart';
import 'screens/product_list.dart';

void main() {
  runApp(const RecipeFridgeApp());
}

class RecipeFridgeApp extends StatelessWidget {
  const RecipeFridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ProductRepository(),
      child: BlocProvider(
        create: (context) => ProductBloc(context.read<ProductRepository>())..add(LoadProductsEvent()),
        child: MaterialApp(
          title: 'Recipe Fridge',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const ProductListScreen(),
        ),
      ),
    );
  }
}
