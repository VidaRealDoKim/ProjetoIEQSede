import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/content_card.dart';
import 'conteudo_detalhe_page.dart';

/// Página principal que lista os conteúdos vindos do Supabase
class ConteudoPage extends StatelessWidget {
  const ConteudoPage({super.key});

  /// Busca todos os conteúdos no Supabase
  Future<List<Map<String, dynamic>>> _fetchConteudos() async {
    final response = await Supabase.instance.client
        .from('conteudos') // nome da tabela no banco
        .select();

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,

      /// Barra superior
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: const Text("Conteúdo"),
        actions: [
          IconButton(
            onPressed: () {}, // futuramente: abrir busca
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      /// Corpo principal
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchConteudos(), // consulta no banco
        builder: (context, snapshot) {
          // Mostra loading enquanto carrega
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mostra erro caso a consulta falhe
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar conteúdos: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final conteudos = snapshot.data ?? [];

          // Caso não exista nenhum conteúdo
          if (conteudos.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum conteúdo disponível",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          /// Divide os conteúdos em duas seções:
          final destaques = conteudos.take(5).toList(); // 5 primeiros
          final continuarAssistindo = conteudos.skip(5).toList(); // o resto

          /// Extrai categorias únicas
          final categorias = conteudos
              .map((c) => c['categoria']?.toString() ?? 'Outros')
              .toSet()
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---------- Seção "Em destaque" ----------
              const SectionTitle(title: "Em destaque"),
              const SizedBox(height: 12),

              /// Lista horizontal com cards de destaque
              SizedBox(
                height: 240, // maior para evitar overflow
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: destaques.map((c) {
                    return ContentCard(
                      imageUrl: c['imagem_url'] ?? '',
                      title: c['titulo'] ?? '',
                      subtitle: c['subtitulo'] ?? '',
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

              // ---------- Seção "Categorias" ----------
              const SectionTitle(title: "Categorias"),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                children: categorias.map((cat) {
                  return FilterChip(
                    label: Text(cat),
                    onSelected: (_) {}, // futuramente: filtrar
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // ---------- Seção "Continuar assistindo" ----------
              const SectionTitle(title: "Continuar assistindo"),
              const SizedBox(height: 12),

              Column(
                children: continuarAssistindo.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ContentCard(
                      imageUrl: c['imagem_url'] ?? '',
                      title: c['titulo'] ?? '',
                      subtitle: c['subtitulo'] ?? '',
                      onTap: () {}, // poderia abrir de onde parou
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Widget para os títulos das seções
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
