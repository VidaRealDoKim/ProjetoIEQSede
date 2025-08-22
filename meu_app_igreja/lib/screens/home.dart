import 'package:flutter/material.dart';

/// Página principal que será exibida após o login.
/// Contém um menu inferior (BottomNavigationBar) com 5 abas:
/// Início, Conteúdo, Eventos, Ao Vivo e Mais.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Índice da aba atualmente selecionada no menu inferior.
  /// Começa em 0 (Início).
  int _selectedIndex = 0;

  /// Lista de páginas que correspondem a cada item do menu inferior.
  /// Por enquanto, cada página é apenas um `Center` com texto.
  /// Depois você pode trocar por telas completas (ex: ConteudoPage, EventosPage, etc).
  final List<Widget> _pages = const [
    Center(child: Text("🏠 Página Inicial", style: TextStyle(fontSize: 22))),
    Center(child: Text("📖 Conteúdo", style: TextStyle(fontSize: 22))),
    Center(child: Text("📅 Eventos", style: TextStyle(fontSize: 22))),
    Center(child: Text("🎥 Ao Vivo", style: TextStyle(fontSize: 22))),
    Center(child: Text("☰ Mais opções", style: TextStyle(fontSize: 22))),
  ];

  /// Função chamada quando o usuário toca em um item do menu inferior.
  /// Atualiza o `_selectedIndex` para mudar a página exibida.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Exibe a página correspondente ao índice selecionado
      body: _pages[_selectedIndex],

      /// Menu inferior de navegação
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Item atualmente ativo
        onTap: _onItemTapped, // Função chamada ao clicar
        type: BottomNavigationBarType.fixed, // Mantém todos os ícones visíveis
        selectedItemColor: Colors.blue, // Cor do item selecionado
        unselectedItemColor: Colors.grey, // Cor dos itens não selecionados

        /// Itens do menu inferior
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
