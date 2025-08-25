import 'package:flutter/material.dart';

class ConteudoTextoTab extends StatelessWidget {
  final Function(double progresso) onSalvarProgresso;

  const ConteudoTextoTab({super.key, required this.onSalvarProgresso});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Aqui vai o conteúdo em texto...",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => onSalvarProgresso(1.0),
            child: const Text("Marcar como concluído"),
          ),
        ],
      ),
    );
  }
}
