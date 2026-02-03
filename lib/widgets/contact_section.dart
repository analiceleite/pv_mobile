import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade700, Colors.grey.shade900],
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
              'CONTATO',
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
            'Venha Nos Conhecer',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Layout
          isMobile
              ? Column(
                  children: [
                    _buildPastorContactCard(),
                    const SizedBox(height: 24),
                    _buildAddressCard(),
                    const SizedBox(height: 24),
                    _buildMapCard(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: _buildPastorContactCard()),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: _buildAddressCard()),
                    const SizedBox(width: 24),
                    Expanded(flex: 3, child: _buildMapCard()),
                  ],
                ),
        ],
      ),
    );
  }

  // 📞 Card do Pastor
  Widget _buildPastorContactCard() {
    return _ContactCard(
      icon: Icons.phone,
      title: 'Fale com o Pastor',
      description: 'Entre em contato diretamente com o Pastor João.',
      children: [
        const Text(
          '📞 Telefone: (11) 99999-9999',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            const whatsappUrl =
                'https://wa.me/5511999999999?text=Olá%20Pastor,%20gostaria%20de%20conversar.';
            launchUrl(
              Uri.parse(whatsappUrl),
              mode: LaunchMode.externalApplication,
            );
          },
          icon: const Icon(Icons.chat),
          label: const Text('Falar pelo WhatsApp'),
        ),
      ],
    );
  }

  // 📍 Card de endereço
  Widget _buildAddressCard() {
    return _ContactCard(
      icon: Icons.location_on,
      title: 'Endereço da Igreja',
      description: 'Visite nossa igreja e participe dos cultos presenciais.',
      children: [
        const Text(
          '📍 Rua das Oliveiras, 45 - Centro\nSão Paulo, SP',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            const mapsUrl =
                'https://www.google.com/maps/dir/?api=1&destination=-23.55052,-46.633308';
            launchUrl(Uri.parse(mapsUrl), mode: LaunchMode.externalApplication);
          },
          icon: const Icon(Icons.map),
          label: const Text('Como chegar'),
        ),
      ],
    );
  }

  // 🗺️ Mapa incorporado ou imagem com botão
  Widget _buildMapCard() {
    const embedUrl =
        'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3576.2046372447267!2d-48.81872272368524!3d-26.319872368696483!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x94deb16d92270513%3A0x81cfe7a619a3921f!2sR.%20F%C3%A1tima%2C%202597%20-%20F%C3%A1tima%2C%20Joinville%20-%20SC%2C%2089229-102!5e0!3m2!1spt-BR!2sbr!4v1761068904839!5m2!1spt-BR!2sbr';

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Usa uma imagem fake (print do mapa)
          Image.asset('assets/background_shirlei.jpg', fit: BoxFit.cover),

          // Sobreposição escura + botão central
          Container(
            color: Colors.black.withOpacity(0.35),
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Quando clicar, abre o link embed direto
                launchUrl(
                  Uri.parse(embedUrl),
                  mode: LaunchMode.externalApplication,
                );
              },
              icon: const Icon(Icons.map),
              label: const Text('Ver no Google Maps'),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Estrutura base dos cards
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Widget> children;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.red.shade700),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
