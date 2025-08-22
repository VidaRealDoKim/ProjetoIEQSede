import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'conteudo_detalhe_page.dart';

/// Página principal que lista os conteúdos vindos do Supabase
class ConteudoPage extends StatelessWidget {
  const ConteudoPage({super.key});

  /// Busca todos os conteúdos da tabela `conteudos`
  Future<List<Map<String, dynamic>>> _fetchConteudos() async {
    final response = await Supabase.instance.client.from('conteudos').select();
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        title: const Text("Conteúdo", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchConteudos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text("Erro: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red)));
            }

            final conteudos = snapshot.data ?? [];
            if (conteudos.isEmpty) {
              return const Center(
                  child: Text("Nenhum conteúdo disponível",
                      style: TextStyle(color: Colors.white)));
            }

            // Separar em destaques e continuar assistindo
            final destaques = conteudos.take(5).toList();
            final continuarAssistindo = conteudos.skip(5).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ---------- Seção "Em destaque" ----------
                const SectionTitle(title: "Em destaque"),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: destaques.map((c) {
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
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (c['imagem_url'] != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.network(
                                    c['imagem_url'],
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c['titulo'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (c['subtitulo'] != null)
                                      Text(
                                        c['subtitulo'],
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
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
                const SizedBox(height: 24),

                // ---------- Seção "Continuar assistindo" ----------
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
                            if (c['imagem_url'] != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(12)),
                                child: Image.network(
                                  c['imagem_url'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(c['titulo'] ?? '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    if (c['subtitulo'] != null)
                                      Text(c['subtitulo'],
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 12)),
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

/// Widget simples para títulos das seções (ex: "Em destaque")
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
