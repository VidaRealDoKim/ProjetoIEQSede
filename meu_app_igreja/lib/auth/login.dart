import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

/// Tela de login do app.
/// Stateful porque precisamos controlar o estado de campos, senha visível/oculta e loading do botão.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers para capturar o texto digitado nos campos
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // Controla se a senha está visível ou oculta
  bool _obscurePassword = true;

  // Controla estado de carregamento do botão de login
  bool _loading = false;

  /// Função para realizar login usando Supabase
  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (res.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ Email ou senha incorretos",
              style: GoogleFonts.barlow(),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "❌ Erro: $e",
            style: GoogleFonts.barlow(),
          ),
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fundo com gradiente radial escuro, padrão do app
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo do app
                SizedBox(
                  height: 80,
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(height: 40),

                // Campo de email
                CustomInput(
                  hint: "Seu Email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Campo de senha com botão para mostrar/ocultar
                CustomInput(
                  hint: "Sua Senha",
                  controller: _password,
                  obscure: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFFE8E8E8),
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão principal de login com estilo uniforme (CustomButton)
                CustomButton(
                  text: "Entrar",
                  loading: _loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 16),

                // Botão transparente "Esqueci a senha"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Esqueci a senha",
                      style: GoogleFonts.barlow(
                        fontSize: 18,
                        color: const Color(0xFFE8E8E8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botão transparente "Ainda não tem cadastro?"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Ainda não tem cadastro? Cadastre-se",
                      style: GoogleFonts.barlow(
                        fontSize: 14,
                        color: const Color(0xFFE8E8E8),
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
