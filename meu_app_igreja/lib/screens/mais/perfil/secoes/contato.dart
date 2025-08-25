import 'package:flutter/material.dart';

/// =============================================
/// Seção Contato do Editar Perfil
/// =============================================
class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  final _formKey = GlobalKey<FormState>();

  // Campos
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController telefoneIgrejaController = TextEditingController();
  final TextEditingController relacaoIgrejaController = TextEditingController();
  final TextEditingController dataEntradaController = TextEditingController();
  final TextEditingController entradaPorController = TextEditingController();
  final TextEditingController igrejaOrigemController = TextEditingController();

  // Campos sim/não
  bool jaBatizou = false;
  bool aceitouJesus = false;
  bool isLider = false;
  bool isPastor = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Endereço
            TextFormField(
              controller: enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Email
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Celular
            TextFormField(
              controller: celularController,
              decoration: const InputDecoration(
                labelText: 'Celular',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Telefone da Igreja (somente leitura)
            TextFormField(
              controller: telefoneIgrejaController,
              decoration: const InputDecoration(
                labelText: 'Telefone da Igreja (não editável)',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              readOnly: true,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Relação com a Igreja
            TextFormField(
              controller: relacaoIgrejaController,
              decoration: const InputDecoration(
                labelText: 'Relação com a Igreja',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Data de entrada
            TextFormField(
              controller: dataEntradaController,
              decoration: const InputDecoration(
                labelText: 'Data de entrada',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Entrada por
            TextFormField(
              controller: entradaPorController,
              decoration: const InputDecoration(
                labelText: 'Entrada por',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Igreja onde veio
            TextFormField(
              controller: igrejaOrigemController,
              decoration: const InputDecoration(
                labelText: 'Igreja onde veio',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Switches Sim/Não
            SwitchListTile(
              title: const Text('Já se batizou?', style: TextStyle(color: Colors.white)),
              value: jaBatizou,
              onChanged: (val) => setState(() => jaBatizou = val),
            ),
            SwitchListTile(
              title: const Text('Aceitou Jesus?', style: TextStyle(color: Colors.white)),
              value: aceitouJesus,
              onChanged: (val) => setState(() => aceitouJesus = val),
            ),
            SwitchListTile(
              title: const Text('É líder?', style: TextStyle(color: Colors.white)),
              value: isLider,
              onChanged: (val) => setState(() => isLider = val),
            ),
            SwitchListTile(
              title: const Text('É pastor?', style: TextStyle(color: Colors.white)),
              value: isPastor,
              onChanged: (val) => setState(() => isPastor = val),
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
