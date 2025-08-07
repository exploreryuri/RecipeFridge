import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Fridge')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final p = state.products[index];
              return ListTile(
                title: Text(p.name),
                subtitle: Text('Expires: ' + (p.expiresAt?.toLocal().toString() ?? 'Unknown')),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ProductBloc>().add(AddProductEvent('Apple', 1, DateTime.now().add(const Duration(days: 3))));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
