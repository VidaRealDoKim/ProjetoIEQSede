import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ===============================================================
/// Formulário de Conteúdos (Admin)
/// - Abas: Info | Texto | Áudio | Materiais (PDF)
/// - Corrige erro do `.eq` após `.stream()`
/// - Tema dark, consistente com AdminConteudoList/AdminDashboard
/// ===============================================================
class AdminConteudoForm extends StatefulWidget {
  final Map<String, dynamic>? conteudo; // null => criação

  const AdminConteudoForm({super.key, this.conteudo});

  @override
  State<AdminConteudoForm> createState() => _AdminConteudoFormState();
}

class _AdminConteudoFormState extends State<AdminConteudoForm>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  // Controllers principais
  final tituloCtrl = TextEditingController();
  final subtituloCtrl = TextEditingController();
  final imagemCtrl = TextEditingController();

  // Abas auxiliares
  final textoCtrl = TextEditingController();        // Texto (conteudo_detalhes)
  final audioUrlCtrl = TextEditingController();     // URL de áudio
  final matDescCtrl = TextEditingController();      // Descrição PDF
  final matPdfCtrl = TextEditingController();       // URL PDF
  final matCapaCtrl = TextEditingController();      // Capa (opcional)

  int? conteudoId;                                  // PK de `conteudos`
  late TabController _tab;

  bool _carregandoTexto = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);

    if (widget.conteudo != null) {
      conteudoId = widget.conteudo!['id'] as int?;
      tituloCtrl.text = widget.conteudo!['titulo'] ?? '';
      subtituloCtrl.text = widget.conteudo!['subtitulo'] ?? '';
      imagemCtrl.text = widget.conteudo!['imagem_url'] ?? '';
      _carregarTexto(); // carrega texto existente (se houver)
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    tituloCtrl.dispose();
    subtituloCtrl.dispose();
    imagemCtrl.dispose();
    textoCtrl.dispose();
    audioUrlCtrl.dispose();
    matDescCtrl.dispose();
    matPdfCtrl.dispose();
    matCapaCtrl.dispose();
    super.dispose();
    // (se tiver streams, o StreamBuilder cuida do cancelamento)
  }

  /// ---------------------------------------------------------------
  /// SALVAR INFORMAÇÕES BÁSICAS (título, subtítulo, imagem_url)
  /// - Na criação, retorna o ID inserido e guarda em `conteudoId`
  /// ---------------------------------------------------------------
  Future<void> salvarInfo() async {
    final dados = {
      'titulo': tituloCtrl.text.trim(),
      'subtitulo': subtituloCtrl.text.trim(),
      'imagem_url': imagemCtrl.text.trim(),
    };

    if ((dados['titulo'] as String).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título é obrigatório.')),
      );
      return;
    }

    try {
      if (conteudoId == null) {
        // insert + select para recuperar o registro criado
        final inserted = await supabase
            .from('conteudos')
            .insert(dados)
            .select()
            .single();
        conteudoId = inserted['id'] as int;
        // após criar o conteúdo, posso carregar texto existente (provavel vazio)
        await _carregarTexto();
      } else {
        await supabase.from('conteudos').update(dados).eq('id', conteudoId!);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações salvas com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  /// ---------------------------------------------------------------
  /// TEXTO (conteudo_detalhes: tipo = 'texto')
  /// - Carrega o texto existente (se houver) e preenche `textoCtrl`
  /// ---------------------------------------------------------------
  Future<void> _carregarTexto() async {
    if (conteudoId == null) return;
    setState(() => _carregandoTexto = true);
    try {
      final rows = await supabase
          .from('conteudo_detalhes')
          .select()
          .eq('conteudo_id', conteudoId!)
          .eq('tipo', 'texto')
          .limit(1);

      if (rows.isNotEmpty && rows.first['texto'] != null) {
        textoCtrl.text = rows.first['texto'] ?? '';
      }
    } catch (_) {
      // silencioso: se der erro, o usuário pode digitar e salvar
    } finally {
      if (mounted) setState(() => _carregandoTexto = false);
    }
  }

  Future<void> salvarTexto() async {
    if (conteudoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salve as informações básicas primeiro.')),
      );
      return;
    }

    try {
      // verifica se já existe registro de texto
      final rows = await supabase
          .from('conteudo_detalhes')
          .select()
          .eq('conteudo_id', conteudoId!)
          .eq('tipo', 'texto')
          .limit(1);

      if (rows.isEmpty) {
        await supabase.from('conteudo_detalhes').insert({
          'conteudo_id': conteudoId,
          'tipo': 'texto',
          'texto': textoCtrl.text,
        });
      } else {
        await supabase
            .from('conteudo_detalhes')
            .update({'texto': textoCtrl.text})
            .eq('id', rows.first['id']);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Texto salvo!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar texto: $e')),
      );
    }
  }

  /// ---------------------------------------------------------------
  /// ÁUDIO (conteudo_detalhes: tipo = 'audio')
  /// - Corrigido: stream + filtro via `map`
  /// ---------------------------------------------------------------
  Stream<List<Map<String, dynamic>>> streamAudios() {
    if (conteudoId == null) return const Stream.empty();
    final base = supabase
        .from('conteudo_detalhes')
        .stream(primaryKey: ['id'])
        .execute();

    // Filtro pós-stream para evitar `.eq` no builder (compat v2.8.0)
    return base.map((rows) => rows
        .where((r) =>
    r['conteudo_id'] == conteudoId &&
        (r['tipo']?.toString() ?? '') == 'audio')
        .toList());
  }

  Future<void> adicionarAudio() async {
    if (conteudoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salve as informações básicas primeiro.')),
      );
      return;
    }
    final url = audioUrlCtrl.text.trim();
    if (url.isEmpty) return;

    try {
      await supabase.from('conteudo_detalhes').insert({
        'conteudo_id': conteudoId,
        'tipo': 'audio',
        'url': url,
      });
      audioUrlCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar áudio: $e')),
      );
    }
  }

  Future<void> removerAudio(int id) async {
    try {
      await supabase.from('conteudo_detalhes').delete().eq('id', id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover áudio: $e')),
      );
    }
  }

  /// ---------------------------------------------------------------
  /// MATERIAIS DE APOIO (materiais_apoio)
  /// - Corrigido: stream + filtro via `map`
  /// ---------------------------------------------------------------
  Stream<List<Map<String, dynamic>>> streamMateriais() {
    if (conteudoId == null) return const Stream.empty();
    final base =
    supabase.from('materiais_apoio').stream(primaryKey: ['id']).execute();

    return base.map((rows) =>
        rows.where((r) => r['conteudo_id'] == conteudoId).toList());
  }

  Future<void> adicionarMaterial() async {
    if (conteudoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salve as informações básicas primeiro.')),
      );
      return;
    }

    final descricao = matDescCtrl.text.trim();
    final pdf = matPdfCtrl.text.trim();
    final capa = matCapaCtrl.text.trim();

    if (pdf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a URL do PDF.')),
      );
      return;
    }

    try {
      await supabase.from('materiais_apoio').insert({
        'conteudo_id': conteudoId,
        'descricao': descricao.isEmpty ? null : descricao,
        'arquivo_pdf': pdf,
        'capa': capa.isEmpty ? null : capa,
      });
      matDescCtrl.clear();
      matPdfCtrl.clear();
      matCapaCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar material: $e')),
      );
    }
  }

  Future<void> removerMaterial(int id) async {
    try {
      await supabase.from('materiais_apoio').delete().eq('id', id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover material: $e')),
      );
    }
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.conteudo == null ? 'Novo Conteúdo' : 'Editar Conteúdo',
          style: const TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: const Color(0xFFDE6D56),
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Texto'),
            Tab(text: 'Áudio'),
            Tab(text: 'Materiais'),
          ],
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _tabInfo(),
          _tabTexto(),
          _tabAudio(),
          _tabMateriais(),
        ],
      ),
    );
  }

  // ---------- Tab 1: Informações básicas ----------
  Widget _tabInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _darkTextField(tituloCtrl, 'Título *'),
          const SizedBox(height: 12),
          _darkTextField(subtituloCtrl, 'Subtítulo'),
          const SizedBox(height: 12),
          _darkTextField(imagemCtrl, 'URL da Imagem'),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDE6D56),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: salvarInfo,
            child: const Text('Salvar Informações'),
          ),
          if (conteudoId != null) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                'ID do conteúdo: $conteudoId',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ]
        ],
      ),
    );
  }

  // ---------- Tab 2: Texto ----------
  Widget _tabTexto() {
    if (conteudoId == null) {
      return _mensagemSalvarPrimeiro();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: textoCtrl,
              maxLines: null,
              expands: true,
              style: const TextStyle(color: Colors.white),
              decoration: _darkInputDecoration('Texto do Conteúdo'),
            ),
          ),
          const SizedBox(height: 10),
          if (_carregandoTexto)
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Carregando texto...', style: TextStyle(color: Colors.white54)),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDE6D56),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: salvarTexto,
            child: const Text('Salvar Texto'),
          ),
        ],
      ),
    );
  }

  // ---------- Tab 3: Áudio ----------
  Widget _tabAudio() {
    if (conteudoId == null) return _mensagemSalvarPrimeiro();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(child: _darkTextField(audioUrlCtrl, 'URL do Áudio')),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: adicionarAudio,
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: streamAudios(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final audios = snap.data!;
              if (audios.isEmpty) {
                return const Center(
                  child: Text('Nenhum áudio cadastrado.', style: TextStyle(color: Colors.white70)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: audios.length,
                itemBuilder: (_, i) {
                  final a = audios[i];
                  return Card(
                    color: const Color(0xFF171717),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(a['url'] ?? '', style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => removerAudio(a['id'] as int),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------- Tab 4: Materiais ----------
  Widget _tabMateriais() {
    if (conteudoId == null) return _mensagemSalvarPrimeiro();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _darkTextField(matDescCtrl, 'Descrição do material'),
              const SizedBox(height: 8),
              _darkTextField(matPdfCtrl, 'URL do PDF *'),
              const SizedBox(height: 8),
              _darkTextField(matCapaCtrl, 'URL da Capa (opcional)'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: adicionarMaterial,
                  child: const Text('Adicionar Material'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: streamMateriais(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final mats = snap.data!;
              if (mats.isEmpty) {
                return const Center(
                  child: Text('Nenhum material cadastrado.', style: TextStyle(color: Colors.white70)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: mats.length,
                itemBuilder: (_, i) {
                  final m = mats[i];
                  return Card(
                    color: const Color(0xFF171717),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: (m['capa'] != null && (m['capa'] as String).isNotEmpty)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(m['capa'], width: 50, height: 50, fit: BoxFit.cover),
                      )
                          : const Icon(Icons.picture_as_pdf, color: Colors.white70),
                      title: Text(m['descricao'] ?? '(sem descrição)', style: const TextStyle(color: Colors.white)),
                      subtitle: Text(m['arquivo_pdf'] ?? '', style: const TextStyle(color: Colors.white70)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => removerMaterial(m['id'] as int),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------- Helpers visuais ----------
  Widget _mensagemSalvarPrimeiro() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Salve as informações básicas (aba Info) para habilitar esta seção.',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  InputDecoration _darkInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF171717),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDE6D56), width: 2),
      ),
    );
  }

  Widget _darkTextField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: _darkInputDecoration(label),
    );
  }
}
