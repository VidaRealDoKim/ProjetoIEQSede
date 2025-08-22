import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  /// Função de login
  Future<void> _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showSnackBar("Preencha todos os campos!", isError: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (res.user != null) {
        _showSnackBar("✅ Login realizado com sucesso!", isError: false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (e) {
      _showSnackBar("❌ ${e.message}", isError: true);
    } catch (e) {
      _showSnackBar("❌ Erro inesperado: $e", isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Snackbar estilizada
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
      body: Container(
        // Fundo com gradiente radial
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.0,
            colors: [
              Color(0xFF2D2A2A), // 17%
              Color(0xFF0B0B0B), // 100%
            ],
            stops: [0.17, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------- LOGO ----------
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
                const SizedBox(height: 40),

                // ---------- CAMPO EMAIL ----------
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Color(0xFFE8E8E8)),
                  decoration: InputDecoration(
                    hintText: "Seu Email",
                    hintStyle: const TextStyle(color: Color(0xFFE8E8E8)),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDE6D56), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- CAMPO SENHA ----------
                TextField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Color(0xFFE8E8E8)),
                  decoration: InputDecoration(
                    hintText: "Sua Senha",
                    hintStyle: const TextStyle(color: Color(0xFFE8E8E8)),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDE6D56), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFE8E8E8),
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ---------- BOTÃO ENTRAR ----------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDE6D56),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFE8E8E8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- ESQUECI A SENHA ----------
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot'),
                  child: const Text(
                    "Esqueci a senha",
                    style: TextStyle(color: Color(0xFFE8E8E8)),
                  ),
                ),
                const SizedBox(height: 60),

                // ---------- CADASTRO ----------
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    "Ainda não tem cadastro? Cadastre-se",
                    style: TextStyle(color: Color(0xFFE8E8E8), fontSize: 14),
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
