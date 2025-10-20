import 'package:flutter/material.dart';

class TransmissionsSection extends StatelessWidget {
  const TransmissionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'label': 'Ouvir Rádio', 'icon': Icons.radio},
      {'label': 'Assistir Live', 'icon': Icons.live_tv},
      {'label': 'Seguir no Facebook', 'icon': Icons.facebook},
      {'label': 'Seguir no Instagram', 'icon': Icons.camera_alt},
    ];

    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transmissões',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: buttons.map((b) {
              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(160, 50),
                ),
                onPressed: () {},
                icon: Icon(b['icon'] as IconData),
                label: Text(b['label'] as String),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
