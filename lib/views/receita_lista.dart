import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../controllers/recipe_controller.dart';
import 'tela_detalhes_receita.dart';

class ReceitaLista extends StatefulWidget {
  const ReceitaLista({super.key});

  @override
  ReceitaListaState createState() => ReceitaListaState();
}

class ReceitaListaState extends State<ReceitaLista> {
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  void _fetchRecipes() async {
    try {
      final controller = Provider.of<RecipeController>(context, listen: false);
      List<Recipe> recipes = await controller.fetchRecipes();
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar lista de receitas: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Receitas Da Vovó',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Texto branco para contraste
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
            221, 133, 130, 130), // Fundo do AppBar em tema dark
      ),
      backgroundColor: Colors.black, // Fundo da tela em tema dark
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recipes.isEmpty
              ? const Center(
                  child: Text(
                    'Lista de Receitas vazia!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Texto branco para contraste
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    Recipe recipe = _recipes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      child: Card(
                        color:
                            Colors.grey[900], // Fundo do Card em cinza escuro
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.network(
                                  recipe.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      color: Colors.white54,
                                      size: 60,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Texto branco para contraste
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white70, // Ícone branco
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          TelaDetalhesReceita(recipe: recipe),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/favorites');
        },
        backgroundColor: Colors.redAccent, // Fundo vermelho
        tooltip: 'Receitas Favoritas',
        child: const Icon(
          Icons.favorite,
          color: Colors.white, // Ícone branco
        ),
      ),
    );
  }
}
