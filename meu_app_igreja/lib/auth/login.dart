import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela de login do usuário.
/// Permite entrar no app usando email e senha.
/// Contém campos de entrada, botão de login e navegação para registro ou recuperação de senha.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Controlador do campo de email
  final TextEditingController _email = TextEditingController();

  /// Controlador do campo de senha
  final TextEditingController _password = TextEditingController();

  /// Controle para mostrar ou ocultar a senha
  bool _obscurePassword = true;

  /// Indica se a tela está processando login (para mostrar loading)
  bool _loading = false;

  /// Armazena mensagens de erro para exibir ao usuário
  String _error = "";

  /// Função responsável por fazer login no Supabase
  Future<void> _login() async {
    setState(() {
      _loading = true;  // Ativa indicador de carregamento
      _error = "";      // Limpa erros anteriores
    });

    try {
      // Realiza o login usando email e senha
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      // Se o login for bem-sucedido, navega para a HomePage
      if (res.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // Captura qualquer erro e exibe na tela
      setState(() {
        _error = "❌ Erro no login: $e";
      });
    } finally {
      // Desativa o loading, independentemente do resultado
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Corpo da tela centralizado
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título da tela
              const Text("Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // Campo de email
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),

              // Campo de senha com botão para visualizar/ocultar
              TextField(
                controller: _password,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Senha",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botão de login ou indicador de carregamento
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _login, child: const Text("Entrar")),

              // Mensagem de erro, se houver
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(_error, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 20),

              // Botão para ir para a tela de registro
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("Criar conta"),
              ),
              // Botão para ir para a tela de recuperação de senha
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/forgot'),
                child: const Text("Esqueceu a senha?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
