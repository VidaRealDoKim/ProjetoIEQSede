import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela de login do usuário.
/// Permite entrar no app usando email e senha.
/// Possui recursos modernos:
/// - Mensagens de erro em SnackBars.
/// - Botão para salvar email.
/// - Botão para visualizar/ocultar a senha.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  /// Controle para mostrar ou ocultar a senha
  bool _obscurePassword = true;

  /// Indica se o app está processando login
  bool _loading = false;

  /// Indica se o usuário deseja salvar os dados
  bool _rememberMe = false;

  /// Função responsável por fazer login no Supabase
  Future<void> _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showSnackBar("Por favor, preencha todos os campos!", isError: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (res.user != null) {
        if (_rememberMe) {
          // Aqui você pode salvar o email/local storage
          // Exemplo simples usando SharedPreferences:
          // final prefs = await SharedPreferences.getInstance();
          // prefs.setString('saved_email', _email.text);
        }

        _showSnackBar("Login realizado com sucesso!", isError: false);

        // Navega para a HomePage
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (e) {
      _showSnackBar("❌ ${e.message}", isError: true);
    } catch (e) {
      _showSnackBar("❌ Ocorreu um erro: $e", isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Mostra uma SnackBar moderna
  void _showSnackBar(String message, {required bool isError}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 16)),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Campo de email
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de senha
              TextField(
                controller: _password,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Checkbox para salvar email
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                  ),
                  const Text("Salvar meus dados"),
                ],
              ),
              const SizedBox(height: 20),

              // Botão de login
              _loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Entrar", style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 20),

              // Botões de registro e recuperação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text("Criar conta"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot'),
                    child: const Text("Esqueceu a senha?"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
