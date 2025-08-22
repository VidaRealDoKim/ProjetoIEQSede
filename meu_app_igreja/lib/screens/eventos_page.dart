import 'package:flutter/material.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eventos")),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.event), title: Text("Todos os eventos")),
          ListTile(leading: Icon(Icons.bookmark), title: Text("Itens salvos")),
          ListTile(leading: Icon(Icons.confirmation_number), title: Text("Meus tickets")),
          ListTile(leading: Icon(Icons.calendar_today), title: Text("Agenda")),
        ],
      ),
    );
  }
}
