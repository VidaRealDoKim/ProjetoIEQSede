import 'package:flutter/material.dart';

// importa das outras screens
import 'inicio_page.dart';
import 'conteudo_page.dart';
import 'eventos_page.dart';
import 'ao_vivo_page.dart';
import 'mais_page.dart';

/// Página principal exibida após o login
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  /// Lista de páginas que serão mostradas em cada aba
  final List<Widget> _pages = const [
    ConteudoPage(),
    EventosPage(),
    InicioPage(),
    AoVivoPage(),
    MaisPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      /// Menu inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Conteúdo"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Eventos"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "Ao Vivo"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "Mais"),
        ],
      ),
    );
  }
}
