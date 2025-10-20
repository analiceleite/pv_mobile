import 'package:flutter/material.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contato e Localização',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text('📍 Endereço: Rua das Oliveiras, 45 - Centro'),
          Text('📞 Telefone: (11) 99999-9999'),
          Text('📧 Email: contato@palavradavida.org'),
        ],
      ),
    );
  }
}
