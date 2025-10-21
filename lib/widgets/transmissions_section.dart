import 'package:flutter/material.dart';

class TransmissionsSection extends StatelessWidget {
  const TransmissionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final items = [
      {
        'icon': Icons.radio,
        'title': 'Rádio Online',
        'description':
            'Música gospel, pregações inspiradoras e programas especiais que edificam sua fé.',
        'button': 'Ouvir agora',
        'onPressed': () {},
      },
      {
        'icon': Icons.live_tv,
        'title': 'YouTube - Ao Vivo',
        'description':
            'Assista aos cultos, estudos bíblicos e eventos especiais transmitidos diretamente do templo. Live todo domingo às 18h30.',
        'button': 'Assistir Live',
        'onPressed': () {},
      },
      {
        'icon': Icons.facebook,
        'title': 'Facebook',
        'description':
            'Receba mensagens inspiradoras, transmissões ao vivo e eventos direto na sua timeline.',
        'button': 'Seguir no Facebook',
        'onPressed': () {},
      },
      {
        'icon': Icons.camera_alt,
        'title': 'Instagram',
        'description':
            'Veja fotos dos cultos, bastidores e momentos especiais da nossa família em Cristo.',
        'button': 'Seguir no Instagram',
        'onPressed': () {},
      },
    ];

    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Transmissões',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),

          // Layout responsivo: Grid em telas grandes, coluna em mobile
          isMobile
              ? Column(
                  children: items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildCard(item, context),
                        ),
                      )
                      .toList(),
                )
              : Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: items
                      .map((item) => _buildCard(item, context, width: 280))
                      .toList(),
                ),
        ],
      ),
    );
  }

  // 🧱 Card de cada transmissão
  Widget _buildCard(
    Map<String, dynamic> item,
    BuildContext context, {
    double? width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item['icon'] as IconData, size: 48, color: Colors.black87),
          const SizedBox(height: 16),
          Text(
            item['title'] as String,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['description'] as String,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: item['onPressed'] as void Function(),
            child: Text(
              item['button'] as String,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
