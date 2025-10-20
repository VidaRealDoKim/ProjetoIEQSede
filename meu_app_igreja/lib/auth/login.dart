// ============================================================================
// login.dart
// Tela de login com autenticação via Supabase (email e senha)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores dos campos
  final _email = TextEditingController();
  final _password = TextEditingController();

  // Estados de UI
  bool _obscurePassword = true;
  bool _loading = false;

  // ==========================================================================
  // Função de login com Supabase
  // ==========================================================================
  Future<void> _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showSnack("⚠️ Preencha todos os campos");
      return;
    }

    setState(() => _loading = true);

    try {
      final supabase = Supabase.instance.client;

      // Autenticação por email/senha
      final response = await supabase.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      final user = response.user;
      if (user == null) {
        _showSnack("❌ E-mail ou senha incorretos");
        return;
      }

      // Busca tipo de perfil (admin, pastor, líder, membro)
      final perfil = await supabase
          .from('perfis')
          .select('tipo_usuario')
          .eq('id', user.id)
          .maybeSingle();

      if (perfil == null) {
        _showSnack("⚠️ Perfil não encontrado");
        return;
      }

      // Define a rota de acordo com o tipo de usuário
      final rota = switch (perfil['tipo_usuario']) {
        'admin' => '/admin',
        'pastor' => '/pastor',
        'lider' => '/lider',
        _ => '/home',
      };

      Navigator.pushReplacementNamed(context, rota);
    } on AuthException catch (e) {
      _showSnack("Erro de autenticação: ${e.message}");
    } catch (e) {
      _showSnack("Erro inesperado: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  // Mostra uma mensagem simples na tela
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
        // Fundo com gradiente radial
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
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                // Logo
                SizedBox(
                  height: 80,
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(height: 40),

                // Campo Email
                CustomInput(
                  hint: "Seu Email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Campo Senha
                CustomInput(
                  hint: "Sua Senha",
                  controller: _password,
                  obscure: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFE8E8E8),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão Entrar
                CustomButton(
                  text: "Entrar",
                  loading: _loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 16),

                // Esqueci a senha
                _linkButton("Esqueci a senha", '/forgot'),
                const SizedBox(height: 16),

                // Cadastre-se
                _linkButton("Ainda não tem cadastro? Cadastre-se", '/register'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Cria botões de link reutilizáveis (ex: esqueci senha / cadastro)
  Widget _linkButton(String text, String route) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.barlow(
            fontSize: 14,
            color: const Color(0xFFE8E8E8),
          ),
        ),
      ),
    );
  }
}
