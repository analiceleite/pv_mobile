import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PicturesSection extends StatelessWidget {
  const PicturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fotos dos Cultos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
            ),
            onPressed: () async {
              const url = 'https://drive.google.com/drive/fotos-igreja';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            icon: const Icon(Icons.photo_album),
            label: const Text('Ver Fotos no Drive'),
          ),
        ],
      ),
    );
  }
}
