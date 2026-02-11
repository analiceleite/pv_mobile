import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';
import 'forms/event_form_page.dart';

class AdminEventsPage extends StatefulWidget {
  const AdminEventsPage({super.key});

  @override
  State<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends State<AdminEventsPage> {
  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Colors.white,
        title: const Text('Gerenciar Eventos'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Evento'),
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
        child: StreamBuilder<List<Event>>(
          stream: _eventService.getEventsStream(),
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
                      'Erro ao carregar cultos',
                      style: TextStyle(fontSize: 18, color: Color(0xFFDC2626)),
                    ),
                  ],
                ),
              );
            }

            final eventos = snapshot.data ?? [];

            if (eventos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.church, size: 64, color: Color(0xFF9CA3AF)),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum evento cadastrado',
                      style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _navigateToForm(context),
                      icon: const Icon(Icons.add, color: Color(0xFFDC2626)),
                      label: const Text('Adicionar primeiro evento'),
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
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return _buildEventCard(context, evento);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event evento) {
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
              color: evento.getColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(evento.getIcon(), color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${evento.dia} às ${evento.horario}',
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
                  evento.descricao,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _navigateToForm(context, evento: evento),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF60A5FA),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _confirmDelete(context, evento),
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

  Future<void> _navigateToForm(BuildContext context, {Event? evento}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventFormPage(culto: evento)),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            evento == null
                ? 'Evento criado com sucesso!'
                : 'Evento atualizado com sucesso!',
          ),
          backgroundColor: Color(0xFF059669),
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, Event evento) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF374151),
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Deseja realmente excluir o evento "${evento.titulo}"?',
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

    if (confirm == true && evento.id != null) {
      final success = await _eventService.deleteEvent(evento.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Evento excluído com sucesso!' : 'Erro ao excluir evento',
            ),
            backgroundColor: success ? Color(0xFF059669) : Color(0xFFDC2626),
          ),
        );
      }
    }
  }
}
