import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(

      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(

        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: const Text("Inicio", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            Text(
              "Olá, ${user?.email ?? 'usuário'} 👋",
              style: const TextStyle(fontSize: 20 , color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
