// -----------------------------------------------------------------------------
// Importações principais
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// ConteudoDetalhePage
// Tela de detalhes de um conteúdo específico.
// Mostra:
// - Imagem de capa (se existir)
// - Título, subtítulo, autor e descrição
// - Abas: Áudio, Texto, Materiais de apoio
//
// Também registra e atualiza progresso do usuário na tabela `usuario_progresso`.
// -----------------------------------------------------------------------------
class ConteudoDetalhePage extends StatefulWidget {
  final int conteudoId;       // ID do conteúdo no banco
  final String titulo;        // Título principal
  final String? subtitulo;    // Subtítulo opcional
  final String? imagemUrl;    // URL da imagem de destaque
  final String? autor;        // Nome do autor (ex: pastor)
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
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // Ao abrir o conteúdo pela primeira vez, registra progresso inicial (0%)
    _salvarProgresso(0.0);
  }

  // ---------------------------------------------------------------------------
  // Salva ou atualiza progresso do usuário no Supabase
  //
  // - progresso: valor entre 0.0 e 1.0 (0% a 100%)
  // - utiliza `upsert` com `onConflict` para sobrescrever caso já exista
  // ---------------------------------------------------------------------------
  Future<void> _salvarProgresso(double progresso) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('usuario_progresso').upsert(
      {
        'usuario_id': userId,
        'conteudo_id': widget.conteudoId,
        'progresso': progresso,
        'atualizado_em': DateTime.now().toIso8601String(), // registra timestamp
      },
      onConflict: 'usuario_conteudo_unique',
    );
  }

  // ---------------------------------------------------------------------------
  // Construção da interface
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // abas: Áudio, Texto, Materiais
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0B0B),

        // ---------- AppBar ----------
        appBar: AppBar(
          backgroundColor: const Color(0xFF171717),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.titulo,
            style: const TextStyle(color: Colors.white),
          ),
        ),

        // ---------- Corpo ----------
        body: Column(
          children: [
            // ---------- Header com imagem ----------
            if (widget.imagemUrl != null && widget.imagemUrl!.isNotEmpty)
              Image.network(
                widget.imagemUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            // ---------- Título, subtítulo, autor e descrição ----------
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Subtítulo
                  if (widget.subtitulo != null)
                    Text(
                      widget.subtitulo!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                  // Autor
                  if (widget.autor != null)
                    Text(
                      "Pastor • ${widget.autor}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                  // Descrição
                  if (widget.descricao != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.descricao!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ---------- Tabs ----------
            const TabBar(
              indicatorColor: Color(0xFFDE6D56),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Áudio"),
                Tab(text: "Texto"),
                Tab(text: "Materiais de apoio"),
              ],
            ),

            // ---------- Conteúdo das abas ----------
            Expanded(
              child: TabBarView(
                children: [
                  // ------------------------- Aba Áudio -------------------------
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.audiotrack,
                            color: Colors.white, size: 100),
                        const SizedBox(height: 8),
                        const Text(
                          "Player de Áudio aqui",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),

                        // Botão que simula progresso parcial (50%)
                        ElevatedButton(
                          onPressed: () {
                            _salvarProgresso(0.5);
                          },
                          child: const Text("Simular 50% do áudio"),
                        ),
                      ],
                    ),
                  ),

                  // ------------------------- Aba Texto -------------------------
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Aqui vai o conteúdo em texto...",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),

                        // Botão que marca conteúdo como concluído (100%)
                        ElevatedButton(
                          onPressed: () {
                            _salvarProgresso(1.0);
                          },
                          child: const Text("Marcar como concluído"),
                        ),
                      ],
                    ),
                  ),

                  // ------------------- Aba Materiais de apoio ------------------
                  const SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Lista de PDFs, slides ou links de apoio.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
