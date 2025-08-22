import 'package:flutter/material.dart';

/// Card de Conteúdo (exibe imagem, título e subtítulo)
class ContentCard extends StatelessWidget {
  /// URL da imagem que será exibida no card
  final String imageUrl;

  /// Título principal
  final String title;

  /// Subtítulo (informação complementar)
  final String subtitle;

  /// Função chamada quando o usuário toca no card
  final VoidCallback onTap;

  const ContentCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // dispara a função passada no construtor
      child: Container(
        width: 280, // largura fixa do card
        margin: const EdgeInsets.only(right: 12), // espaçamento lateral
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Imagem com cantos arredondados
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover, // cobre todo o espaço sem distorcer
                height: 160,
                width: 280,
              ),
            ),

            const SizedBox(height: 8), // espaço entre imagem e título

            /// Título do conteúdo
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// Subtítulo
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
