import 'package:flutter/material.dart';

/// =============================================
/// Seção Igreja do Editar Perfil
/// =============================================
class IgrejaPage extends StatefulWidget {
  const IgrejaPage({super.key});

  @override
  State<IgrejaPage> createState() => _IgrejaPageState();
}

class _IgrejaPageState extends State<IgrejaPage> {
  final _formKey = GlobalKey<FormState>();

  // Campos
  String tipoMembro = 'Visitante';
  final TextEditingController relacaoIgrejaController = TextEditingController();
  final TextEditingController dataEntradaController = TextEditingController();
  final TextEditingController entradaPorController = TextEditingController();
  final TextEditingController igrejaOrigemController = TextEditingController();

  // Campos Sim/Não
  bool jaBatizou = false;
  bool aceitouJesus = false;
  bool isLider = false;
  bool isPastor = false;

  final List<String> tiposMembros = ['Visitante', 'Membro', 'Pastor', 'Administrador'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Tipo de membro
            DropdownButtonFormField<String>(
              value: tipoMembro,
              items: tiposMembros
                  .map((tipo) => DropdownMenuItem(
                value: tipo,
                child: Text(tipo),
              ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => tipoMembro = val);
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de membro',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
              ),
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Relação com a igreja
            TextFormField(
              controller: relacaoIgrejaController,
              decoration: const InputDecoration(
                labelText: 'Relação com a igreja',
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
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Data de entrada',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF1E1E1E),
                filled: true,
                suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Colors.grey,
                          onPrimary: Colors.white,
                          surface: Color(0xFF1E1E1E),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    dataEntradaController.text =
                    '${date.day}/${date.month}/${date.year}';
                  });
                }
              },
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

            // Igreja de origem
            TextFormField(
              controller: igrejaOrigemController,
              decoration: const InputDecoration(
                labelText: 'Igreja de origem',
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
