import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista de telas para cada aba
  final List<Widget> _pages = const [
    Center(child: Text("🏠 Página Inicial", style: TextStyle(fontSize: 22))),
    Center(child: Text("📖 Conteúdo", style: TextStyle(fontSize: 22))),
    Center(child: Text("📅 Eventos", style: TextStyle(fontSize: 22))),
    Center(child: Text("🎥 Ao Vivo", style: TextStyle(fontSize: 22))),
    Center(child: Text("☰ Mais opções", style: TextStyle(fontSize: 22))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Mostra a tela correspondente
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // mantém todos visíveis
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Conteúdo"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Eventos"),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "Ao Vivo"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "Mais"),
        ],
      ),
    );
  }
}
