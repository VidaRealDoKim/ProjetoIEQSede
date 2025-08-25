import 'package:flutter/material.dart';

/// =============================================
/// Seção Dados Adicionais do Editar Perfil
/// =============================================
class DadosAdicionaisPage extends StatefulWidget {
  const DadosAdicionaisPage({super.key});

  @override
  State<DadosAdicionaisPage> createState() => _DadosAdicionaisPageState();
}

class _DadosAdicionaisPageState extends State<DadosAdicionaisPage> {
  final _formKey = GlobalKey<FormState>();

  // Campos
  final TextEditingController escolaridadeController = TextEditingController();
  final TextEditingController profissaoController = TextEditingController();
  final TextEditingController nacionalidadeController = TextEditingController();
  final TextEditingController naturalidadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Escolaridade
            TextFormField(
              controller: escolaridadeController,
              decoration: const InputDecoration(
                labelText: 'Escolaridade',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Profissão
            TextFormField(
              controller: profissaoController,
              decoration: const InputDecoration(
                labelText: 'Profissão',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Nacionalidade
            TextFormField(
              controller: nacionalidadeController,
              decoration: const InputDecoration(
                labelText: 'Nacionalidade',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Naturalidade
            TextFormField(
              controller: naturalidadeController,
              decoration: const InputDecoration(
                labelText: 'Naturalidade',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Botão continuar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
                onPressed: () {
                  // TODO: salvar dados e redirecionar para fluxo de %
                },
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
