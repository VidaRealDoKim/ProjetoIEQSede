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
  final supabase = Supabase.instance.client;

  // Controladores de campos
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _church = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  // ---------------------------------------------------------------------------
  // Registro de usuário
  // ---------------------------------------------------------------------------
  Future<void> _register() async {
    setState(() => _loading = true);

    try {
      // 1. Criar usuário no Auth
      final res = await supabase.auth.signUp(
        email: _email.text.trim(),
        password: _password.text.trim(),
        data: {
          'name': _name.text.trim(),
          'phone': _phone.text.trim(),
          'church': _church.text.trim(),
        },
      );

      if (res.user != null) {
        final userId = res.user!.id;

        // 2. Inserir também na tabela `perfis`
        await supabase.from('perfis').insert({
          'id': userId, // mesmo id do auth.users
          'nome': _name.text.trim(),
          'telefone': _phone.text.trim(),
          'igreja': _church.text.trim(),
          'tipo_usuario': 'membro', // default
        });

        // 3. Redireciona
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erro no registro: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                CustomInput(hint: "Seu Nome Completo", controller: _name),
                const SizedBox(height: 16),
                CustomInput(
                  hint: "Seu Celular (DDD+Número)",
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
                CustomButton(
                  text: "Cadastrar",
                  loading: _loading,
                  onPressed: _register,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
