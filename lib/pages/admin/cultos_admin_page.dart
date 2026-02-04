import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/culto.dart';
import '../../services/culto_service.dart';
import 'culto_form_page.dart';

class CultosAdminPage extends StatefulWidget {
  const CultosAdminPage({super.key});

  @override
  State<CultosAdminPage> createState() => _CultosAdminPageState();
}

class _CultosAdminPageState extends State<CultosAdminPage> {
  final CultoService _cultoService = CultoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Cultos'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Culto'),
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<List<Culto>>(
        stream: _cultoService.getCultosStream(),
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
                    color: AppColors.errorLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar cultos',
                    style: TextStyle(fontSize: 18, color: AppColors.error),
                  ),
                ],
              ),
            );
          }

          final cultos = snapshot.data ?? [];

          if (cultos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.church, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum culto cadastrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _navigateToForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar primeiro culto'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cultos.length,
            itemBuilder: (context, index) {
              final culto = cultos[index];
              return _buildCultoCard(context, culto);
            },
          );
        },
      ),
    );
  }

  Widget _buildCultoCard(BuildContext context, Culto culto) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Header colorido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: culto.getColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(culto.getIcon(), color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        culto.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${culto.dia} às ${culto.horario}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                Text(
                  culto.descricao,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),

                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _navigateToForm(context, culto: culto),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _confirmDelete(context, culto),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Excluir'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
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

  Future<void> _navigateToForm(BuildContext context, {Culto? culto}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CultoFormPage(culto: culto)),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            culto == null
                ? 'Culto criado com sucesso!'
                : 'Culto atualizado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, Culto culto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o culto "${culto.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && culto.id != null) {
      final success = await _cultoService.deleteCulto(culto.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Culto excluído com sucesso!' : 'Erro ao excluir culto',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
