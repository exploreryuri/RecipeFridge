import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: state.recipes.length,
            itemBuilder: (context, index) {
              final r = state.recipes[index];
              return ListTile(
                title: Text(r.name),
                subtitle: Text(r.description ?? ''),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<RecipeBloc>().add(AddRecipeEvent('Soup', 'Tasty soup'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
