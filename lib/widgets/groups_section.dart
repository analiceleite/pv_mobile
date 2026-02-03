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
            Column(
              children: _filteredGroups
                  .map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildGroupCard(g),
                    ),
                  )
                  .toList(),
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
      width: 320,
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
                GestureDetector(
                  onTap: () async {
                    final url = g.whatsapp;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade600, Colors.red.shade700],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
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
              ],
            ),
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
