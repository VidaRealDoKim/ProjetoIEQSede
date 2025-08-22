import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

/// Tela de recuperação de senha.
/// Stateful para controlar estado do campo de email e loading do botão.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controller para capturar o email digitado pelo usuário
  final TextEditingController _email = TextEditingController();

  // Controla estado de carregamento do botão
  bool _loading = false;

  /// Função para enviar email de redefinição de senha via Supabase
  Future<void> _resetPassword() async {
    setState(() => _loading = true); // Ativa loading

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _email.text.trim(),
      );

      // Mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📩 Email de recuperação enviado!")),
      );
    } catch (e) {
      // Mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erro: $e")),
      );
    } finally {
      setState(() => _loading = false); // Desativa loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removida a AppBar, tela limpa
      body: Container(
        // Fundo com gradiente radial padrão do app
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
                  hint: "Digite seu email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Botão principal de envio de email
                CustomButton(
                  text: "Enviar email",
                  loading: _loading,
                  onPressed: _resetPassword,
                ),
                const SizedBox(height: 20),

                // Botão secundário transparente para voltar ao login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // transparente
                      shadowColor: Colors.transparent, // remove sombra
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // mesmo estilo do CustomButton
                      ),
                    ),
                    child: const Text(
                      "Voltar para login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFE8E8E8), // texto branco/acinzentado
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
