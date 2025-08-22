import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

/// Tela de cadastro de usuário.
/// Stateful para controlar os campos e o estado de loading do botão.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers para capturar os dados digitados pelo usuário
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _church = TextEditingController();

  // Controla estado de carregamento do botão
  bool _loading = false;

  // Controla se a senha está visível ou oculta
  bool _obscurePassword = true;

  /// Função de registro no Supabase
  Future<void> _register() async {
    setState(() => _loading = true); // Ativa loading

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _password.text.trim(),
        data: {
          'name': _name.text.trim(),
          'phone': _phone.text.trim(),
          'church': _church.text.trim(),
        },
      );

      // Se o usuário for criado com sucesso, navega para a home
      if (res.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // Mostra erro caso falhe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erro no registro: $e")),
      );
    } finally {
      setState(() => _loading = false); // Desativa loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removido AppBar para tela limpa
      body: Container(
        // Fundo com gradiente radial padrão do app
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
                // Campo de nome
                CustomInput(hint: "Seu Nome Completo", controller: _name),
                const SizedBox(height: 16),

                // Campo de telefone
                CustomInput(
                  hint: "Seu Celular (DDD+Número)",
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Campo de email
                CustomInput(
                  hint: "Seu Email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Campo de senha com botão de visibilidade
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

                // Campo de igreja
                CustomInput(hint: "Qual Igreja Frequenta?", controller: _church),
                const SizedBox(height: 24),

                // Botão principal de cadastro
                CustomButton(
                  text: "Cadastrar",
                  loading: _loading,
                  onPressed: _register,
                ),
                const SizedBox(height: 20),

                // Botão transparente para voltar ao login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // transparente
                      shadowColor: Colors.transparent, // remove sombra
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
