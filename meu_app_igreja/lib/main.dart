// Importações principais do Flutter e pacotes externos
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Importa as telas (arquivos criados dentro do projeto)
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';
import 'screens/home.dart';

/// Função principal que inicializa o app
Future<void> main() async {
  // Garante que o Flutter esteja totalmente inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega variáveis do arquivo .env (ex.: SUPABASE_URL e SUPABASE_ANON_KEY)
  await dotenv.load();

  try {
    // Inicializa a conexão com o Supabase usando as variáveis carregadas
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!, // URL do seu projeto Supabase
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!, // Chave pública do projeto
    );
    print("✅ Supabase conectado com sucesso!");
  } catch (e) {
    // Captura e exibe erro caso a inicialização falhe
    print("❌ Erro ao conectar Supabase: $e");
  }

  // Executa o aplicativo
  runApp(const MyApp());
}

/// Classe principal do aplicativo
/// Define o MaterialApp e as rotas iniciais
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa vermelha "DEBUG"
      initialRoute: '/login', // Define a tela inicial do app (login)
      routes: {
        // Mapeamento das rotas nomeadas para cada tela
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
