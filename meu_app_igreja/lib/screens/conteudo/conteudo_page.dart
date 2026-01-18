// -----------------------------------------------------------------------------
// Importações principais
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Descomentar quando conectar ao banco

// -----------------------------------------------------------------------------
// Importações internas (outras telas do app)
// -----------------------------------------------------------------------------
import 'conteudo_detalhe_page.dart';

// -----------------------------------------------------------------------------
// Classe ConteudoPage
// Página principal que lista os conteúdos vindos do Supabase.
// Divide a listagem em duas seções:
// - "Em destaque" → primeiros 5 itens
// - "Continuar assistindo" → itens para continuar vendo
// -----------------------------------------------------------------------------
class ConteudoPage extends StatelessWidget {
  const ConteudoPage({super.key});

  // ---------------------------------------------------------------------------
  // Busca os conteúdos (simulado - remover quando conectar ao Supabase)
  // TODO: Criar tabela 'conteudos' no Supabase e descomentar linha abaixo
  // ---------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> _fetchConteudos() async {
    // TEMPORÁRIO: Dados de exemplo
    return [
      {
        'id': '1',
        'titulo': 'Culto de Domingo',
        'descricao': 'Culto especial de celebração',
        'imagem_url': 'https://via.placeholder.com/400x225',
        'criado_em': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'titulo': 'Estudo Bíblico',
        'descricao': 'Estudo sobre João 3:16',
        'imagem_url': 'https://via.placeholder.com/400x225',
        'criado_em': DateTime.now().toIso8601String(),
      },
    ];
    
    // DESCOMENTAR quando criar tabela 'conteudos':
    // final response = await Supabase.instance.client.from('conteudos').select();
    // return List<Map<String, dynamic>>.from(response);
  }

  // ---------------------------------------------------------------------------
  // Construção da interface
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),

      // AppBar minimalista
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: const Text("Conteúdo", style: TextStyle(color: Colors.white)),
      ),

      // Corpo da tela
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchConteudos(),
          builder: (context, snapshot) {

            // Estado: carregando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Estado: erro
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Erro: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // Estado: sucesso
            final conteudos = snapshot.data ?? [];

            // Lista vazia
            if (conteudos.isEmpty) {
              return const Center(
                child: Text(
                  "Nenhum conteúdo disponível",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Divide em "destaques" (5 primeiros) e "continuar assistindo"
            final destaques = conteudos.take(5).toList();
            final continuarAssistindo = conteudos.skip(5).toList();

            // -----------------------------------------------------------------
            // Lista principal com seções
            // -----------------------------------------------------------------
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [

                // --------------------- Seção: Em destaque ---------------------
                const SectionTitle(title: "Em destaque"),
                const SizedBox(height: 12),

                // -----------------------------------------------------------------------------
                // Carrossel de destaques
                // -----------------------------------------------------------------------------
                // Exibe uma lista horizontal de conteúdos (destaques), cada item clicável
                // para abrir a página de detalhes. A imagem de cada item é exibida com
                // proporção 16:9, mantendo a consistência visual e evitando distorção.
                // -----------------------------------------------------------------------------

                SizedBox(
                  height: 200, // altura total do carrossel (container de cada item + título)
                  child: ListView(
                    scrollDirection: Axis.horizontal, // rolagem horizontal
                    children: destaques.map((c) {
                      return GestureDetector(
                        // ---------------------------------------------------------------------
                        // Detecta o clique no item do carrossel
                        // ---------------------------------------------------------------------
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConteudoDetalhePage(
                                conteudoId: c['id'],       // id do conteúdo no Supabase
                                titulo: c['titulo'] ?? '',  // título do conteúdo
                                subtitulo: c['subtitulo'],  // subtítulo do conteúdo
                                imagemUrl: c['imagem_url'], // URL da imagem de capa
                              ),
                            ),
                          );
                        },

                        // ---------------------------------------------------------------------
                        // Container do item do carrossel
                        // ---------------------------------------------------------------------
                        child: Container(
                          width: 220, // largura fixa do item
                          margin: const EdgeInsets.only(right: 12), // espaçamento entre itens
                          decoration: BoxDecoration(
                            color: Colors.grey[900], // cor de fundo do container
                            borderRadius: BorderRadius.circular(12), // cantos arredondados
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.5), // sombra
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),

                          // -------------------------------------------------------------------
                          // Conteúdo interno do container: coluna com imagem + título/subtítulo
                          // -------------------------------------------------------------------
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // -----------------------------------------------------------------
                              // Imagem de capa do item
                              // -----------------------------------------------------------------
                              if (c['imagem_url'] != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9, // proporção 16:9 para todas as imagens
                                    child: Image.network(
                                      c['imagem_url'], // URL da imagem
                                      fit: BoxFit.cover, // cobre todo o espaço sem distorcer
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey, // fallback caso a imagem não carregue
                                          child: const Center(
                                            child: Icon(Icons.broken_image, color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                              // -----------------------------------------------------------------
                              // Espaço para título e subtítulo do item
                              // -----------------------------------------------------------------
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Título do conteúdo
                                    Text(
                                      c['titulo'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2, // limite de linhas
                                      overflow: TextOverflow.ellipsis, // corta texto excedente
                                    ),
                                    // Subtítulo (opcional)
                                    if (c['subtitulo'] != null)
                                      Text(
                                        c['subtitulo'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Espaçamento inferior após o carrossel
                const SizedBox(height: 24),


                // --------------- Seção: Continuar assistindo ------------------
                const SectionTitle(title: "Continuar assistindo"),
                const SizedBox(height: 12),

                Column(
                  children: continuarAssistindo.map((c) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConteudoDetalhePage(
                              conteudoId: c['id'],
                              titulo: c['titulo'] ?? '',
                              subtitulo: c['subtitulo'],
                              imagemUrl: c['imagem_url'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Miniatura da imagem
                            if (c['imagem_url'] != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(12),
                                ),
                                child: Image.network(
                                  c['imagem_url'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 12),

                            // Título e subtítulo
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      c['titulo'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (c['subtitulo'] != null)
                                      Text(
                                        c['subtitulo'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SectionTitle
// Widget auxiliar para títulos de seções (ex: "Em destaque")
// -----------------------------------------------------------------------------
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
