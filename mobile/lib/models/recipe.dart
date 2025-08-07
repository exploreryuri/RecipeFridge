class Recipe {
  final int id;
  final String name;
  final String? description;

  Recipe({required this.id, required this.name, this.description});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }
}
