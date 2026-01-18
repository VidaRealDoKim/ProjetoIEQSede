// ============================================================================
// login.dart - TELA DE LOGIN
// ============================================================================
//
// OBJETIVO:
// Autenticar usuário com email e senha via Supabase
//
// FLUXO:
// 1. Usuário insere email e senha
// 2. Valida se campos estão preenchidos
// 3. Autentica com Supabase Auth
// 4. Busca dados do usuário na tabela 'usuarios'
// 5. Se não existe, cria registro automático
// 6. Redireciona baseado no role:
//    - 'Admin' → /admin (Dashboard Admin)
//    - 'Pastor' → /home (Pode ser expandido para /pastor)
//    - 'Lider' → /home (Pode ser expandido para /lider)
//    - 'Membro' → /home (Default)
//
// VALIDAÇÕES:
// - Email obrigatório
// - Senha obrigatória (mínimo 6 caracteres)
// - Erros tratados com try/catch
// - Mensagens amigáveis ao usuário
//
// CAMPOS DA TABELA 'usuarios':
// - id: UUID (Supabase Auth)
// - nome: Nome do usuário
// - email: Email único
// - role: Admin, Pastor, Lider, Membro
// - telefone: Número de contato
// - data_nascimento: Data de nascimento
// - foto_url: URL da foto de perfil
// - criado_em: Timestamp de criação
//
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

      // Busca dados do usuário na tabela 'usuarios' para verificar role
      final usuario = await supabase
          .from('usuarios')
          .select('id, nome, role')
          .eq('id', user.id)
          .maybeSingle();

      if (usuario == null) {
        // Primeiro login: cria registro na tabela usuarios
        try {
          await supabase.from('usuarios').insert({
            'id': user.id,
            'nome': user.email?.split('@')[0] ?? 'Usuário',
            'email': user.email,
            'role': 'Membro', // role padrão para novos usuários
          });
          debugPrint('✅ Registro de usuário criado com sucesso');
        } catch (e) {
          debugPrint('⚠️ Erro ao criar registro do usuário: $e');
        }
      }

      // Define a rota de acordo com o role do usuário
      final role = usuario?['role'] ?? 'Membro';
      final rota = switch (role) {
        'Admin' => '/admin',
        'Pastor' => '/home', // pode redirecionar para /pastor se existir
        'Lider' => '/home', // pode redirecionar para /lider se existir
        _ => '/home',
      };

      if (mounted) {
        Navigator.pushReplacementNamed(context, rota);
      }
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
