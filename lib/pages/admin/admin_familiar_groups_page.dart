import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/familiar_group.dart';
import '../../services/familiar_groups_service.dart';
import 'forms/familiar_group_form_page.dart';

class AdminFamiliarGroupsPage extends StatefulWidget {
  const AdminFamiliarGroupsPage({super.key});

  @override
  State<AdminFamiliarGroupsPage> createState() => _AdminFamiliarGroupsPageState();
}

class _AdminFamiliarGroupsPageState extends State<AdminFamiliarGroupsPage> {
  final FamiliarGroupService _grupoService = FamiliarGroupService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Colors.white,
        title: const Text('Gerenciar Grupos Familiares'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Grupo'),
        backgroundColor: Color(0xFFDC2626),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F2937), Color(0xFF111827)],
          ),
        ),
        child: Column(
          children: [
            // Campo de busca
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por nome, líder ou endereço...',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xFF9CA3AF),
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Color(0xFF374151),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
                ),
              ),
            ),

            // Lista de grupos
            Expanded(
              child: StreamBuilder<List<FamiliarGroup>>(
                stream: _grupoService.getGruposStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Color(0xFFDC2626),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erro ao carregar grupos',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  var grupos = snapshot.data ?? [];

                  // Filtrar grupos se houver busca
                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    grupos = grupos.where((g) {
                      return g.nome.toLowerCase().contains(query) ||
                          g.lider.toLowerCase().contains(query) ||
                          g.endereco.toLowerCase().contains(query);
                    }).toList();
                  }

                  if (grupos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.groups,
                            size: 64,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Nenhum grupo cadastrado'
                                : 'Nenhum grupo encontrado',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_searchQuery.isEmpty)
                            TextButton.icon(
                              onPressed: () => _navigateToForm(context),
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xFFDC2626),
                              ),
                              label: const Text('Adicionar primeiro grupo'),
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFFDC2626),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: grupos.length,
                    itemBuilder: (context, index) {
                      final grupo = grupos[index];
                      return _buildGrupoCard(context, grupo);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrupoCard(BuildContext context, FamiliarGroup grupo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Color(0xFF374151),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Header colorido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: grupo.getColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(grupo.getIcon(), color: AppColors.light, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    grupo.nome,
                    style: const TextStyle(
                      color: AppColors.light,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Corpo do card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.location_on, grupo.endereco),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.people, 'Líder: ${grupo.lider}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, grupo.horario),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone, grupo.whatsapp),
                const SizedBox(height: 16),

                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _navigateToForm(context, grupo: grupo),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF60A5FA),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _confirmDelete(context, grupo),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Excluir'),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFF9CA3AF)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToForm(
    BuildContext context, {
    FamiliarGroup? grupo,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FamiliarGroupFormPage(grupo: grupo)),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            grupo == null
                ? 'Grupo criado com sucesso!'
                : 'Grupo atualizado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, FamiliarGroup grupo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF374151),
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Deseja realmente excluir o grupo "${grupo.nome}"?',
          style: TextStyle(color: Color(0xFF9CA3AF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Color(0xFFDC2626)),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && grupo.id != null) {
      final success = await _grupoService.deleteGrupo(grupo.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Grupo excluído com sucesso!' : 'Erro ao excluir grupo',
            ),
            backgroundColor: success ? Color(0xFF059669) : Color(0xFFDC2626),
          ),
        );
      }
    }
  }
}
