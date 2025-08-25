import 'package:flutter/material.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF171717),
      // AppBar minimalista
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: const Text("Eventos", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(


        children: const [
          ListTile(leading: Icon(Icons.event), title: Text("Todos os eventos", style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.bookmark), title: Text("Itens salvos", style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.confirmation_number), title: Text("Meus tickets", style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.calendar_today), title: Text("Agenda", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
