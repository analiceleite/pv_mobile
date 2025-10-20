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
