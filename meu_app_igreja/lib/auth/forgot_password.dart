// ============================================================================
// forgot_password.dart
// Tela para recuperação de senha via Supabase (envio de e-mail)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  bool _loading = false;

  // ==========================================================================
  // Envio de email de redefinição de senha
  // ==========================================================================
  Future<void> _resetPassword() async {
    if (_email.text.isEmpty) {
      _showSnack("⚠️ Digite seu e-mail");
      return;
    }

    setState(() => _loading = true);

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _email.text.trim(),
      );
      _showSnack("📩 E-mail de recuperação enviado!");
    } catch (e) {
      _showSnack("❌ Erro: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  // Exibe mensagens na tela
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // ==========================================================================
  // Interface (UI)
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fundo padrão com gradiente
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Color(0xFF414141), Color(0xFF000000)],
            stops: [0.20, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo de email
                CustomInput(
                  hint: "Digite seu e-mail",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Botão principal
                CustomButton(
                  text: "Enviar e-mail",
                  loading: _loading,
                  onPressed: _resetPassword,
                ),
                const SizedBox(height: 20),

                // Botão secundário
                _linkButton("Voltar para o login", () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Botão reutilizável
  Widget _linkButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Voltar para login",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFE8E8E8),
          ),
        ),
      ),
    );
  }
}
