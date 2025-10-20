import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          '© 2025 Igreja Palavra da Vida - Todos os direitos reservados',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
