import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para pegar os valores digitados
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // Controle de visualização da senha
  bool _obscurePassword = true;

  // Controle de loading e mensagens de erro
  bool _loading = false;
  String _error = "";

  // Função de login no Supabase
  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = "";
    });

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (res.user != null) {
        // Vai para a HomePage
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _error = "❌ Erro no login: $e";
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // Campo de Email
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),

              // Campo de Senha com botão 👁️
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

              // Botão de login
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _login, child: const Text("Entrar")),

              if (_error.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(_error, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 20),
              // Botão para ir para Registro
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("Criar conta"),
              ),
              // Botão para ir para Recuperação de Senha
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
