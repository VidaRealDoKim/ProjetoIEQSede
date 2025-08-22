import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login.dart';

class MaisPage extends StatelessWidget {
  const MaisPage({super.key});

  /// Mostra o alerta de confirmação antes de sair
  Future<void> _confirmLogout(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar saída"),
        content: const Text("Você realmente deseja sair da sua conta?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // cancela
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // confirma
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
    return Scaffold(
      appBar: AppBar(title: const Text("Mais opções")),
      body: ListView(
        children: [
          const ListTile(leading: Icon(Icons.person), title: Text("Perfil")),
          const ListTile(leading: Icon(Icons.menu_book), title: Text("Bíblia")),
          const ListTile(leading: Icon(Icons.book), title: Text("Leituras")),
          const ListTile(leading: Icon(Icons.pages), title: Text("Páginas da Igreja")),
          const ListTile(leading: Icon(Icons.calendar_today), title: Text("Agenda")),
          const ListTile(leading: Icon(Icons.volunteer_activism), title: Text("Doações")),
          const ListTile(leading: Icon(Icons.chat), title: Text("Pedidos de oração")),
          const ListTile(leading: Icon(Icons.check), title: Text("Testemunhos")),
          const ListTile(leading: Icon(Icons.download), title: Text("Download de esboços")),
          const ListTile(leading: Icon(Icons.share), title: Text("Compartilhar")),
          const ListTile(leading: Icon(Icons.phone), title: Text("Contatos")),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Sair", style: TextStyle(color: Colors.red)),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }
}
