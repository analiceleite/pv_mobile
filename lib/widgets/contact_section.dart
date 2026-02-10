import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Mostra dialog com tempo de chegada baseado na localização do usuário
  Future<void> _showDirectionsDialog(BuildContext context) async {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _DirectionsDialog(onOpenMaps: _launchUrl);
      },
    );
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
                    _buildAddressCard(context),
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
                    Expanded(flex: 2, child: _buildAddressCard(context)),
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
          '📞 Telefone: (47) 9925-3311',
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
                'https://wa.me/554799253311?text=Olá%20Pastor,%20gostaria%20de%20conversar.';
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
  Widget _buildAddressCard(BuildContext context) {
    return _ContactCard(
      icon: Icons.location_on,
      title: 'Endereço da Igreja',
      description: 'Visite nossa igreja e participe dos cultos presenciais.',
      children: [
        const Text(
          '📍 Rua Fátima, 2597 - Fátima\nJoinville, SC',
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
            _showDirectionsDialog(context);
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
        'https://www.google.com/maps/dir/-26.3389184,-48.807936/R.+F%C3%A1tima,+2597+-+F%C3%A1tima,+Joinville+-+SC,+89229-102/@-26.3381633,-48.8142453,17z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x94deb147b5af363d:0x2b8b2b199cf9652d!2m2!1d-48.8172902!2d-26.3376893?entry=ttu&g_ep=EgoyMDI2MDIwNC4wIKXMDSoASAFQAw%3D%3D';

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

/// Dialog que obtém localização do usuário e calcula tempo de chegada
class _DirectionsDialog extends StatefulWidget {
  final Function(String) onOpenMaps;

  const _DirectionsDialog({required this.onOpenMaps});

  @override
  State<_DirectionsDialog> createState() => _DirectionsDialogState();
}

class _DirectionsDialogState extends State<_DirectionsDialog> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _travelTime;
  String? _distance;
  Position? _userLocation;

  @override
  void initState() {
    super.initState();
    _loadDirections();
  }

  Future<void> _loadDirections() async {
    try {
      // Obtém localização do usuário
      final position = await LocationService.getUserLocation();

      if (position == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Não foi possível obter sua localização.\n\nVerifique as permissões em Configurações.';
        });
        return;
      }

      setState(() {
        _userLocation = position;
      });

      // Tenta obter informações de rota da API do Google Maps
      final routeInfo = await LocationService.getRouteInfo(position);

      if (routeInfo != null) {
        setState(() {
          _travelTime = routeInfo['duration'];
          _distance = routeInfo['distance'];
          _isLoading = false;
        });
      } else {
        // Se falhar, calcula distância simples
        final distanceKm = LocationService.calculateDistanceKm(
          position.latitude,
          position.longitude,
        );

        // Estima tempo (40 km/h em zona urbana)
        final estimatedMinutes = ((distanceKm / 40 * 60).ceil());

        setState(() {
          _distance = '${distanceKm.toStringAsFixed(1)} km';
          _travelTime = LocationService.estimateArrivalTime(
            estimatedMinutes * 60,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao calcular rota: $e';
      });
    }
  }

  void _openMapsWithDirections() {
    if (_userLocation != null) {
      final mapsUrl = LocationService.buildMapsUrl(
        _userLocation!.latitude,
        _userLocation!.longitude,
      );
      widget.onOpenMaps(mapsUrl);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('📍 Como Chegar'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                'Obtendo sua localização...',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
            ] else if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Icon(
                Icons.location_disabled,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tempo de chegada',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _travelTime ?? '...',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.straighten,
                          size: 20,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Distância',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _distance ?? '...',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '📍 Igreja PV Joinville\nRua Fátima, 2597 - Fátima, Joinville, SC',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (!_isLoading && _errorMessage == null)
          ElevatedButton.icon(
            onPressed: _openMapsWithDirections,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.map),
            label: const Text('Abrir Google Maps'),
          ),
      ],
    );
  }
}
