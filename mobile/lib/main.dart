import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/product_bloc.dart';
import 'bloc/recipe_bloc.dart';
import 'repositories/product_repository.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/user_repository.dart';
import 'screens/product_list.dart';
import 'screens/recipe_list.dart';

void main() {
  runApp(const RecipeFridgeApp());
}

class RecipeFridgeApp extends StatelessWidget {
  const RecipeFridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => ProductRepository()),
        RepositoryProvider(create: (_) => RecipeRepository()),
        RepositoryProvider(create: (_) => UserRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProductBloc(context.read<ProductRepository>())..add(LoadProductsEvent())),
          BlocProvider(create: (context) => RecipeBloc(context.read<RecipeRepository>())..add(LoadRecipesEvent())),
        ],
        child: MaterialApp(
          title: 'Recipe Fridge',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const ProductListScreen(), const RecipeListScreen()];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recipes'),
        ],
      ),
    );
  }
}
