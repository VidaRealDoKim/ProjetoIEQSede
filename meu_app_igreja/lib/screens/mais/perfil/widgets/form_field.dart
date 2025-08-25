import 'package:flutter/material.dart';

/// Widget helper para TextFormField no dark mode
class DarkFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType keyboardType;
  final VoidCallback? onTap;

  const DarkFormField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        fillColor: const Color(0xFF1E1E1E),
        filled: true,
        suffixIcon: readOnly ? const Icon(Icons.calendar_today, color: Colors.white) : null,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
