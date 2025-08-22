import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela de registro de novos usuários.
/// Permite criar uma conta usando email e senha.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// Controlador do campo de email
  final TextEditingController _email = TextEditingController();

  /// Controlador do campo de senha
  final TextEditingController _password = TextEditingController();

  /// Indica se está processando o registro (para mostrar um loading)
  bool _loading = false;

  /// Mensagem de erro a ser exibida caso o registro falhe
  String _error = "";

  /// Função responsável por registrar o usuário no Supabase
  Future<void> _register() async {
    setState(() {
      _loading = true; // ativa o loading
      _error = "";      // limpa erros anteriores
    });

    try {
      // Faz o registro no Supabase usando email e senha
      final res = await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      // Se o registro for bem-sucedido, navega para a HomePage
      if (res.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // Se houver erro, armazena a mensagem para exibir ao usuário
      setState(() {
        _error = "❌ Erro no registro: $e";
      });
    } finally {
      // Desativa o loading, independentemente do sucesso ou falha
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar")),

      /// Corpo da tela
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de email
              TextField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: "Email")),

              const SizedBox(height: 20),

              // Campo de senha (oculta os caracteres)
              TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Senha")),

              const SizedBox(height: 30),

              // Botão de registrar ou indicador de carregamento
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: _register,
                  child: const Text("Registrar")),

              // Exibe mensagem de erro, se houver
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(_error, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
