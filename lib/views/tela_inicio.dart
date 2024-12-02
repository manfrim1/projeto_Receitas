import 'package:flutter/material.dart';
import 'receita_lista.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  TelaInicioState createState() => TelaInicioState();
}

class TelaInicioState extends State<TelaInicio> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Função para navegar automaticamente para a tela principal após alguns segundos
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ReceitaLista()),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 253, 253), // Cor de fundo da tela de splash
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png', // Certifique-se de adicionar a imagem 'logo.png' na pasta assets
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 30),
          const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 2, 143, 56), // Cor da barra de progresso
            ),
            backgroundColor: Color.fromARGB(255, 220, 220, 220), // Cor do fundo da barra
            minHeight: 8, // Altura da barra de progresso
          ),
        ],
      ),
    ),
  );
}

}
