import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Importa as telas que vamos criar depois
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';
import 'screens/home.dart';

Future<void> main() async {
  // Garante que o Flutter está inicializado antes de qualquer coisa
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega variáveis do arquivo .env (SUPABASE_URL e SUPABASE_ANON_KEY)
  await dotenv.load();

  try {
    // Inicializa o Supabase com os dados do .env
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    print("✅ Supabase conectado com sucesso!");
  } catch (e) {
    print("❌ Erro ao conectar Supabase: $e");
  }

  // Inicia o app
  runApp(const MyApp());
}

// Classe principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove a faixa "debug"
      initialRoute: '/login', // tela inicial será a de login
      routes: {
        // Mapeamento das rotas para as telas
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
