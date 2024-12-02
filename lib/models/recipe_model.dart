class Recipe {
  final String id;
  final String name;
  final String image;
  final List<String> ingredients;
  final String instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    required this.instructions,
  });

  // Cria um objeto Recipe a partir de um JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'] ?? '', // Se for null, atribuir uma string vazia
      name: json['strMeal'] ??
          'Nome Desconhecido', // Se for null, atribuir 'Nome Desconhecido'
      image:
          json['strMealThumb'] ?? '', // Se for null, atribuir uma string vazia
      ingredients:
          _extractIngredients(json), // Método auxiliar para tratar ingredientes
      instructions: json['strInstructions'] ?? 'Instruções não disponíveis',
    );
  }

  // Converte um objeto Recipe em JSON
  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': image,
      'ingredients': ingredients,
      'strInstructions': instructions,
    };
  }

  // Método auxiliar para extrair a lista de ingredientes do JSON
  static List<String> _extractIngredients(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
      }
    }
    return ingredients;
  }
}
