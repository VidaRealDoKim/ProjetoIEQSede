// -----------------------------------------------------------------------------
// Importações principais do Flutter e pacotes externos
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// Importações internas (widgets customizados do projeto)
// -----------------------------------------------------------------------------
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

// -----------------------------------------------------------------------------
// Classe RegisterPage
// Tela de cadastro de usuário.
// Permite criar uma conta com nome, celular, email, senha e igreja.
// -----------------------------------------------------------------------------
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ---------------------------------------------------------------------------
  // Controladores dos campos de entrada
  // Usados para capturar o texto digitado pelo usuário
  // ---------------------------------------------------------------------------
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _church = TextEditingController();

  // Estado de carregamento do botão
  bool _loading = false;

  // Estado de visibilidade da senha
  bool _obscurePassword = true;

  // ---------------------------------------------------------------------------
  // Função de registro no Supabase
  // - Cria usuário com email e senha
  // - Armazena dados extras (nome, telefone, igreja) em `user_metadata`
  // - Redireciona para Home se sucesso
  // ---------------------------------------------------------------------------
  Future<void> _register() async {
    setState(() => _loading = true);

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

      // Sucesso: usuário criado
      if (res.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // Erro durante o cadastro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erro no registro: $e")),
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
      // Sem AppBar → tela mais limpa
      body: Container(
        // Fundo com gradiente radial (tema padrão do app)
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
                // -------------------------------------------------------------
                // Campo: Nome Completo
                // -------------------------------------------------------------
                CustomInput(hint: "Seu Nome Completo", controller: _name),
                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // Campo: Telefone
                // -------------------------------------------------------------
                CustomInput(
                  hint: "Seu Celular (DDD+Número)",
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // Campo: Email
                // -------------------------------------------------------------
                CustomInput(
                  hint: "Seu Email",
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // Campo: Senha (com botão mostrar/ocultar)
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
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // Campo: Igreja
                // -------------------------------------------------------------
                CustomInput(
                  hint: "Qual Igreja Frequenta?",
                  controller: _church,
                ),
                const SizedBox(height: 24),

                // -------------------------------------------------------------
                // Botão principal de cadastro
                // -------------------------------------------------------------
                CustomButton(
                  text: "Cadastrar",
                  loading: _loading,
                  onPressed: _register,
                ),
                const SizedBox(height: 20),

                // -------------------------------------------------------------
                // Botão secundário transparente (voltar ao login)
                // -------------------------------------------------------------
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
