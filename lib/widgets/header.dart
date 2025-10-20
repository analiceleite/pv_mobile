import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.jpg',
              height: 36,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, color: Colors.white54),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Igreja PV',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Abrir menu',
            ),
          ),
        ],
      ),
    );
  }
}
