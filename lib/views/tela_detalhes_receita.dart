import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../controllers/recipe_controller.dart';

class TelaDetalhesReceita extends StatelessWidget {
  final Recipe recipe;

  const TelaDetalhesReceita({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.name,
          style: const TextStyle(color: Colors.white), // Texto branco
        ),
        centerTitle: true,
         backgroundColor: const Color.fromARGB(221, 133, 130, 130), // Fundo do AppBar em tema dark
        actions: [
          Consumer<RecipeController>(
            builder: (context, controller, child) {
              final bool isFavorited = controller.isFavorited(recipe);
              return IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.white, // Ícone vermelho ou branco
                  size: 28,
                ),
                onPressed: () {
                  controller.toggleFavorite(recipe);

                  // Mostra um Snackbar ao adicionar/remover dos favoritos
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorited
                            ? 'Receita removida dos favoritos!'
                            : 'Receita adicionada aos favoritos!',
                        style: const TextStyle(color: Colors.white), // Cor do texto
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green, // Cor de fundo verde
                    ),
                  );

                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black, // Fundo da tela em tema dark
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.network(
                    recipe.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 100,
                      );
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Ingredientes Necessários para o preparo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto branco
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: recipe.ingredients
                    .map((ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 3, 235, 100), // Bolinha Verde
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white, // Ícone branco
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Texto branco
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                'Modo de Preparo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto branco
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                recipe.instructions,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white, // Texto branco
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
