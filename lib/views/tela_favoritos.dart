import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe_model.dart';
import 'tela_detalhes_receita.dart';

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  @override
  TelaFavoritosState createState() => TelaFavoritosState();
}

class TelaFavoritosState extends State<TelaFavoritos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas Favoritas'),
        centerTitle: true, // Alinha o título ao centro

         backgroundColor: const Color.fromARGB(221, 133, 130, 130)
      ),
      backgroundColor: const Color.fromARGB(221, 133, 130, 130),  // Definindo o fundo como cinza claro
      body: Consumer<RecipeController>(
        builder: (context, controller, child) {
          final favorites = controller.getFavorites();
          return favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, size: 80, color: Colors.red), // Ícone de coração vermelho
                      SizedBox(height: 16),
                      Text(
                        'Não há receitas favoritas',
                        style: TextStyle(fontSize: 18),
                    
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    Recipe recipe = favorites[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Card(
                        color: Colors.black, // Define o fundo do Card como preto
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              recipe.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            recipe.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Define a cor do texto como branca
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent, // Ícone com cor vermelha
                            ),
                            onPressed: () {
                              // Remove o favorito e mostra o Snackbar
                              controller.toggleFavorite(recipe);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Receita removida dos favoritos!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            // Navegar para a Tela de Detalhes
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaDetalhesReceita(recipe: recipe),
                              ),
                            );
                          },
                        ),
                      ),

                    );
                  },
                );
        },
      ),
    );
  }
}