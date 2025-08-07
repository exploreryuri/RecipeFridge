import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/recipe_repository.dart';
import '../models/recipe.dart';

abstract class RecipeEvent {}

class LoadRecipesEvent extends RecipeEvent {}

class AddRecipeEvent extends RecipeEvent {
  final String name;
  final String? description;
  AddRecipeEvent(this.name, this.description);
}

class RecipeState {
  final List<Recipe> recipes;
  final bool loading;
  RecipeState({required this.recipes, this.loading = false});
}

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;
  RecipeBloc(this.repository) : super(RecipeState(recipes: [])) {
    on<LoadRecipesEvent>(_onLoad);
    on<AddRecipeEvent>(_onAdd);
  }

  Future<void> _onLoad(LoadRecipesEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeState(recipes: state.recipes, loading: true));
    final recipes = await repository.fetchRecipes();
    emit(RecipeState(recipes: recipes));
  }

  Future<void> _onAdd(AddRecipeEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeState(recipes: state.recipes, loading: true));
    await repository.addRecipe(event.name, event.description);
    add(LoadRecipesEvent());
  }
}
