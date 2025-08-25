import 'package:flutter/material.dart';

class ConteudoMateriaisTab extends StatelessWidget {
  const ConteudoMateriaisTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Lista de PDFs, slides ou links de apoio.",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
