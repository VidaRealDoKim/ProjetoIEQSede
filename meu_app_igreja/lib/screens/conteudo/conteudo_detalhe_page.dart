// -----------------------------------------------------------------------------
// Importações principais
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// Importações internas (abas do detalhe do conteúdo)
// -----------------------------------------------------------------------------
import 'conteudo_audio_tab.dart';
import 'conteudo_texto_tab.dart';
import 'conteudo_materiais_tab.dart';

// -----------------------------------------------------------------------------
// ConteudoDetalhePage
//
// Tela de detalhes de um conteúdo específico.
//
// Funcionalidades:
// - Imagem de capa 16:9 (se existir)
// - Título, subtítulo, autor e descrição
// - Abas: Áudio, Texto, Materiais de apoio
// - Registra e atualiza progresso do usuário na tabela `usuario_progresso`
// -----------------------------------------------------------------------------
class ConteudoDetalhePage extends StatefulWidget {
  final int conteudoId;       // ID do conteúdo no Supabase
  final String titulo;        // Título principal
  final String? subtitulo;    // Subtítulo opcional
  final String? imagemUrl;    // URL da imagem de destaque
  final String? autor;        // Nome do autor
  final String? descricao;    // Breve descrição

  const ConteudoDetalhePage({
    super.key,
    required this.conteudoId,
    required this.titulo,
    this.subtitulo,
    this.imagemUrl,
    this.autor,
    this.descricao,
  });

  @override
  State<ConteudoDetalhePage> createState() => _ConteudoDetalhePageState();
}

// -----------------------------------------------------------------------------
// Estado da página de detalhes
// -----------------------------------------------------------------------------
class _ConteudoDetalhePageState extends State<ConteudoDetalhePage> {
  // Cliente Supabase já inicializado no app principal
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // Salva progresso inicial 0% ao abrir o conteúdo
    _salvarProgresso(0.0);
  }

  // ---------------------------------------------------------------------------
  // Salva ou atualiza progresso do usuário no Supabase
  //
  // progresso: valor entre 0.0 e 1.0 (0% a 100%)
  // upsert: insere ou atualiza caso já exista registro
  // ----------------------------------------------------------------------------
  Future<void> _salvarProgresso(double progresso) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('usuario_progresso').upsert(
      {
        'usuario_id': userId,
        'conteudo_id': widget.conteudoId,
        'progresso': progresso,
        'atualizado_em': DateTime.now().toIso8601String(),
      },
      onConflict: 'usuario_conteudo_unique',
    );
  }

  // ---------------------------------------------------------------------------
  // Construção da interface
  // ----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de abas: Áudio, Texto, Materiais
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0B0B),

        // ---------- AppBar ----------
        appBar: AppBar(
          backgroundColor: const Color(0xFF171717),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(widget.titulo, style: const TextStyle(color: Colors.white)),
        ),

        // ---------- Corpo com NestedScrollView ----------
        body: NestedScrollView(
          // Header rolável: imagem de capa + informações + TabBar
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Imagem de capa ----------
                  if (widget.imagemUrl != null && widget.imagemUrl!.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        widget.imagemUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          // fallback caso a imagem não carregue
                          return Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),

                  // ---------- Informações do conteúdo ----------
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          widget.titulo,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        // Subtítulo (opcional)
                        if (widget.subtitulo != null)
                          Text(
                            widget.subtitulo!,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        // Autor (opcional)
                        if (widget.autor != null)
                          Text(
                            "Pastor • ${widget.autor}",
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        // Descrição (opcional)
                        if (widget.descricao != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.descricao!,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ---------- TabBar rolável ----------
                  TabBar(
                    isScrollable: true,               // permite rolar horizontalmente
                    indicatorColor: Color(0xFFDE6D56),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    labelPadding: const EdgeInsets.only(right: 24), // espaço entre as abas
                    tabs: const [
                      Tab(text: "Áudio"),
                      Tab(text: "Texto"),
                      Tab(text: "Materiais de apoio"),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // ---------- TabBarView ----------
          body: TabBarView(
            children: [
              // Cada aba com rolagem vertical
              SingleChildScrollView(
                child: ConteudoAudioTab(onSalvarProgresso: _salvarProgresso),
              ),
              SingleChildScrollView(
                child: ConteudoTextoTab(onSalvarProgresso: _salvarProgresso),
              ),
              SingleChildScrollView(
                child: ConteudoMateriaisTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
