import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/culto.dart';
import '../../services/culto_service.dart';

class CultoFormPage extends StatefulWidget {
  final Culto? culto;

  const CultoFormPage({super.key, this.culto});

  @override
  State<CultoFormPage> createState() => _CultoFormPageState();
}

class _CultoFormPageState extends State<CultoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final CultoService _cultoService = CultoService();

  late TextEditingController _diaController;
  late TextEditingController _horarioController;
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;

  String _selectedIcon = 'church';
  String _selectedColor = '#B71C1C';
  bool _isLoading = false;

  final Map<String, IconData> _availableIcons = {
    'church': Icons.church,
    'groups': Icons.groups,
    'favorite': Icons.favorite,
    'celebration': Icons.celebration,
    'people': Icons.people,
    'event': Icons.event,
  };

  final List<Map<String, String>> _availableColors = [
    {'name': 'Vermelho', 'hex': '#B71C1C'},
    {'name': 'Laranja', 'hex': '#E65100'},
    {'name': 'Azul', 'hex': '#1565C0'},
    {'name': 'Verde', 'hex': '#2E7D32'},
    {'name': 'Roxo', 'hex': '#6A1B9A'},
    {'name': 'Cinza Escuro', 'hex': '#424242'},
  ];

  @override
  void initState() {
    super.initState();
    _diaController = TextEditingController(text: widget.culto?.dia ?? '');
    _horarioController = TextEditingController(
      text: widget.culto?.horario ?? '',
    );
    _tituloController = TextEditingController(text: widget.culto?.titulo ?? '');
    _descricaoController = TextEditingController(
      text: widget.culto?.descricao ?? '',
    );

    if (widget.culto != null) {
      _selectedIcon = widget.culto!.iconName;
      _selectedColor = widget.culto!.colorHex;
    }
  }

  @override
  void dispose() {
    _diaController.dispose();
    _horarioController.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.culto != null;

    return Scaffold(
      backgroundColor: Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Editar Culto' : 'Novo Culto'),
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
              // Campo Título
              TextFormField(
                controller: _tituloController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Título do Culto',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Ex: Culto de Celebração',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.title, color: Color(0xFF9CA3AF)),
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
                    return 'Por favor, informe o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Dia
              TextFormField(
                controller: _diaController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Dia da Semana',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Ex: Domingo',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Color(0xFF9CA3AF),
                  ),
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
                    return 'Por favor, informe o dia';
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
                  hintText: 'Ex: 19h00',
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

              // Campo Descrição
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  hintText: 'Descreva brevemente o culto',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.description, color: Color(0xFF9CA3AF)),
                  alignLabelWithHint: true,
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
                    return 'Por favor, informe a descrição';
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
                      onPressed: _isLoading ? null : _saveCulto,
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

  Future<void> _saveCulto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final culto = Culto(
        id: widget.culto?.id,
        dia: _diaController.text.trim(),
        horario: _horarioController.text.trim(),
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        iconName: _selectedIcon,
        colorHex: _selectedColor,
      );

      bool success;
      if (widget.culto == null) {
        // Criar novo
        final id = await _cultoService.createCulto(culto);
        success = id != null;
      } else {
        // Atualizar existente
        success = await _cultoService.updateCulto(widget.culto!.id!, culto);
      }

      if (mounted) {
        if (success) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao salvar culto'),
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
