import 'package:flutter/material.dart';

class GroupsSection extends StatelessWidget {
  const GroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final grupos = [
      {
        'nome': 'Grupo Central',
        'endereco': 'Rua das Flores, 123',
        'lider': 'Carlos e Ana',
        'horario': 'Terça-feira, 20h',
      },
      {
        'nome': 'Grupo Norte',
        'endereco': 'Av. Esperança, 500',
        'lider': 'João e Marta',
        'horario': 'Quinta-feira, 19h30',
      },
      {
        'nome': 'Grupo Sul',
        'endereco': 'Rua Paz, 45',
        'lider': 'Ricardo e Paula',
        'horario': 'Sábado, 18h',
      },
    ];

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grupos Familiares',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: grupos.map((g) {
              return Card(
                elevation: 3,
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g['nome']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('📍 ${g['endereco']}'),
                      Text('👥 Líder: ${g['lider']}'),
                      Text('🕒 ${g['horario']}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
