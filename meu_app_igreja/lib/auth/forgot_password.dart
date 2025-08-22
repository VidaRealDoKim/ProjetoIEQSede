import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela de recuperação de senha.
/// Permite ao usuário solicitar o envio de um email para redefinir sua senha.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  /// Controlador do campo de email
  final TextEditingController _email = TextEditingController();

  /// Indica se a tela está processando a solicitação (para mostrar loading)
  bool _loading = false;

  /// Armazena mensagem de sucesso ou erro para exibir ao usuário
  String _message = "";

  /// Função responsável por enviar o email de redefinição de senha via Supabase
  Future<void> _resetPassword() async {
    setState(() {
      _loading = true;   // Ativa o indicador de carregamento
      _message = "";     // Limpa mensagens anteriores
    });

    try {
      // Solicita ao Supabase o envio do email de recuperação
      await Supabase.instance.client.auth
          .resetPasswordForEmail(_email.text.trim());

      setState(() {
        _message = "📩 Email de recuperação enviado!";
      });
    } catch (e) {
      // Captura erros e exibe na tela
      setState(() {
        _message = "❌ Erro: $e";
      });
    } finally {
      // Desativa o loading independentemente do resultado
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Esqueceu a senha")),

      /// Corpo da tela centralizado
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de email
              TextField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: "Digite seu email")),
              const SizedBox(height: 20),

              // Botão de envio ou indicador de carregamento
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _resetPassword,
                child: const Text("Enviar email"),
              ),

              // Mensagem de sucesso ou erro
              if (_message.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(_message, style: const TextStyle(color: Colors.blue)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
