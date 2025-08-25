import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'editar_perfil.dart';

/// =============================================
/// Página de Perfil do Usuário
/// =============================================
class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? perfil;
  double progresso = 0.0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  /// =============================================
  /// Carrega perfil do usuário e progresso do Supabase
  /// =============================================
  Future<void> _carregarPerfil() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Carrega os dados básicos do usuário
      final data = await supabase
          .from('perfis')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // Carrega progresso do usuário em todos os conteúdos
      final progressoData = await supabase
          .from('usuario_progresso')
          .select('progresso')
          .eq('usuario_id', user.id);

      double media = 0.0;
      if (progressoData.isNotEmpty) {
        final total = progressoData.fold<double>(
          0,
              (sum, row) => sum + (row['progresso'] as num).toDouble(),
        );
        media = total / progressoData.length;
      }

      setState(() {
        perfil = data;
        progresso = media;
        loading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar perfil: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      // Tela de carregamento
      return const Scaffold(
        backgroundColor: Color(0xFF171717),
        body: Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    final nome = perfil?['nome'] ?? "Sem nome";
    final fotoUrl = perfil?['foto_url'];

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text("Meu Perfil", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0D0D),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Configurações",
            onPressed: () {
              // TODO: Navegar para tela de Configurações
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          /// =============================================
          /// Card do usuário com avatar, nome e progresso
          /// =============================================
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar com botão para atualizar foto
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[800],
                            backgroundImage:
                            fotoUrl != null ? NetworkImage(fotoUrl) : null,
                            child: fotoUrl == null
                                ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey[700],
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // TODO: Upload de foto de perfil
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Dados básicos e progresso
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nome,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${(progresso * 100).toInt()}% Completo",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: progresso,
                              backgroundColor: Colors.grey[800],
                              color: Colors.green,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botão para ir à edição de perfil
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.edit, color: Colors.grey),
                    title: const Text(
                      "Editar meu perfil",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditarPerfilPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// =============================================
          /// Menu de opções adicionais
          /// =============================================
          _buildMenuItem(Icons.notifications, "Notificações"),
          _buildMenuItem(Icons.group, "Grupos"),
          _buildMenuItem(Icons.credit_card, "Minhas carteirinhas"),
          _buildMenuItem(Icons.payment, "Meus cartões"),
          _buildMenuItem(Icons.note, "Notas"),
        ],
      ),
    );
  }

  /// =============================================
  /// Builder para itens do menu do perfil
  /// =============================================
  Widget _buildMenuItem(IconData icon, String title) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[500]),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        trailing:
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // TODO: Navegação para tela correspondente
        },
      ),
    );
  }
}
