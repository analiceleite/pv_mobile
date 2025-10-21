import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PicturesSection extends StatelessWidget {
  const PicturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  // 💻 Layout para telas grandes
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🔹 Lado esquerdo — ícone e botão
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.cloud, color: Colors.black, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Fotos dos Cultos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                label: const Text(
                  'Ver Fotos no Drive',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 40),

        // 🔹 Lado direito — tutorial com tópicos
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Como acessar suas fotos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                _TutorialStep(
                  number: '1',
                  text:
                      'Clique no botão “Ver Fotos no Drive” ao lado esquerdo.',
                ),
                _TutorialStep(
                  number: '2',
                  text:
                      'Você será redirecionado para o Google Drive oficial da igreja.',
                ),
                _TutorialStep(
                  number: '3',
                  text: 'Escolha a pasta do culto que deseja visualizar.',
                ),
                _TutorialStep(
                  number: '4',
                  text: 'Clique na foto desejada para abrir ou baixar.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 📱 Layout para mobile
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.cloud, color: Colors.black, size: 60),
        const SizedBox(height: 12),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Como acessar suas fotos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              _TutorialStep(
                number: '1',
                text: 'Toque em “Ver Fotos no Drive”.',
              ),
              _TutorialStep(
                number: '2',
                text: 'Acesse a pasta do culto desejado.',
              ),
              _TutorialStep(
                number: '3',
                text: 'Visualize ou baixe as fotos diretamente.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 🔹 Widget auxiliar para os passos do tutorial
class _TutorialStep extends StatelessWidget {
  final String number;
  final String text;

  const _TutorialStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.black,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
