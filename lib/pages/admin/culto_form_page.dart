import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Culto' : 'Novo Culto'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo Título
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título do Culto',
                hintText: 'Ex: Culto de Celebração',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
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
              decoration: const InputDecoration(
                labelText: 'Dia da Semana',
                hintText: 'Ex: Domingo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
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
              decoration: const InputDecoration(
                labelText: 'Horário',
                hintText: 'Ex: 19h00',
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

            // Campo Descrição
            TextFormField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Descreva brevemente o culto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
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
                          ? Colors.red.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      entry.value,
                      size: 32,
                      color: isSelected ? Colors.red : Colors.grey.shade700,
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
                        color: isSelected ? Colors.black : Colors.grey.shade300,
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
                    onPressed: _isLoading ? null : _saveCulto,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red.shade700,
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
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
