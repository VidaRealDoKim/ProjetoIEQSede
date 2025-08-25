// -----------------------------------------------------------------------------
// Importações principais do Flutter e pacotes externos
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// -----------------------------------------------------------------------------
// Importações internas (sistema de autenticação e telas principais)
// -----------------------------------------------------------------------------
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';
import 'screens/home.dart';
import 'screens/admin/admin_dashboard.dart';

// -----------------------------------------------------------------------------
// Função principal do aplicativo
// Responsável por inicializar configurações essenciais antes de rodar o app.
// -----------------------------------------------------------------------------
Future<void> main() async {
  // Garante que o Flutter esteja completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega variáveis de ambiente do arquivo `.env`
  // Necessário para obter as credenciais do Supabase (URL e Anon Key)
  await dotenv.load();

  try {
    // Inicializa a conexão com o Supabase usando as variáveis do .env
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,         // URL do projeto Supabase
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,// Chave pública do projeto
    );

    // Mensagem de sucesso no console
    print("✅ Supabase conectado com sucesso!");

  } catch (e) {
    // Caso ocorra erro na conexão com o Supabase
    print("❌ Erro ao conectar Supabase: $e");
  }

  // Executa o aplicativo principal
  runApp(const MyApp());
}

// -----------------------------------------------------------------------------
// Classe principal do aplicativo
// Define a estrutura base (MaterialApp) e o gerenciamento de rotas.
// -----------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove a faixa vermelha "DEBUG" no canto superior direito
      debugShowCheckedModeBanner: false,

      // Define a tela inicial ao abrir o app
      initialRoute: '/login',

      // -----------------------------------------------------------------------
      // Rotas nomeadas do aplicativo
      // Cada rota mapeia para uma página específica.
      // -----------------------------------------------------------------------
      routes: {
        '/login':   (context) => const LoginPage(),          // Tela de Login
        '/register':(context) => const RegisterPage(),       // Tela de Registro
        '/forgot':  (context) => const ForgotPasswordPage(), // Tela de Recuperação de Senha
        '/home':    (context) => const HomePage(),           // Tela Principal (Home)
        '/admin':   (context) => const AdminDashboardPage(), // Tela de Administração
      },
    );
  }
}
