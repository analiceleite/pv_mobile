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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Chaves globais para cada seção
  final GlobalKey _inicioKey = GlobalKey();
  final GlobalKey _transmissoesKey = GlobalKey();
  final GlobalKey _agendaKey = GlobalKey();
  final GlobalKey _fotosKey = GlobalKey();
  final GlobalKey _gruposKey = GlobalKey();
  final GlobalKey _ofertasKey = GlobalKey();
  final GlobalKey _contatoKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 300), () {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final offset = renderBox.localToGlobal(Offset.zero).dy;
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: const EdgeInsets.only(top: 60),
          children: [
            _menuItem(context, 'Início', Icons.home, _inicioKey),
            _menuItem(
              context,
              'Transmissões',
              Icons.videocam,
              _transmissoesKey,
            ),
            _menuItem(context, 'Agenda', Icons.calendar_month, _agendaKey),
            _menuItem(context, 'Fotos', Icons.photo_library, _fotosKey),
            _menuItem(context, 'Grupos', Icons.people, _gruposKey),
            _menuItem(context, 'Ofertas', Icons.card_giftcard, _ofertasKey),
            _menuItem(context, 'Contato', Icons.email, _contatoKey),
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
        controller: _scrollController,
        child: Column(
          children: [
            Header(),
            StartSection(key: _inicioKey, scrollController: _scrollController),
            TransmissionsSection(key: _transmissoesKey),
            AgendaSection(key: _agendaKey),
            PicturesSection(key: _fotosKey),
            GroupsSection(key: _gruposKey),
            OfferSection(key: _ofertasKey),
            ContactSection(key: _contatoKey),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    String title,
    IconData icon,
    GlobalKey key,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => _scrollToSection(key),
    );
  }
}
