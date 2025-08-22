import 'package:flutter/material.dart';

/// Tela de detalhes de um conteúdo
/// Possui abas para exibir Áudio, Texto e Materiais de apoio
class ConteudoDetalhePage extends StatelessWidget {
  const ConteudoDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // número de abas
      child: Scaffold(
        backgroundColor: Colors.white38,

        appBar: AppBar(
          backgroundColor: Colors.white10,
          title: const Text("Título do Conteúdo"),

          /// Abas de navegação
          bottom: const TabBar(
            tabs: [
              Tab(text: "Áudio"),
              Tab(text: "Texto"),
              Tab(text: "Materiais de apoio"),
            ],
          ),
        ),

        /// Conteúdo de cada aba
        body: const TabBarView(
          children: [
            Center(child: Icon(Icons.audiotrack, color: Colors.white, size: 100)),
            Center(child: Icon(Icons.text_snippet, color: Colors.white, size: 100)),
            Center(child: Icon(Icons.menu_book, color: Colors.white, size: 100)),
          ],
        ),
      ),
    );
  }
}
