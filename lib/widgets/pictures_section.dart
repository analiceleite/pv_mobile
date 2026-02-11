import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PicturesSection extends StatelessWidget {
  const PicturesSection({super.key});

  static const String _googleDriveUrl =
      'https://drive.google.com/drive/folders/1Bjpl6t__N5OcT2Jf6apZc9Jq_KzknwZJ?usp=sharing';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Color(0xFF1F2937),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  // Botão reutilizável para acessar Google Drive
  Widget _buildDriveButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFDC2626),
        foregroundColor: Colors.white,
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        final Uri url = Uri.parse(_googleDriveUrl);
        try {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('Erro ao abrir Google Drive: $e');
          // Tenta abrir de forma alternativa
          try {
            await launchUrl(url);
          } catch (e2) {
            debugPrint('Erro alternativo ao abrir Google Drive: $e2');
          }
        }
      },
      icon: const Icon(Icons.photo_album),
      label: const Text(
        'Ver Fotos no Drive',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
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
              const Icon(Icons.cloud, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Fotos dos Cultos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildDriveButton(),
            ],
          ),
        ),

        const SizedBox(width: 40),

        // 🔹 Lado direito — tutorial com tópicos
        Expanded(
          flex: 2,
          child: _buildTutorialCard(
            steps: const [
              'Clique no botão "Ver Fotos no Drive" ao lado esquerdo.',
              'Você será redirecionado para o Google Drive oficial da igreja.',
              'Escolha a pasta do culto que deseja visualizar.',
              'Clique na foto desejada para abrir ou baixar.',
            ],
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'FOTOS',
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
          'Galeria de Fotos',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Acesse as fotos dos nossos cultos e eventos',
          style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),

        // 🔹 Bloco com ícone e botão
        _buildCardContainer(
          child: Column(
            children: [
              const Icon(Icons.cloud, color: Colors.white, size: 60),
              const SizedBox(height: 12),
              const Text(
                'Fotos dos Cultos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildDriveButton(),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 🔹 Bloco com tutorial
        _buildTutorialCard(
          steps: const [
            'Toque em "Ver Fotos no Drive".',
            'Acesse a pasta do culto desejado.',
            'Visualize ou baixe as fotos diretamente.',
          ],
        ),
      ],
    );
  }

  // Widget auxiliar para card com container estilizado
  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF374151),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Widget para card de tutorial
  Widget _buildTutorialCard({required List<String> steps}) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Como acessar suas fotos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            steps.length,
            (index) =>
                _TutorialStep(number: '${index + 1}', text: steps[index]),
          ),
        ],
      ),
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
            backgroundColor: Color(0xFFDC2626),
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
                color: Color(0xFF9CA3AF),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
