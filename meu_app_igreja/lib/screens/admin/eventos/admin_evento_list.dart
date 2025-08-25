import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_evento_form.dart';
import 'package:intl/intl.dart'; // Para formatar a data

class AdminEventoList extends StatefulWidget {
  const AdminEventoList({super.key});

  @override
  State<AdminEventoList> createState() => _AdminEventoListState();
}

class _AdminEventoListState extends State<AdminEventoList> {
  final supabase = Supabase.instance.client;

  /// Stream para receber os eventos em tempo real
  Stream<List<Map<String, dynamic>>> _streamEventos() {
    return supabase.from('eventos').stream(primaryKey: ['id']).execute();
  }

  /// Deleta evento pelo id
  Future<void> _deleteEvento(int id) async {
    await supabase.from('eventos').delete().eq('id', id);
  }

  /// Abre formulário de criação ou edição
  void _openForm({Map<String, dynamic>? evento}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminEventoForm(evento: evento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Gerenciar Eventos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFDE6D56),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text("Novo Evento"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamEventos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final eventos = snapshot.data!;
          if (eventos.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum evento encontrado.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eventos.length,
            itemBuilder: (_, i) {
              final e = eventos[i];

              // Formata a data do timestamp
              String dataFormatada = '';
              if (e['data'] != null) {
                final dt = DateTime.tryParse(e['data'].toString());
                if (dt != null) {
                  dataFormatada = DateFormat('yyyy-MM-dd').format(dt);
                }
              }

              return Card(
                color: const Color(0xFF171717),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: e['banner_url'] != null && e['banner_url'] != ''
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      e['banner_url'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.event, color: Colors.white70),
                  title: Text(
                    e['nome'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    dataFormatada,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openForm(evento: e),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteEvento(e['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
