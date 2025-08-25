import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import das telas que já existem no projeto
import 'perfil/perfil.dart';
import '../../auth/login.dart';

/// =============================================
/// Página "Mais"
/// =============================================
/// Menu lateral/extra com acesso a Perfil, Bíblia, Doações, Agenda etc.
/// Também gerencia o logout.
class MaisPage extends StatefulWidget {
  const MaisPage({super.key});

  @override
  State<MaisPage> createState() => _MaisPageState();
}

class _MaisPageState extends State<MaisPage> {
  Map<String, dynamic>? _perfil;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  /// Busca os dados do perfil no Supabase
  Future<void> _carregarPerfil() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final res = await Supabase.instance.client
        .from('perfis')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    setState(() {
      _perfil = res;
      _loading = false;
    });
  }

  /// Confirmação antes de fazer logout
  Future<void> _confirmLogout(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Confirmar saída", style: TextStyle(color: Colors.white)),
        content: const Text("Você realmente deseja sair da sua conta?", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Sair"),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF171717),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final nome = _perfil?['nome'] ?? "Usuário";
    final progresso = 0.26; // TODO: Calcular dinamicamente via backend

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: const Text("Mais", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Card do Perfil
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("${(progresso * 100).toInt()}% Completo",
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: progresso,
                              backgroundColor: Colors.grey[800],
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Navega para página de perfil
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.grey),
                    title: const Text("Ver meu perfil", style: TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PerfilPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Menu de Opções
          _buildMenuItem(Icons.menu_book, "Bíblia", () {}),
          _buildMenuItem(Icons.book, "Leituras", () {}),
          _buildMenuItem(Icons.pages, "Nossas páginas", () {}),
          _buildMenuItem(Icons.calendar_today, "Agenda", () {}),
          _buildMenuItem(Icons.volunteer_activism, "Doações", () {}),
          _buildMenuItem(Icons.chat, "Pedido de oração", () {}),
          _buildMenuItem(Icons.check, "Testemunhos", () {}),
          _buildMenuItem(Icons.download, "Download de esboços", () {}),
          _buildMenuItem(Icons.share, "Compartilhar", () {}),
          _buildMenuItem(Icons.phone, "Contatos", () {}),

          const Divider(color: Colors.grey),

          /// Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Sair", style: TextStyle(color: Colors.red)),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  /// Builder para menu de opções
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[500]),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
