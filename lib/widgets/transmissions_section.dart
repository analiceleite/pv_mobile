import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        'iconGradient': [
          const Color(0xFFFF6B35),
          const Color(0xFFF7931E),
        ], // Laranja vibrante
        'iconColor': const Color(0xFFFF6B35),
        'onPressed': () async {
          final Uri url = Uri.parse('https://radiorefugio.com.br');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.inAppWebView);
          }
        },
      },
      {
        'icon': Icons.live_tv,
        'title': 'YouTube - Ao Vivo',
        'description':
            'Assista aos cultos, estudos bíblicos e eventos especiais transmitidos diretamente do templo. Live todo domingo às 18h30.',
        'button': 'Assistir Live',
        'iconGradient': [
          const Color(0xFFFF0000),
          const Color(0xFFCC0000),
        ], // Vermelho YouTube
        'iconColor': const Color(0xFFFF0000),
        'onPressed': () async {
          final Uri url = Uri.parse(
            'https://www.youtube.com/@comunidadepalavradavida1632/streams',
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.inAppWebView);
          }
        },
      },
      {
        'icon': Icons.facebook,
        'title': 'Facebook',
        'description':
            'Receba mensagens inspiradoras, transmissões ao vivo e eventos direto na sua timeline.',
        'button': 'Seguir no Facebook',
        'iconGradient': [
          const Color(0xFF1877F2),
          const Color(0xFF0C63D4),
        ], // Azul Facebook
        'iconColor': const Color(0xFF1877F2),
        'onPressed': () async {
          final Uri url = Uri.parse(
            'https://www.facebook.com/pages/Comunidade%20Crist%C3%A3%20Palavra%20da%20Vida/522804331174409/#',
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.inAppWebView);
          }
        },
      },
      {
        'icon': Icons.camera_alt,
        'title': 'Instagram',
        'description':
            'Veja fotos dos cultos, bastidores e momentos especiais da nossa família em Cristo.',
        'button': 'Seguir no Instagram',
        'iconGradient': [
          const Color(0xFF833AB4), // Roxo
          const Color(0xFFC13584), // Rosa
          const Color(0xFFFD1D1D), // Vermelho
          const Color(0xFFFCAF45), // Laranja
        ], // Gradiente Instagram
        'iconColor': const Color(0xFFE1306C),
        'onPressed': () async {
          final Uri url = Uri.parse(
            'https://www.instagram.com/comunidadepalavradavida/',
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.inAppWebView);
          }
        },
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xFF1F2937)),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isMobile ? 24 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'CONECTE-SE CONOSCO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Mídias & Transmissões',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Acompanhe nossa programação 24 horas',
            style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),

          // Cards
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
                      .map((item) => _buildCard(item, context, width: 300))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildCard(
    Map<String, dynamic> item,
    BuildContext context, {
    double? width,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color(0xFF374151),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com gradiente colorido
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item['iconGradient'] as List<Color>,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    size: 32,
                    color: item['iconColor'] as Color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['description'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9CA3AF),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: item['onPressed'] as void Function(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDC2626).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['button'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
