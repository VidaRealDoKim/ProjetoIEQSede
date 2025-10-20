// ============================================================================
// register.dart
// Tela de registro de novos usuários com integração ao Supabase
// ============================================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Instância do Supabase
  final supabase = Supabase.instance.client;

  // Controladores de campos de formulário
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _church = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  // ==========================================================================
  // Função de registro de novo usuário
  // ==========================================================================
  Future<void> _register() async {
    if (_name.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty ||
        _church.text.isEmpty) {
      _showSnack("⚠️ Preencha todos os campos obrigatórios");
      return;
    }

    setState(() => _loading = true);

    try {
      // 1️⃣ Cria o usuário na autenticação do Supabase
      final res = await supabase.auth.signUp(
        email: _email.text.trim(),
        password: _password.text.trim(),
        data: {
          'name': _name.text.trim(),
          'phone': _phone.text.trim(),
          'church': _church.text.trim(),
        },
      );

      final user = res.user;
      if (user == null) {
        _showSnack("❌ Erro ao criar usuário. Tente novamente.");
        return;
      }

      // 2️⃣ Insere o perfil básico do usuário na tabela `perfis`
      await supabase.from('perfis').insert({
        'id': user.id,
        'nome': _name.text.trim(),
        'telefone': _phone.text.trim(),
        'igreja': _church.text.trim(),
        'tipo_usuario': 'membro', // padrão
      });

      // 3️⃣ Redireciona para HomePage
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (e) {
      _showSnack("Erro de autenticação: ${e.message}");
    } catch (e) {
      _showSnack("❌ Erro inesperado: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  // Mostra mensagens simples via SnackBar
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
        // Fundo gradiente escuro
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Campos principais
                CustomInput(hint: "Seu Nome Completo", controller: _name),
                const SizedBox(height: 16),

                CustomInput(
                  hint: "Seu Celular (DDD + Número)",
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                CustomInput(
                  hint: "Seu Email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                CustomInput(
                  hint: "Sua Senha",
                  controller: _password,
                  obscure: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFFE8E8E8),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),

                CustomInput(
                  hint: "Qual Igreja Frequenta?",
                  controller: _church,
                ),
                const SizedBox(height: 24),

                // Botão principal
                CustomButton(
                  text: "Cadastrar",
                  loading: _loading,
                  onPressed: _register,
                ),
                const SizedBox(height: 20),

                // Botão de voltar
                _linkButton("Já tenho conta, voltar ao login", () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Botão secundário padronizado
  Widget _linkButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Já tenho conta, voltar ao login",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFE8E8E8),
          ),
        ),
      ),
    );
  }
}
