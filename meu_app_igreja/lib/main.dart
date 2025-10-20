// ============================================================================
// main.dart
// Inicialização do app Flutter com Supabase e rotas principais
// ============================================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Telas do app
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';
import 'screens/home.dart';
import 'screens/admin/admin_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega variáveis de ambiente (.env) contendo URL e Anon Key do Supabase
  await dotenv.load();

  // Inicializa conexão com Supabase
  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    debugPrint("✅ Conexão Supabase estabelecida!");
  } catch (e) {
    debugPrint("❌ Falha ao conectar ao Supabase: $e");
  }

  runApp(const MyApp());
}

// ============================================================================
// Classe principal do aplicativo
// Responsável por definir o MaterialApp, tema e rotas nomeadas
// ============================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove o selo DEBUG
      title: "Igreja App",
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminDashboardPage(),
      },

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
    );
  }
}
