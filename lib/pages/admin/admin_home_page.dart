import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:igrejapv_mobile/pages/admin/admin_events_page.dart';
import 'admin_pix_page.dart';
import 'admin_familiar_groups_page.dart';
import '../../services/auth_service.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Colors.white,
        title: const Text('Painel Administrativo'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Botão de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Color(0xFF374151),
                  title: const Text(
                    'Confirmar saída',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Deseja realmente sair?',
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
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFFDC2626),
                      ),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F2937), Color(0xFF111827)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.admin_panel_settings,
                    size: 80,
                    color: Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Área Administrativa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gerencie eventos, grupos e contribuições do aplicativo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 50),

                  // Card Gerenciar Eventos
                  _buildAdminCard(
                    context,
                    title: 'Gerenciar Eventos da Agenda',
                    subtitle: 'Adicionar, editar ou remover eventos da agenda',
                    icon: Icons.church,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminEventsPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Card Gerenciar Grupos
                  _buildAdminCard(
                    context,
                    title: 'Gerenciar Grupos Familiares',
                    subtitle: 'Adicionar, editar ou remover grupos',
                    icon: Icons.groups,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminFamiliarGroupsPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Card Configurações PIX
                  _buildAdminCard(
                    context,
                    title: 'Configurações de Contribuição',
                    subtitle: 'Gerenciar chave PIX e dados de contribuição',
                    icon: Icons.payment,
                    color: Color(0xFFDC2626),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPixPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Botão Voltar
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF9CA3AF),
                    ),
                    label: const Text(
                      'Voltar ao Site',
                      style: TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF4B5563)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      color: Color(0xFF374151),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 92, 134, 207),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
