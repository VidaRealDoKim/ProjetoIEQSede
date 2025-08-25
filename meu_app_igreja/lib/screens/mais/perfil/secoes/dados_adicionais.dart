import 'package:flutter/material.dart';

/// =============================================
/// Seção Dados Básicos do Editar Perfil
/// =============================================
class DadosBasicosPage extends StatefulWidget {
  const DadosBasicosPage({super.key});

  @override
  State<DadosBasicosPage> createState() => _DadosBasicosPageState();
}

class _DadosBasicosPageState extends State<DadosBasicosPage> {
  final _formKey = GlobalKey<FormState>();

  // Campos
  final TextEditingController nomeController = TextEditingController();
  DateTime? dataNascimento;
  String sexo = 'Masculino';
  String estadoCivil = 'Solteiro';
  bool necessidadesEspeciais = false;

  final List<String> sexos = ['Masculino', 'Feminino'];
  final List<String> estadosCivis = ['Solteiro', 'Casado', 'Divorciado', 'Viúvo'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Nome completo
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Sexo
            DropdownButtonFormField<String>(
              value: sexo,
              items: sexos
                  .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s),
              ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => sexo = val);
              },
              decoration: const InputDecoration(
                labelText: 'Sexo',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Data de nascimento
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Data de nascimento',
                labelStyle: const TextStyle(color: Colors.white),
                fillColor: const Color(0xFF1E1E1E),
                filled: true,
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
              ),
              controller: TextEditingController(
                  text: dataNascimento != null
                      ? '${dataNascimento!.day}/${dataNascimento!.month}/${dataNascimento!.year}'
                      : ''),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: dataNascimento ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Colors.grey, // header
                          onPrimary: Colors.white, // texto header
                          surface: Color(0xFF1E1E1E), // fundo picker
                          onSurface: Colors.white, // texto picker
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) setState(() => dataNascimento = date);
              },
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Estado civil
            DropdownButtonFormField<String>(
              value: estadoCivil,
              items: estadosCivis
                  .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s),
              ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => estadoCivil = val);
              },
              decoration: const InputDecoration(
                labelText: 'Estado civil',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Necessidades especiais
            SwitchListTile(
              title: const Text('Possui necessidades especiais?', style: TextStyle(color: Colors.white)),
              value: necessidadesEspeciais,
              onChanged: (val) => setState(() => necessidadesEspeciais = val),
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
