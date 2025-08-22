import 'package:flutter/material.dart';
import '../widgets/content_card.dart';
import 'conteudo_detalhe_page.dart';

/// Página principal de Conteúdo
class ConteudoPage extends StatelessWidget {
  const ConteudoPage({super.key});

  // Dados de teste
  final List<Map<String, String>> destaques = const [
    {
      'titulo': 'Rende-se a Deus',
      'subtitulo': 'Série O Discípulo de Jesus',
      'imagem_url': 'https://via.placeholder.com/400x200',
    },
    {
      'titulo': 'Uma Nova Vida',
      'subtitulo': 'Celebrações Especiais',
      'imagem_url': 'https://via.placeholder.com/400x200',
    },
  ];

  final List<String> categorias = const [
    'Todos',
    'Celebração Eleve',
    'Celebrações',
  ];

  final List<Map<String, String>> continuarAssistindo = const [
    {
      'titulo': 'Amar as Pessoas',
      'subtitulo': 'Série O Amor de Deus',
      'imagem_url': 'https://via.placeholder.com/400x200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,

      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: const Text("Conteúdo"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Seção "Em destaque"
          const SectionTitle(title: "Em destaque"),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: destaques.map((c) {
                return ContentCard(
                  imageUrl: c['imagem_url']!,
                  title: c['titulo']!,
                  subtitle: c['subtitulo']!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConteudoDetalhePage(),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Seção de filtros/categorias
          const SectionTitle(title: "Categorias"),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: categorias.map((cat) {
              return FilterChip(
                label: Text(cat),
                onSelected: (_) {},
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Seção "Continuar assistindo"
          const SectionTitle(title: "Continuar assistindo"),
          const SizedBox(height: 12),
          Column(
            children: continuarAssistindo.map((c) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ContentCard(
                  imageUrl: c['imagem_url']!,
                  title: c['titulo']!,
                  subtitle: c['subtitulo']!,
                  onTap: () {},
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Widget para títulos de seções
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
