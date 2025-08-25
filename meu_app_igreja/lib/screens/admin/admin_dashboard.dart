// -----------------------------------------------------------------------------
// Importações principais
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// Importações dos módulos (cada módulo pode ter sua lista/tela inicial)
// -----------------------------------------------------------------------------
import 'conteudo/admin_conteudo_list.dart';
import 'eventos/admin_evento_list.dart';
// import 'pastores/admin_pastor_list.dart';
// import 'membros/admin_membro_list.dart';
// import 'celulas/admin_celula_list.dart';
// import 'setores/admin_setor_list.dart';
// import 'ministerios/admin_ministerio_list.dart';
// import 'formularios/admin_formulario_list.dart';

/// =============================================================================
/// DASHBOARD ADMINISTRATIVO
/// - Tela inicial dos administradores.
/// - Mostra atalhos em formato de grade (cards).
/// - Cada card leva a um módulo (Conteúdos, Eventos, etc).
/// - AppBar com botão de Logout.
/// - Tema escuro consistente.
/// - Todas as cores padronizadas em vermelho (cores dos ícones/cards).
/// =============================================================================
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  /// Função para módulos que ainda não estão prontos
  void _emBreve(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Módulo em desenvolvimento 🛠️')),
    );
  }

  /// Função de Logout (com confirmação)
  Future<void> _confirmarLogout(BuildContext context) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF171717),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Confirmar Logout", style: TextStyle(color: Colors.white)),
        content: const Text("Tem certeza que deseja sair?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Sair", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await Supabase.instance.client.auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Lista de módulos (cada item vira um card)
    /// 🔴 Todas as cores padronizadas para vermelho
    final items = <_DashItem>[
      _DashItem(
        title: 'Conteúdos',
        icon: Icons.library_books,
        color: const Color(0xFFDE6D56),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminConteudoList()),
        ),
      ),
      _DashItem(
        title: 'Eventos',
        icon: Icons.event,
        color: const Color(0xFFDE6D56),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminEventoList()),
        ),
      ),
      _DashItem(
        title: 'Pastores',
        icon: Icons.person,
        color: const Color(0xFF706565),
        onTap: () => _emBreve(context),
      ),
      _DashItem(
        title: 'Membros',
        icon: Icons.groups,
        color: const Color(0xFF706565),
        onTap: () => _emBreve(context),
      ),
      _DashItem(
        title: 'Células',
        icon: Icons.home_work,
        color: const Color(0xFF706565),
        onTap: () => _emBreve(context),
      ),
      _DashItem(
        title: 'Setores',
        icon: Icons.account_tree,
        color: const Color(0xFF706565),
        onTap: () => _emBreve(context),
      ),
      _DashItem(
        title: 'Ministérios',
        icon: Icons.volunteer_activism,
        color: const Color(0xFF706565),
        onTap: () => _emBreve(context),
      ),
      _DashItem(
        title: 'Formulários',
        icon: Icons.assignment,
        color: const Color(0xFF706565),
        onTap: () => _emBreve(context),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B), // 🔲 fundo preto
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Painel Administrativo',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Sair",
            onPressed: () => _confirmarLogout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards por linha
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (_, i) => _DashboardCard(item: items[i]),
        ),
      ),
    );
  }
}

/// =============================================================================
/// MODELO DE ITEM DO DASHBOARD
/// =============================================================================
class _DashItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  _DashItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });
}

/// =============================================================================
/// CARD VISUAL DE CADA ITEM
/// =============================================================================
class _DashboardCard extends StatelessWidget {
  final _DashItem item;

  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF171717), // fundo do card (dark)
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24), // borda leve
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone com círculo vermelho translúcido
              CircleAvatar(
                radius: 28,
                backgroundColor: (item.color ?? Colors.redAccent).withOpacity(0.25),
                child: Icon(item.icon, size: 28, color: item.color ?? Colors.redAccent),
              ),
              const SizedBox(height: 12),
              // Título do card
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              // Texto auxiliar "Acessar"
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
