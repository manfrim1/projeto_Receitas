import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/recipe_controller.dart';
import 'views/tela_inicio.dart';
import 'views/receita_lista.dart';
import 'views/tela_favoritos.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RecipeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas da Vovó',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: const TelaInicio(), // Define a SplashScreen como a tela inicial
      routes: {
        '/recipes': (context) =>
            const ReceitaLista(), // Atualiza para nome mais claro
        '/favorites': (context) => const TelaFavoritos(),
      },
    );
  }
}
