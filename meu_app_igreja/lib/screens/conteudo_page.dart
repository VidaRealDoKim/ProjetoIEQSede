import 'package:flutter/material.dart';


/// Página principal de Conteúdo
/// Mostra cards horizontais (destaques), categorias/filtros e seção de continuar assistindo.
/// Ao clicar em um card, abre a página de detalhe com Tabs (Áudio, Texto, Materiais de apoio).
class ConteudoPage extends StatelessWidget {
  const ConteudoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto (igual referência da foto)

      // Barra superior (AppBar)
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Conteúdo"), // Título da tela
        actions: [
          // Botão de pesquisa
          IconButton(
            onPressed: () {
              // TODO: implementar busca no futuro
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      // Conteúdo principal da tela
      body: ListView(
        padding: const EdgeInsets.all(16), // espaçamento interno
        children: [
          // Título da seção "Em destaque"
          const Text(
              "Em destaque",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          ),
          const SizedBox(height: 12),

          /// Seção de cards horizontais (destaques)
          SizedBox(
            height: 200, // altura da área dos cards
            child: ListView(
              scrollDirection: Axis.horizontal, // rolagem lateral
              children: [
                // Primeiro card de conteúdo
                ContentCard(
                  imageUrl: "https://via.placeholder.com/400x200", // imagem fictícia
                  title: "RENDE-SE A DEUS", // título
                  subtitle: "Série O Discípulo de Jesus", // subtítulo
                  onTap: () {
                    // Abre a tela de detalhe ao clicar no card
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ConteudoDetalhePage()),
                    );
                  },
                ),
                // Segundo card de conteúdo
                ContentCard(
                  imageUrl: "https://via.placeholder.com/400x200",
                  title: "UMA NOVA VIDA",
                  subtitle: "Celebrações Especiais",
                  onTap: () {
                    // TODO: implementar redirecionamento
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// Seção de filtros/categorias (ex.: Todos, Celebração Eleve, etc.)
          Row(
            children: [
              // Botão de filtro "Todos"
              FilterChip(
                label: const Text("Todos"),
                onSelected: (_) {
                  // TODO: lógica para filtrar "Todos"
                },
              ),
              const SizedBox(width: 8),

              // Botão de filtro "Celebração Eleve"
              FilterChip(
                label: const Text("Celebração Eleve"),
                onSelected: (_) {
                  // TODO: lógica para filtrar essa categoria
                },
              ),
              const SizedBox(width: 8),

              // Botão de filtro "Celebrações"
              FilterChip(
                label: const Text("Celebrações"),
                onSelected: (_) {
                  // TODO: lógica para filtrar essa categoria
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// Seção "Continuar assistindo"
          const Text(
              "Continuar assistindo",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          ),
          const SizedBox(height: 12),

          // Card único de "continuar assistindo"
          ContentCard(
            imageUrl: "https://via.placeholder.com/400x200",
            title: "AMAR AS PESSOAS",
            subtitle: "Série O Amor de Deus",
            onTap: () {
              // TODO: lógica ao clicar (abrir detalhe)
            },
          ),
        ],
      ),
    );
  }
}

/// Componente de Card de Conteúdo
/// Recebe imagem, título, subtítulo e ação ao clicar.
/// Usado tanto na seção "Em destaque" quanto em "Continuar assistindo".
class ContentCard extends StatelessWidget {
  final String imageUrl; // URL da imagem do card
  final String title; // título do card
  final String subtitle; // subtítulo (série, tema, etc.)
  final VoidCallback onTap; // ação ao clicar

  const ContentCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // executa a ação ao clicar no card
      child: Container(
        width: 280, // largura do card
        margin: const EdgeInsets.only(right: 12), // espaço entre cards
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem principal do card
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // bordas arredondadas
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 160,
                width: 280,
              ),
            ),
            const SizedBox(height: 8),

            // Título do card
            Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )
            ),

            // Subtítulo do card
            Text(
                subtitle,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14
                )
            ),
          ],
        ),
      ),
    );
  }
}

/// Tela de Detalhes do Conteúdo
/// Mostra o título e um TabBar com 3 abas (Áudio, Texto, Materiais).
class ConteudoDetalhePage extends StatelessWidget {
  const ConteudoDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // quantidade de abas
      child: Scaffold(
        backgroundColor: Colors.black,

        // Barra superior da tela de detalhes
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("RENDE-SE A DEUS"), // título fixo (pode ser dinâmico depois)

          // Abas (Tabs)
          bottom: const TabBar(
            tabs: [
              Tab(text: "Áudio"),
              Tab(text: "Texto"),
              Tab(text: "Materiais de apoio"),
            ],
          ),
        ),

        // Conteúdo das abas (TabBarView)
        body: const TabBarView(
          children: [
            // Aba "Áudio"
            Center(
              child: Icon(Icons.audiotrack, color: Colors.white, size: 100),
            ),

            // Aba "Texto"
            Center(
              child: Icon(Icons.text_snippet, color: Colors.white, size: 100),
            ),

            // Aba "Materiais de apoio"
            Center(
              child: Icon(Icons.menu_book, color: Colors.white, size: 100),
            ),
          ],
        ),
      ),
    );
  }
}
