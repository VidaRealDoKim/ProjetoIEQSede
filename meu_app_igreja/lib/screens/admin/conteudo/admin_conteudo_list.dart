import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_conteudo_form.dart';

/// =============================================
/// Tela de Listagem de Conteúdos (Admin)
///
/// ✅ Responsabilidades principais:
/// - Exibir todos os conteúdos cadastrados no Supabase.
/// - Atualizar em tempo real com base em INSERT, UPDATE, DELETE.
/// - Criar novos conteúdos (via FAB).
/// - Editar conteúdos existentes.
/// - Excluir conteúdos.
/// - Visual moderno em cards.
/// =============================================
class AdminConteudoList extends StatefulWidget {
  const AdminConteudoList({super.key});

  @override
  State<AdminConteudoList> createState() => _AdminConteudoListState();
}

class _AdminConteudoListState extends State<AdminConteudoList> {
  /// Instância do cliente Supabase para consultas
  final supabase = Supabase.instance.client;

  /// =============================================
  /// 🔴 STREAM DE CONTEÚDOS
  /// - Escuta em tempo real a tabela `conteudos`.
  /// - A cada alteração (INSERT/UPDATE/DELETE),
  ///   o StreamBuilder reconstrói a lista.
  /// =============================================
  Stream<List<Map<String, dynamic>>> _streamConteudos() {
    return supabase.from('conteudos').stream(primaryKey: ['id']).execute();
  }

  /// =============================================
  /// 🔴 DELETE CONTEÚDO
  /// - Remove um conteúdo do banco usando `id`.
  /// - Importante: se a PK for `uuid`, sempre use String.
  /// =============================================
  Future<void> _deleteConteudo(String conteudoId) async {
    await supabase.from('conteudos').delete().eq('id', conteudoId);
  }

  /// =============================================
  /// 🔴 ABRIR FORMULÁRIO
  /// - Caso receba `conteudo`, abre em modo de edição.
  /// - Caso contrário, abre em modo de criação.
  /// =============================================
  void _openForm({Map<String, dynamic>? conteudo}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminConteudoForm(conteudo: conteudo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B), // Fundo escuro para estética moderna

      /// =============================================
      /// 🔴 APP BAR
      /// =============================================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Gerenciar Conteúdos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      /// =============================================
      /// 🔴 BOTÃO FLUTUANTE (Novo Conteúdo)
      /// =============================================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFDE6D56),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text("Novo Conteúdo"),
      ),

      /// =============================================
      /// 🔴 LISTA DE CONTEÚDOS (StreamBuilder)
      /// =============================================
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamConteudos(),
        builder: (context, snapshot) {
          /// Estado inicial → aguardando resposta
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Caso haja erro → exibe mensagem
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          /// Lista retornada pelo Supabase
          final conteudos = snapshot.data ?? [];

          /// Caso não exista nenhum conteúdo
          if (conteudos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Nenhum conteúdo encontrado.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          /// Caso existam conteúdos → renderiza em cards
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: conteudos.length,
            itemBuilder: (context, index) {
              final conteudo = conteudos[index];

              return Card(
                color: const Color(0xFF171717),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),

                /// =============================================
                /// 🔴 ESTRUTURA DE CADA CARD
                /// =============================================
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Imagem do conteúdo (se existir)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: conteudo['imagem_url'] != null &&
                          conteudo['imagem_url'].toString().isNotEmpty
                          ? Image.network(
                        conteudo['imagem_url'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 180,
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    /// Texto do conteúdo (titulo + subtitulo)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔴 Título
                          Text(
                            conteudo['titulo'] ?? 'Sem título',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          /// 🔴 Subtítulo
                          const SizedBox(height: 4),
                          Text(
                            conteudo['subtitulo'] ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// 🔴 Ações (editar / excluir)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /// Editar conteúdo
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _openForm(conteudo: conteudo),
                              ),

                              /// Excluir conteúdo
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => _deleteConteudo(
                                    conteudo['id'].toString()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
