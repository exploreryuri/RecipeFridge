import '../services/api_service.dart';
import '../models/recipe.dart';

class RecipeRepository {
  final ApiService _api = ApiService();

  Future<List<Recipe>> fetchRecipes() async {
    final data = await _api.get('/recipes');
    return (data as List).map((e) => Recipe.fromJson(e)).toList();
  }

  Future<Recipe> addRecipe(String name, String? description) async {
    final data = await _api.post('/recipes', {
      'name': name,
      'description': description,
      'ingredients': []
    });
    return Recipe.fromJson(data);
  }
}
