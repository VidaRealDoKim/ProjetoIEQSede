// -----------------------------------------------------------------------------
// Importações principais do Flutter e pacotes externos
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// Importações internas (widgets customizados do projeto)
// -----------------------------------------------------------------------------
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

// -----------------------------------------------------------------------------
// Classe ForgotPasswordPage
// Tela de recuperação de senha.
// Permite ao usuário solicitar redefinição de senha via Supabase.
// -----------------------------------------------------------------------------
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // ---------------------------------------------------------------------------
  // Controlador do campo de email
  // ---------------------------------------------------------------------------
  final TextEditingController _email = TextEditingController();

  // Controla estado de carregamento do botão de envio
  bool _loading = false;

  // ---------------------------------------------------------------------------
  // Função para enviar email de redefinição de senha via Supabase
  // Mostra mensagens de feedback (sucesso ou erro) com SnackBar.
  // ---------------------------------------------------------------------------
  Future<void> _resetPassword() async {
    setState(() => _loading = true); // Ativa estado de carregamento

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

  // ---------------------------------------------------------------------------
  // Construção da interface (UI)
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tela sem AppBar, mais limpa
      body: Container(
        // Fundo com gradiente radial (tema visual padrão do app)
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
                // -------------------------------------------------------------
                // Campo de Email
                // -------------------------------------------------------------
                CustomInput(
                  hint: "Digite seu email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // -------------------------------------------------------------
                // Botão principal para envio do email de redefinição
                // -------------------------------------------------------------
                CustomButton(
                  text: "Enviar email",
                  loading: _loading,
                  onPressed: _resetPassword,
                ),
                const SizedBox(height: 20),

                // -------------------------------------------------------------
                // Botão secundário "Voltar para login"
                // Estilo transparente para diferenciar da ação principal
                // -------------------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // mesmo estilo do CustomButton
                      ),
                    ),
                    child: const Text(
                      "Voltar para login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFE8E8E8), // branco/acinzentado
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
