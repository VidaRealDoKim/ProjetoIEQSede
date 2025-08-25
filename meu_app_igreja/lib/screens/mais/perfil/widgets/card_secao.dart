import 'package:flutter/material.dart';

class CardSecao extends StatefulWidget {
  final String titulo;
  final IconData icone;
  final double porcentagem; // de 0 a 1
  final Widget conteudo;

  const CardSecao({
    super.key,
    required this.titulo,
    required this.icone,
    required this.porcentagem,
    required this.conteudo,
  });

  @override
  State<CardSecao> createState() => _CardSecaoState();
}

class _CardSecaoState extends State<CardSecao> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.icone, color: Colors.green[700]),
            title: Text(widget.titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: LinearProgressIndicator(
              value: widget.porcentagem,
              minHeight: 6,
              backgroundColor: Colors.grey[800],
              color: Colors.green[700],
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
              onPressed: () {
                setState(() => _expanded = !_expanded);
              },
            ),
            onTap: () {
              setState(() => _expanded = !_expanded);
            },
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.conteudo,
            ),
        ],
      ),
    );
  }
}
