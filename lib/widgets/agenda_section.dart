import 'package:flutter/material.dart';

class AgendaSection extends StatelessWidget {
  const AgendaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cultos = [
      {'dia': 'Domingo', 'horario': '10h e 19h'},
      {'dia': 'Quarta-feira', 'horario': '19h30'},
      {'dia': 'Sexta-feira', 'horario': '20h (Oração)'},
    ];

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agenda de Cultos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...cultos.map(
            (c) => ListTile(
              leading: const Icon(Icons.schedule, color: Colors.black),
              title: Text(
                c['dia']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(c['horario']!),
            ),
          ),
        ],
      ),
    );
  }
}
