import 'package:flutter/material.dart';

class AoVivoPage extends StatelessWidget {
  const AoVivoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),

      // AppBar minimalista
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: const Text("Ao Vivo", style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text("🎥 Integração com YouTube em breve", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
