import 'package:flutter/material.dart';
import '../../../models/familiar_group.dart';
import '../../../services/familiar_groups_service.dart';

class FamiliarGroupFormPage extends StatefulWidget {
  final FamiliarGroup? grupo;

  const FamiliarGroupFormPage({super.key, this.grupo});

  @override
  State<FamiliarGroupFormPage> createState() => _FamiliarGroupFormPageState();
}

class _FamiliarGroupFormPageState extends State<FamiliarGroupFormPage> {
  final _formKey = GlobalKey<FormState>();
  final FamiliarGroupService _grupoService = FamiliarGroupService();

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
      backgroundColor: Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Editar Grupo' : 'Novo Grupo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F2937), Color(0xFF111827)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome do Grupo',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Ex: Grupo Família Abençoada',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.group, color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFF374151),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Líder',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Ex: João e Maria Silva',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFF374151),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Ex: Rua das Flores, 123',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.location_on, color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFF374151),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Horário',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Ex: Quintas às 19h30',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.access_time, color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFF374151),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'WhatsApp',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Ex: https://wa.me/5511999999999',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFF374151),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF4B5563)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
                  ),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                            ? Color(0xFF1F2937)
                            : Color(0xFF374151),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFFDC2626)
                              : Color(0xFF4B5563),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        entry.value,
                        size: 32,
                        color: isSelected
                            ? Color(0xFFDC2626)
                            : Color(0xFF9CA3AF),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Seletor de Cor
              const Text(
                'Cor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                          color: isSelected ? Colors.white : Color(0xFF4B5563),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
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
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Color(0xFF9CA3AF),
                        side: BorderSide(color: Color(0xFF4B5563)),
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
                        backgroundColor: Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
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
      ),
    );
  }

  Future<void> _saveGrupo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final grupo = FamiliarGroup(
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
              backgroundColor: Color(0xFFDC2626),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
