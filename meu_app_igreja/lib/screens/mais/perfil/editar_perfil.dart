import 'package:flutter/material.dart';
import 'widgets/card_secao.dart';
import 'secoes/dados_basicos.dart';
import 'secoes/contato.dart';
import 'secoes/dados_adicionais.dart';
import 'secoes/documentos.dart';
import 'secoes/igreja.dart';

/// =============================================
/// Tela de Edição de Perfil
/// =============================================
/// - Redirecionada a partir de perfil.dart
/// - Organiza a edição do perfil em **cards expansíveis**
/// - Cada card mostra:
///     - Ícone da seção
///     - Título da seção
///     - Porcentagem de conclusão
///     - Conteúdo da seção (formulário interno)
class EditarPerfilPage extends StatelessWidget {
  const EditarPerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          /// -----------------------------------------
          /// Card de Dados Básicos
          /// -----------------------------------------
          CardSecao(
            titulo: 'Dados Básicos',
            icone: Icons.person,
            porcentagem: 0.5, // exemplo: 50% preenchido
            conteudo: DadosBasicosPage(),
          ),

          /// -----------------------------------------
          /// Card de Contato
          /// -----------------------------------------
          CardSecao(
            titulo: 'Contato',
            icone: Icons.contact_mail,
            porcentagem: 0.3, // exemplo: 30% preenchido
            conteudo: ContatoPage(),
          ),

          /// -----------------------------------------
          /// Card de Dados Adicionais
          /// -----------------------------------------
          CardSecao(
            titulo: 'Dados Adicionais',
            icone: Icons.school,
            porcentagem: 0.2, // exemplo: 20% preenchido
            conteudo: DadosAdicionaisPage(),
          ),

          /// -----------------------------------------
          /// Card de Documentos
          /// -----------------------------------------
          CardSecao(
            titulo: 'Documentos',
            icone: Icons.folder,
            porcentagem: 0.1, // exemplo: 10% preenchido
            conteudo: DocumentosPage(),
          ),

          /// -----------------------------------------
          /// Card de Igreja
          /// -----------------------------------------
          CardSecao(
            titulo: 'Igreja',
            icone: Icons.account_balance,
            porcentagem: 0.0, // exemplo: não preenchido
            conteudo: IgrejaPage(),
          ),
        ],
      ),
    );
  }
}
