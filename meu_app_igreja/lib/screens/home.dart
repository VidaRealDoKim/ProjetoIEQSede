// -----------------------------------------------------------------------------
// Importações principais do Flutter
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Importações internas (telas vinculadas às abas da HomePage)
// -----------------------------------------------------------------------------
import 'inicio/inicio_page.dart';
import 'conteudo/conteudo_page.dart';
import 'eventos/eventos_page.dart';
import 'aovivo/ao_vivo_page.dart';
import 'mais/mais_page.dart';

// -----------------------------------------------------------------------------
// Classe HomePage
// Tela principal exibida após o login, contendo navegação por abas inferiores.
// -----------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Índice da aba atualmente selecionada no BottomNavigationBar
  int _selectedIndex = 0;

  /// Lista de páginas que serão exibidas de acordo com o índice selecionado
  final List<Widget> _pages = const [
    ConteudoPage(), // Página de Conteúdo
    EventosPage(),  // Página de Eventos
    InicioPage(),   // Página Inicial
    AoVivoPage(),   // Página de Transmissões ao Vivo
    MaisPage(),     // Página de Configurações/Opções adicionais
  ];

  /// Função responsável por atualizar o índice ao tocar em um item da barra
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Corpo da página exibindo a tela correspondente ao índice selecionado
      body: _pages[_selectedIndex],

      // -----------------------------------------------------------------------
      // Barra de navegação inferior (BottomNavigationBar)
      // Responsável por permitir a troca entre as principais telas do app.
      // -----------------------------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Aba ativa
        onTap: _onItemTapped,         // Atualiza índice ao clicar
        type: BottomNavigationBarType.fixed,

        // Estilo da barra
        backgroundColor: const Color(0xFF2B2B2B), // Preto escuro de fundo

        // Estilo dos itens selecionados
        selectedItemColor: Colors.white, // Branco
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),

        // Estilo dos itens não selecionados
        unselectedItemColor: Colors.grey, // Cinza para contraste
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),

        // Exibe labels mesmo quando não selecionados
        showUnselectedLabels: true,

        // Itens de navegação (rotas principais do app)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Conteúdo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Eventos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: "Ao Vivo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "Mais",
          ),
        ],
      ),
    );
  }
}
