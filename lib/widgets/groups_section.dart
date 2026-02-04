import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/grupo_familiar.dart';
import '../services/grupo_familiar_service.dart';

class GroupsSection extends StatefulWidget {
  const GroupsSection({super.key});

  @override
  State<GroupsSection> createState() => _GroupsSectionState();
}

class _GroupsSectionState extends State<GroupsSection> {
  final TextEditingController _searchController = TextEditingController();
  final GrupoFamiliarService _grupoService = GrupoFamiliarService();
  String _searchText = '';
  List<GrupoFamiliar> _allGroups = [];
  List<GrupoFamiliar> _filteredGroups = [];
  String? _loadingGroupId; // Para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await _grupoService.getGrupos();
    setState(() {
      _allGroups = groups;
      _filteredGroups = groups;
    });
  }

  void _filterGroups(String query) {
    setState(() {
      _searchText = query;
      if (query.isEmpty) {
        _filteredGroups = _allGroups;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredGroups = _allGroups.where((grupo) {
          return grupo.nome.toLowerCase().contains(lowerQuery) ||
              grupo.endereco.toLowerCase().contains(lowerQuery) ||
              grupo.lider.toLowerCase().contains(lowerQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isMobile ? 24 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔸 Badge
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
              'COMUNIDADE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Título
          const Text(
            'Grupos Familiares',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // 🔸 Descrição
          Text(
            'Encontre o grupo ideal para você e sua família',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // 🔍 Campo de pesquisa
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: TextField(
              controller: _searchController,
              onChanged: _filterGroups,
              decoration: InputDecoration(
                hintText: 'Pesquisar por grupo, líder ou endereço...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade600),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _filterGroups('');
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 🔸 Lista de grupos
          if (_filteredGroups.isEmpty)
            _buildEmptyState()
          else if (isMobile)
            SizedBox(
              height: 520,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filteredGroups.length,
                itemBuilder: (context, index) {
                  final g = _filteredGroups[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: SizedBox(width: 280, child: _buildGroupCard(g)),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 480,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: _filteredGroups.length,
                itemBuilder: (context, index) {
                  final g = _filteredGroups[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildGroupCard(g),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // 🔹 Card de cada grupo
  Widget _buildGroupCard(GrupoFamiliar g) {
    final color = g.getColor();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com ícone e nome
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(g.getIcon(), color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    g.nome,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Corpo do card
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.location_on, 'Endereço', g.endereco),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.people, 'Líder', g.lider),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.access_time, 'Horário', g.horario),
                const SizedBox(height: 24),

                // Botão WhatsApp
                _buildWhatsAppButton(g),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 Botão WhatsApp com validação
  Widget _buildWhatsAppButton(GrupoFamiliar g) {
    final isLoading = _loadingGroupId == g.id;

    return GestureDetector(
      onTap: isLoading ? null : () => _openWhatsApp(g),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [Colors.grey.shade600, Colors.grey.shade700]
                : [Colors.red.shade600, Colors.red.shade700],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isLoading ? Colors.grey : Colors.red).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8),
                    ),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      'Falar com o líder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // 🔸 Função para abrir WhatsApp
  Future<void> _openWhatsApp(GrupoFamiliar g) async {
    // Validar se tem telefone cadastrado
    if (g.whatsapp.isEmpty) {
      if (mounted) {
        _showErrorDialog(
          'Telefone não cadastrado',
          'Este grupo não possui um número de WhatsApp cadastrado.',
        );
      }
      return;
    }

    // Extrair apenas os números do telefone
    final phoneNumber = g.whatsapp.replaceAll(RegExp(r'[^0-9]'), '');

    if (phoneNumber.isEmpty) {
      if (mounted) {
        _showErrorDialog(
          'Telefone inválido',
          'O número de telefone cadastrado é inválido.',
        );
      }
      return;
    }

    // Formatar para o padrão WhatsApp (com código de país se necessário)
    final formattedPhone = phoneNumber.startsWith('55')
        ? phoneNumber
        : '55$phoneNumber'; // Assumindo Brasil

    // Criar URL do WhatsApp
    final whatsappUrl =
        'https://wa.me/$formattedPhone?text=Olá,%20gostaria%20de%20saber%20mais%20sobre%20o%20grupo%20${g.nome}';

    setState(() => _loadingGroupId = g.id);

    try {
      final Uri uri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          _showErrorDialog(
            'WhatsApp não disponível',
            'Não foi possível abrir o WhatsApp. Certifique-se de que está instalado.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
          'Erro',
          'Ocorreu um erro ao tentar abrir o WhatsApp: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingGroupId = null);
      }
    }
  }

  // 🔸 Diálogo de erro
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // 🔸 Linha de informação (ícone + label + valor)
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 Estado vazio
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Nenhum grupo encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar por outro termo',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
