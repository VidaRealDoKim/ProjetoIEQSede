import 'package:flutter/material.dart';

/// =============================================
/// Seção Documentos do Editar Perfil
/// =============================================
class DocumentosPage extends StatefulWidget {
  const DocumentosPage({super.key});

  @override
  State<DocumentosPage> createState() => _DocumentosPageState();
}

class _DocumentosPageState extends State<DocumentosPage> {
  final _formKey = GlobalKey<FormState>();

  // Campos
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController orgaoExpedidorController = TextEditingController();
  final TextEditingController ufController = TextEditingController();

  // Fotos de documentos (aqui você pode integrar com ImagePicker futuramente)
  String? fotoCPF;
  String? fotoRG;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // CPF
            TextFormField(
              controller: cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // RG
            TextFormField(
              controller: rgController,
              decoration: const InputDecoration(
                labelText: 'RG',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Órgão Expedidor
            TextFormField(
              controller: orgaoExpedidorController,
              decoration: const InputDecoration(
                labelText: 'Órgão expedidor',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // UF
            TextFormField(
              controller: ufController,
              decoration: const InputDecoration(
                labelText: 'UF',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Upload fotos (CPF e RG)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
              onPressed: () {
                // TODO: Implementar upload de foto do CPF
              },
              child: Text(fotoCPF != null ? 'Atualizar foto CPF' : 'Enviar foto CPF'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
              onPressed: () {
                // TODO: Implementar upload de foto do RG
              },
              child: Text(fotoRG != null ? 'Atualizar foto RG' : 'Enviar foto RG'),
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
