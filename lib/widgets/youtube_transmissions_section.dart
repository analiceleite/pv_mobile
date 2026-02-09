import 'package:flutter/material.dart';
import '../config/youtube_config.dart';
import 'youtube_live_list.dart';

class YouTubeTransmissionsSection extends StatelessWidget {
  const YouTubeTransmissionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade900, Colors.grey.shade800],
        ),
      ),
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
                colors: [Colors.red.shade700, Colors.red.shade900],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'TRANSMISSÕES AO VIVO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Cultos e Eventos',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Acompanhe as transmissões mais recentes dos nossos cultos direto do YouTube',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          // YouTube Videos List com scroll horizontal
          SizedBox(
            width: double.infinity,
            child: YouTubeLiveList(
              channelId: YouTubeConfig.channelId,
              apiKey: YouTubeConfig.apiKey,
              maxResults: YouTubeConfig.maxResults,
            ),
          ),
          const SizedBox(height: 20),
          // Botão para ver todos
          FilledButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Ver todos no YouTube'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () {
              // TODO: Implementar navegação para o YouTube
              // _launchYouTubeChannel();
            },
          ),
        ],
      ),
    );
  }
}
