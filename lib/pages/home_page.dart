import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/start_section.dart';
import '../widgets/transmissions_section.dart';
import '../widgets/agenda_section.dart';
import '../widgets/pictures_section.dart';
import '../widgets/groups_section.dart';
import '../widgets/offer_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer.dart';
import '../services/auth_service.dart';
import 'admin/admin_login_page.dart';
import 'admin/admin_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: const EdgeInsets.only(top: 60),
          children: [
            _menuItem(context, 'Início'),
            _menuItem(context, 'Transmissões'),
            _menuItem(context, 'Agenda'),
            _menuItem(context, 'Fotos'),
            _menuItem(context, 'Grupos'),
            _menuItem(context, 'Ofertas'),
            _menuItem(context, 'Contato'),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
              ),
              title: const Text(
                'Administração',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Verificar se está logado
                final authService = AuthService();
                if (authService.isLoggedIn) {
                  // Já está logado, ir direto para admin
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminHomePage(),
                    ),
                  );
                } else {
                  // Não está logado, ir para tela de login
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminLoginPage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Header(),
            StartSection(),
            TransmissionsSection(),
            AgendaSection(),
            PicturesSection(),
            GroupsSection(),
            OfferSection(),
            ContactSection(),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pop(context),
    );
  }
}
