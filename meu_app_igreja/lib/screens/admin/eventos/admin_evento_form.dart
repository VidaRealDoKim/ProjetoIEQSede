import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminEventoForm extends StatefulWidget {
  final Map<String, dynamic>? evento;
  const AdminEventoForm({super.key, this.evento});

  @override
  State<AdminEventoForm> createState() => _AdminEventoFormState();
}

class _AdminEventoFormState extends State<AdminEventoForm> {
  final supabase = Supabase.instance.client;

  final nomeCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final dataCtrl = TextEditingController();
  final localCtrl = TextEditingController();
  final bannerCtrl = TextEditingController();

  int? eventoId;

  @override
  void initState() {
    super.initState();
    if (widget.evento != null) {
      eventoId = widget.evento!['id'] as int?;
      nomeCtrl.text = widget.evento!['nome'] ?? '';
      descCtrl.text = widget.evento!['descricao'] ?? '';
      // data é timestamp -> transformar em string legível
      if (widget.evento!['data'] != null) {
        dataCtrl.text = widget.evento!['data'].toString().split(" ").first;
      }
      localCtrl.text = widget.evento!['local'] ?? '';
      bannerCtrl.text = widget.evento!['banner_url'] ?? '';
    }
  }

  Future<void> salvar() async {
    final dados = {
      'nome': nomeCtrl.text.trim(),
      'descricao': descCtrl.text.trim(),
      // converte texto para timestamp
      'data': DateTime.tryParse(dataCtrl.text.trim()),
      'local': localCtrl.text.trim(),
      'banner_url': bannerCtrl.text.trim(),
    };

    if (eventoId == null) {
      await supabase.from('eventos').insert(dados);
    } else {
      await supabase.from('eventos').update(dados).eq('id', eventoId!);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          eventoId == null ? "Novo Evento" : "Editar Evento",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _darkTextField(nomeCtrl, "Nome"),
            const SizedBox(height: 12),
            _darkTextField(descCtrl, "Descrição"),
            const SizedBox(height: 12),
            _darkTextField(dataCtrl, "Data (yyyy-mm-dd)"),
            const SizedBox(height: 12),
            _darkTextField(localCtrl, "Local"),
            const SizedBox(height: 12),
            _darkTextField(bannerCtrl, "URL do Banner"),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDE6D56),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: salvar,
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }

  Widget _darkTextField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF171717),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDE6D56), width: 2),
        ),
      ),
    );
  }
}
