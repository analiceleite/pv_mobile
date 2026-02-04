import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/grupo_familiar.dart';
import '../../services/grupo_familiar_service.dart';

class GrupoFormPage extends StatefulWidget {
  final GrupoFamiliar? grupo;

  const GrupoFormPage({super.key, this.grupo});

  @override
  State<GrupoFormPage> createState() => _GrupoFormPageState();
}

class _GrupoFormPageState extends State<GrupoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final GrupoFamiliarService _grupoService = GrupoFamiliarService();

  late TextEditingController _nomeController;
  late TextEditingController _enderecoController;
  late TextEditingController _liderController;
  late TextEditingController _horarioController;
  late TextEditingController _whatsappController;

  String _selectedIcon = 'location_city';
  String _selectedColor = '#1F2937';
  bool _isLoading = false;

  final Map<String, IconData> _availableIcons = {
    'location_city': Icons.location_city,
    'home': Icons.home,
    'home_work': Icons.home_work,
    'groups': Icons.groups,
    'people': Icons.people,
    'group': Icons.group,
  };

  final List<Map<String, String>> _availableColors = [
    {'name': 'Cinza Escuro', 'hex': '#1F2937'},
    {'name': 'Cinza Médio', 'hex': '#374151'},
    {'name': 'Cinza Claro', 'hex': '#4B5563'},
    {'name': 'Azul', 'hex': '#1565C0'},
    {'name': 'Verde', 'hex': '#2E7D32'},
    {'name': 'Roxo', 'hex': '#6A1B9A'},
  ];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.grupo?.nome ?? '');
    _enderecoController = TextEditingController(
      text: widget.grupo?.endereco ?? '',
    );
    _liderController = TextEditingController(text: widget.grupo?.lider ?? '');
    _horarioController = TextEditingController(
      text: widget.grupo?.horario ?? '',
    );
    _whatsappController = TextEditingController(
      text: widget.grupo?.whatsapp ?? '',
    );

    if (widget.grupo != null) {
      _selectedIcon = widget.grupo!.iconName;
      _selectedColor = widget.grupo!.colorHex;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _liderController.dispose();
    _horarioController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.grupo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Grupo' : 'Novo Grupo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo Nome
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Grupo',
                hintText: 'Ex: Grupo Família Abençoada',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo Líder
            TextFormField(
              controller: _liderController,
              decoration: const InputDecoration(
                labelText: 'Líder',
                hintText: 'Ex: João e Maria Silva',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o líder';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo Endereço
            TextFormField(
              controller: _enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                hintText: 'Ex: Rua das Flores, 123',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o endereço';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo Horário
            TextFormField(
              controller: _horarioController,
              decoration: const InputDecoration(
                labelText: 'Horário',
                hintText: 'Ex: Quintas às 19h30',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o horário';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo WhatsApp
            TextFormField(
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'WhatsApp',
                hintText: 'Ex: https://wa.me/5511999999999',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o WhatsApp';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Seletor de Ícone
            const Text(
              'Ícone',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableIcons.entries.map((entry) {
                final isSelected = _selectedIcon == entry.key;
                return InkWell(
                  onTap: () => setState(() => _selectedIcon = entry.key),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.grey300
                          : AppColors.greyLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.grey800
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      entry.value,
                      size: 32,
                      color: isSelected ? AppColors.grey800 : AppColors.grey600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Seletor de Cor
            const Text(
              'Cor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableColors.map((colorMap) {
                final hex = colorMap['hex']!;
                final isSelected = _selectedColor == hex;
                final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));

                return InkWell(
                  onTap: () => setState(() => _selectedColor = hex),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.grey900
                            : AppColors.grey300,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: AppColors.light)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveGrupo,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.grey800,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.light,
                              ),
                            ),
                          )
                        : Text(isEditing ? 'Atualizar' : 'Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveGrupo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final grupo = GrupoFamiliar(
        id: widget.grupo?.id,
        nome: _nomeController.text.trim(),
        endereco: _enderecoController.text.trim(),
        lider: _liderController.text.trim(),
        horario: _horarioController.text.trim(),
        whatsapp: _whatsappController.text.trim(),
        iconName: _selectedIcon,
        colorHex: _selectedColor,
      );

      bool success;
      if (widget.grupo == null) {
        // Criar novo
        final id = await _grupoService.createGrupo(grupo);
        success = id != null;
      } else {
        // Atualizar existente
        success = await _grupoService.updateGrupo(widget.grupo!.id!, grupo);
      }

      if (mounted) {
        if (success) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao salvar grupo'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
