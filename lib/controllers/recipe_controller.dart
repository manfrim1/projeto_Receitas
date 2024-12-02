import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/recipe_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io'; // Importa o pacote para SocketException

class RecipeController extends ChangeNotifier {
  List<Recipe> _favorites = [];

  RecipeController() {
    _loadFavorites();
  }

  // Método para buscar receitas da API
  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificação se a resposta contém 'meals'
        if (data['meals'] != null) {
          final List<dynamic> recipesJson = data['meals'];
          return recipesJson.map((json) => Recipe.fromJson(json)).toList();
        } else {
          return []; // Retorna uma lista vazia se não houver receitas
        }
      } else {
        throw Exception(
            'Erro ${response.statusCode}: Falha ao carregar as receitas da API');
      }
    } on SocketException {
      throw Exception('Erro de rede: Verifique sua conexão com a internet.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de cliente: $e');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final List decoded = json.decode(favoritesJson);
      _favorites = decoded.map((recipe) => Recipe.fromJson(recipe)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        json.encode(_favorites.map((recipe) => recipe.toJson()).toList());
    await prefs.setString('favorites', encoded);
  }

  bool isFavorited(Recipe recipe) {
    return _favorites.any((item) => item.id == recipe.id);
  }

  void toggleFavorite(Recipe recipe) {
    if (isFavorited(recipe)) {
      _favorites.removeWhere((item) => item.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
    _saveFavorites();
    notifyListeners(); // Notifica sempre que há uma mudança nos favoritos
  }

  List<Recipe> getFavorites() {
    return _favorites;
  }
}
