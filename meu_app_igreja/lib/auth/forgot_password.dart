import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _email = TextEditingController();
  bool _loading = false;
  String _message = "";

  // Função de recuperação de senha
  Future<void> _resetPassword() async {
    setState(() {
      _loading = true;
      _message = "";
    });

    try {
      await Supabase.instance.client.auth
          .resetPasswordForEmail(_email.text.trim());

      setState(() {
        _message = "📩 Email de recuperação enviado!";
      });
    } catch (e) {
      setState(() {
        _message = "❌ Erro: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Esqueceu a senha")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: "Digite seu email")),
              const SizedBox(height: 20),

              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _resetPassword,
                child: const Text("Enviar email"),
              ),

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
