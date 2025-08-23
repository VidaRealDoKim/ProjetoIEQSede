// -----------------------------------------------------------------------------
// Importações principais do Flutter e pacotes externos
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// -----------------------------------------------------------------------------
// Importações internas (widgets customizados do projeto)
// -----------------------------------------------------------------------------
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

// -----------------------------------------------------------------------------
// Classe LoginPage
// Tela de login do app, exibida antes do acesso à HomePage.
// Possui autenticação via Supabase, campos customizados e botões de navegação.
// -----------------------------------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ---------------------------------------------------------------------------
  // Controladores de texto (capturam valores dos campos de email e senha)
  // ---------------------------------------------------------------------------
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // Controla se a senha será exibida em texto ou ocultada
  bool _obscurePassword = true;

  // Controla estado de carregamento do botão de login
  bool _loading = false;

  // ---------------------------------------------------------------------------
  // Função de login
  // Realiza autenticação usando Supabase com email/senha.
  // Em caso de sucesso, redireciona para a HomePage.
  // Em caso de erro, exibe mensagem via SnackBar.
  // ---------------------------------------------------------------------------
  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (res.user != null) {
        // Login bem-sucedido → redireciona para a tela inicial
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Credenciais inválidas
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
      // Erro de conexão ou interno
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

  // ---------------------------------------------------------------------------
  // Construção da interface (UI)
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fundo com gradiente radial escuro (tema padrão do app)
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
                // -------------------------------------------------------------
                // Logo do app
                // -------------------------------------------------------------
                SizedBox(
                  height: 80,
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(height: 40),

                // -------------------------------------------------------------
                // Campo de Email
                // -------------------------------------------------------------
                CustomInput(
                  hint: "Seu Email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // Campo de Senha (com botão de visibilidade)
                // -------------------------------------------------------------
                CustomInput(
                  hint: "Sua Senha",
                  controller: _password,
                  obscure: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFFE8E8E8),
                    ),
                    onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // -------------------------------------------------------------
                // Botão principal de login
                // -------------------------------------------------------------
                CustomButton(
                  text: "Entrar",
                  loading: _loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // Botão "Esqueci a senha"
                // -------------------------------------------------------------
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

                // -------------------------------------------------------------
                // Botão "Cadastre-se"
                // -------------------------------------------------------------
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
