import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'conteudo/admin_conteudo_list.dart';

/// ===============================================================
/// DASHBOARD ADMINISTRATIVO
/// - Tela inicial dos administradores.
/// - Mostra atalhos em formato de grade (cards).
/// - Cada card leva a um módulo (ex: Conteúdos, Eventos...).
/// - AppBar tem botão de Logout (com confirmação).
/// - Estilo escuro consistente.
/// ===============================================================
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  /// Função para módulos que ainda não estão prontos.
  /// Apenas mostra um aviso em forma de SnackBar.
  void _emBreve(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Módulo em desenvolvimento 🛠️')),
    );
  }

  /// Função de Logout
  /// - Exibe uma caixa de diálogo perguntando se o usuário quer sair.
  /// - Se confirmar, faz `signOut()` no Supabase e volta pra tela de login.
  Future<void> _confirmarLogout(BuildContext context) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF171717), // fundo dark
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Confirmar Logout", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Tem certeza que deseja sair?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          // Botão cancelar → fecha o diálogo
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
          ),
          // Botão sair → confirma logout
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Sair", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    // Se o usuário clicou em "Sair"
    if (confirmar == true) {
      await Supabase.instance.client.auth.signOut(); // encerra sessão
      Navigator.of(context).pushReplacementNamed('/login'); // volta pro login
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Lista de itens do Dashboard (cada card)
    final items = <_DashItem>[
      _DashItem(
        title: 'Conteúdos',
        icon: Icons.article,
        color: const Color(0xFFDE6D56), // destaque diferente
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminConteudoList()),
        ),
      ),
      _DashItem(title: 'Eventos', icon: Icons.event, onTap: () => _emBreve(context)),
      _DashItem(title: 'Pastores', icon: Icons.person, onTap: () => _emBreve(context)),
      _DashItem(title: 'Membros', icon: Icons.groups, onTap: () => _emBreve(context)),
      _DashItem(title: 'Células', icon: Icons.home_work, onTap: () => _emBreve(context)),
      _DashItem(title: 'Setores', icon: Icons.account_tree, onTap: () => _emBreve(context)),
      _DashItem(title: 'Ministérios', icon: Icons.volunteer_activism, onTap: () => _emBreve(context)),
      _DashItem(title: 'Formulários', icon: Icons.assignment, onTap: () => _emBreve(context)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B), // fundo geral dark
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Painel Administrativo', style: TextStyle(color: Colors.white)),
        actions: [
          /// Botão de Logout no canto direito
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Sair",
            onPressed: () => _confirmarLogout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        /// Grid que mostra os cards dos módulos
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colunas
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.15, // formato quase quadrado
          ),
          itemBuilder: (_, i) => _DashboardCard(item: items[i]),
        ),
      ),
    );
  }
}

/// Classe que representa um item do Dashboard
class _DashItem {
  final String title;     // Nome do módulo
  final IconData icon;    // Ícone do card
  final VoidCallback onTap; // Ação ao clicar
  final Color? color;     // Cor opcional

  _DashItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });
}

/// Card visual de cada item do Dashboard
class _DashboardCard extends StatelessWidget {
  final _DashItem item;

  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap, // ação ao clicar
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF171717), // fundo card dark
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24), // borda leve
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Ícone dentro de um círculo
              CircleAvatar(
                radius: 28,
                backgroundColor: (item.color ?? Colors.white24).withOpacity(0.25),
                child: Icon(item.icon, size: 28, color: item.color ?? Colors.white70),
              ),
              const SizedBox(height: 12),

              /// Nome do módulo
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              /// Texto fixo "Acessar"
              const Text(
                'Acessar',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
